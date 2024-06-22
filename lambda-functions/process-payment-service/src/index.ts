import * as dotenv from 'dotenv';
import { Client } from 'pg';
import { DynamoDBDocumentClient, PutCommand, PutCommandInput } from '@aws-sdk/lib-dynamodb';
import { DynamoDBClient, DynamoDB } from '@aws-sdk/client-dynamodb';
import { DynamoDBDocument } from '@aws-sdk/lib-dynamodb';

dotenv.config();
const dynamoDbClient = new DynamoDBClient({});
const clientQuery = DynamoDBDocument.from(new DynamoDB({}));
const ddbDocClient = DynamoDBDocumentClient.from(dynamoDbClient);

const AppConstant = {
  DYNAMO_USER_PAYMENT_TABLE: 'vp_payment',
};

const PaymentStatus = {
  STARTED: 'STARTED',
  IN_PROGRESS: 'IN_PROGRESS',
  FINISHED: 'FINISHED',
};

const connectToDatabase = async (): Promise<Client> => {
  const client = new Client({
    host: process.env.RDS_HOST,
    user: process.env.RDS_USER,
    password: process.env.RDS_PASSWORD,
    database: process.env.RDS_DATABASE,
    port: Number(process.env.RDS_PORT) || 5432,
    ssl: {
      rejectUnauthorized: false,
    },
  });
  await client.connect();
  return client;
};

const fetchData = async (accountId: number): Promise<any> => {
  try {
    const client = await connectToDatabase();
    const query = 'SELECT username, balance FROM public."user" WHERE userId = $1';
    const values = [accountId];
    const res = await client.query(query, values);
    await client.end();
    if (res.rows.length === 0) {
      console.log('Account not found');
      return null;
    } else {
      return res.rows[0];
    }
  } catch (error) {
    console.log('Error executing query:', error);
    throw new Error('Error executing query: ' + (error as Error).message);
  }
};

//create transaction status
const createTransactionStatus = async (paymentId: number, status: string): Promise<any> => {
  try {
    const client = await connectToDatabase();
    const query = 'INSERT INTO public.transaction_status (paymentid, status) VALUES ($1, $2)';
    const values = [paymentId, status];
    const res = await client.query(query, values);
    await client.end();
    return res.rows[0];
  } catch (error) {
    console.error('Error executing query:', error);
    throw new Error('Error executing query: ' + (error as Error).message);
  }
};

const putItem = async (params: PutCommandInput) => {
  try {
    await ddbDocClient.send(new PutCommand(params));
    return params.Item;
  } catch (error) {
    console.log('Error putting item into DynamoDB', error);
    throw new Error('Error putting item into DynamoDB');
  }
};

const chargeAccount = async (event: any) => {
  try {
    const account = await fetchData(event.userId);
    console.log('Account:', account);
    const balance = (account as { balance: number }).balance;
    const amount = event.amount;

    console.log('Purchase successful');
    const newBalance = balance - amount;
    console.log('New balance:', newBalance);
    const client = await connectToDatabase();
    const query = `update public."user" set balance = ${newBalance} where userId = $1`;
    const values = [event.userId];
    await client.query(query, values);
    await client.end();

    putItem({
      TableName: AppConstant.DYNAMO_USER_PAYMENT_TABLE,
      Item: {
        userId: event.userId,
        paymentId: event.paymentId,
        amount: event.amount,
        stepId: 3,
        status: 'FINISHED',
      },
    });

    createTransactionStatus(event.paymentId, 'SUCCESS');

    return {
      statusCode: 200,
      body: JSON.stringify({
        message: 'Successful transaction!',
      }),
      userId: event.userId,
      paymentId: event.paymentId,
      amount: event.amount,
      stepId: 3,
      status: 'FINISHED',
    };
  } catch (error) {
    putItem({
      TableName: AppConstant.DYNAMO_USER_PAYMENT_TABLE,
      Item: {
        userId: event.userId,
        paymentId: event.paymentId,
        amount: event.amount,
        stepId: 3,
        status: 'FAILED',
      },
    });

    createTransactionStatus(event.paymentId, 'FAILED');

    console.log('Error executing chargeAccount:', error);
    return {
      statusCode: 500,
      body: JSON.stringify({
        message: 'Charge account failed!',
        error: (error as Error).message,
      }),
      userId: event.userId,
      paymentId: event.paymentId,
      amount: event.amount,
      stepId: 3,
      status: 'FAILED',
    };
  }
};

export const handler = async (event: any) => {
  console.log('Processing payment...', event);
  return await chargeAccount(event);
};
