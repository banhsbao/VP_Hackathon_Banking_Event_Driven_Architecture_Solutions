import { DynamoDB, DynamoDBClient } from '@aws-sdk/client-dynamodb';
import { DynamoDBDocument, DynamoDBDocumentClient, GetCommandInput, PutCommand, PutCommandInput } from '@aws-sdk/lib-dynamodb';
import { Client } from 'pg';

const AppConstant = {
  DYNAMO_USER_PAYMENT_TABLE: 'vp_payment',
};

const PaymentStatus = {
  STARTED: 'STARTED',
  IN_PROGRESS: 'IN_PROGRESS',
  FINISHED: 'FINISHED',
};

interface IEvent {
  userId: number;
  paymentId: number;
  status: string;
  amount: number;
  stepId: number;
}

const dynamoDbClient = new DynamoDBClient({});
const clientQuery = DynamoDBDocument.from(new DynamoDB({}));
const ddbDocClient = DynamoDBDocumentClient.from(dynamoDbClient);

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

const fetchData = async (userId: number): Promise<any> => {
  try {
    const client = await connectToDatabase();
    const query = 'SELECT username, balance FROM public."user" WHERE userId = $1';
    const values = [userId];
    const res = await client.query(query, values);
    await client.end();
    if (res.rows.length === 0) {
      console.log('Account not found');
      return null;
    } else {
      return res.rows[0];
    }
  } catch (error) {
    console.error('Error executing query:', error);
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

const getItem = async (params: GetCommandInput) => {
  try {
    const data = await clientQuery.get(params);
    return data.Item;
  } catch (error) {
    console.log('Error getting item from DynamoDB', error);
    throw new Error('Error getting item from DynamoDB');
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

const checkBalance = async (event: IEvent) => {
  try {
    if (!event.userId || !event.amount || !event.paymentId) {
      console.log('Invalid request');
      return { statusCode: 400, body: JSON.stringify({ message: 'Invalid request' }) };
    }

    if (event.amount < 0) {
      console.log('Invalid amount');
      return { statusCode: 400, body: JSON.stringify({ message: 'Invalid amount' }) };
    }

    const account = await fetchData(event.userId);
    if (!account) {
      console.log('Account not found');
      return { statusCode: 404, body: JSON.stringify({ message: 'Account not found' }) };
    }

    console.log('Account:', account);
    const balance = (account as { balance: number }).balance;
    console.log('Balance:', balance);
    const amount = event.amount;
    console.log('Amount:', amount);
    const diff = balance - amount;
    console.log('Difference:', diff);

    if (diff >= 0) {
      console.log('Sufficient funds');
      putItem({
        TableName: AppConstant.DYNAMO_USER_PAYMENT_TABLE,
        Item: {
          userId: event.userId,
          paymentId: event.paymentId,
          amount: event.amount,
          stepId: 2,
          status: 'FINISHED',
        },
      });

      createTransactionStatus(event.paymentId, 'VALIDATED');
      return {
        statusCode: 200,
        body: JSON.stringify({ message: 'Sufficient funds' }),
        userId: event.userId,
        paymentId: event.paymentId,
        amount: event.amount,
        stepId: 2,
        status: 'FINISHED',
      };
    } else {
      console.log('Insufficient funds');
      return { statusCode: 400, body: JSON.stringify({ message: 'Transaction failed due to insufficient funds!' }) };
    }
  } catch (error) {
    putItem({
      TableName: AppConstant.DYNAMO_USER_PAYMENT_TABLE,
      Item: {
        userId: event.userId,
        paymentId: event.paymentId,
        amount: event.amount,
        stepId: 2,
        status: 'FAILED',
      },
    });

    createTransactionStatus(event.paymentId, 'FAILED');

    console.error('Error:', error);
    return {
      statusCode: 500,
      body: JSON.stringify({
        message: 'Internal Server Error',
        error: (error as Error).message,
      }),
      userId: event.userId,
      paymentId: event.paymentId,
      amount: event.amount,
      stepId: 2,
      status: 'FAILED',
    };
  }
};

export const handler = async (event: IEvent) => {
  console.log('Validating payment...', event);
  return await checkBalance(event);
};
