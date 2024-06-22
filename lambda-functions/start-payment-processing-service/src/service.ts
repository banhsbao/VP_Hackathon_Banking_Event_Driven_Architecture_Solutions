import { DynamoDBClient, PutItemCommand } from '@aws-sdk/client-dynamodb';

export const PaymentStatus = {
  STARTED: 'STARTED',
  IN_PROGRESS: 'IN_PROGRESS',
  FINISHED: 'FINISHED',
};
export interface ICreateUserPayment {
  userId: string; // required
  paymentId: string;
  status: string;
  amount: string;
  isPrimary: number;
  createAt: string;
  lastUpdateAt: string;
}
const client = new DynamoDBClient({});
export const createNewUserPaymentData = async (data: ICreateUserPayment) => {
  console.log('Create user payment data', data);
  const command = new PutItemCommand({
    TableName: 'vp_payment',
    Item: {
      userId: { S: `${data.userId}` },
      paymentId: { S: `${data.paymentId}` },
      status: { S: `${PaymentStatus.FINISHED}` },
      amount: { N: `${data.amount}` },
      stepId: { N: `1` },
      isPrimary: { N: `1` },
      createAt: { S: `${data.createAt}` },
      lastUpdateAt: { S: `${data.lastUpdateAt}` },
    },
  });
  const response = await client.send(command);
  return response;
};
