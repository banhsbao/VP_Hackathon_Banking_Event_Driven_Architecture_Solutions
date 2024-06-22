import { randomUUID } from 'crypto';
import { createNewUserPaymentData, ICreateUserPayment } from './service';
import { SFNClient, StartExecutionCommand } from '@aws-sdk/client-sfn';

const sfnClient = new SFNClient({});
const state_payment_arn = process.env.STATE_PAYMENT_ARN;
export const PaymentStatus = {
  STARTED: 'STARTED',
  IN_PROGRESS: 'IN_PROGRESS',
  FINISHED: 'FINISHED',
};
interface ISPaymentPayload {
  userId: string;
  paymentId: string;
  status: string;
  amount: string;
  isPrimary: number;
  stepId: string;
}

export const handler = async (event: any) => {
  console.log('Processing new event..', event);
  for (const record of event.Records) {
    try {
      const messageBody = record.body;
      const { userId, amount, isPrimary } = JSON.parse(messageBody).detail;
      const paymentId = randomUUID();
      const payload: ICreateUserPayment = {
        userId,
        paymentId,
        status: PaymentStatus.FINISHED,
        amount,
        isPrimary,
        createAt: new Date().toISOString(),
        lastUpdateAt: new Date().toISOString(),
      };
      createNewUserPaymentData(payload);
      console.log('Store data completed');
      const requestPayload: ISPaymentPayload = {
        userId,
        paymentId,
        stepId: '1',
        isPrimary,
        status: PaymentStatus.FINISHED,
        amount,
      };
      const stepFunctionParams = {
        stateMachineArn: state_payment_arn,
        input: JSON.stringify(requestPayload),
      };
      const startExecutionCommand = new StartExecutionCommand(stepFunctionParams);
      await sfnClient.send(startExecutionCommand);
      console.log('Sent to Payment Step Function');
    } catch (error) {
      console.error('Error processing message:', error);
    }
  }
};

const event = {
  Records: [
    {
      body: {
        version: '0',
        id: '70c7c57b-c474-a536-5a3a-00ef88d7466b',
        'detail-type': 'create_payment_event',
        source: 'my-event-bus',
        account: '331653881288',
        time: '2024-05-29T11:47:24Z',
        region: 'ap-southeast-1',
        resources: [],
        detail: { userId: '1', amount: 1 },
      },
    },
  ],
};

handler(event);
