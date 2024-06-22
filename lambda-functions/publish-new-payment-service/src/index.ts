import { APIGatewayProxyEvent, APIGatewayProxyResult } from 'aws-lambda';
import { eventBridgeConfig, EventBridgeType, PaymentStatus } from './constant';
import { getAllEvents, getLastEventOfUserByUserId, sendEvent } from './service';

const handleProcessPayment = async (event: any, context: any): Promise<APIGatewayProxyResult> => {
  console.log('Processing new payment process event..', event);
  const userId = event?.queryStringParameters?.userId;
  const amount = JSON.parse(event?.body)?.amount;
  if (!userId) {
    return {
      statusCode: 400,
      body: JSON.stringify({
        message: 'Invalid Payment',
        input: event,
      }),
    };
  }

  const userPaymentData = await getLastEventOfUserByUserId(userId);
  console.log('User found:', userPaymentData);
  const status = userPaymentData?.[0]?.status;
  if (status != PaymentStatus.FINISHED && status != null) {
    return {
      statusCode: 400,
      body: JSON.stringify({
        message: 'An old payment is being processed, please wait..',
        input: event,
      }),
    };
  } else {
    console.log('Invoking event bridge..: ', EventBridgeType.CREATE_PAYMENT_EVENT);
    const eventParams = {
      Source: eventBridgeConfig.source,
      DetailType: EventBridgeType.CREATE_PAYMENT_EVENT,
      Detail: JSON.stringify({ userId: userId, amount: amount }),
    };
    await sendEvent(eventParams);
  }
  return {
    statusCode: 200,
    body: JSON.stringify({
      message: 'Event processing..',
      input: event,
    }),
  };
};

const handleAllPayments = async (event: APIGatewayProxyEvent, context: any): Promise<any> => {
  console.log('Processing fetch all payment event..', event);
  try {
    const data = await getAllEvents();
    console.log('Receive data', data);
    return {
      statusCode: 200,
      body: JSON.stringify(data),
    };
  } catch (error) {
    console.error('Error fetching all payments:', error);
    return {
      statusCode: 500,
      body: JSON.stringify({ error: 'Failed to fetch all payments' }),
    };
  }
};

export const handler = async (event: any, context: any): Promise<APIGatewayProxyResult> => {
  const path = event.path;
  console.log('Processing event for path:', path);
  if (path == '/payment') {
    return handleProcessPayment(event, context);
  } else if (path == '/all-payment') {
    return handleAllPayments(event, context);
  } else {
    return {
      statusCode: 404,
      body: JSON.stringify({
        message: 'Not Found',
      }),
    };
  }
};
