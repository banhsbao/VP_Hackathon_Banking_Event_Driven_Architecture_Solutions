import { EventBridgeClient, PutEventsCommand } from '@aws-sdk/client-eventbridge';
import { SESClient, SendEmailCommand } from '@aws-sdk/client-ses';
import { Client } from 'pg';

const eventBridgeClient = new EventBridgeClient();
interface IEventBridgeParams {
  Source: string;
  DetailType?: string;
  Detail: string;
}

const EventBridgeType = {
  CREATE_PAYMENT_EVENT: 'create_payment_event',
  ORDER_PROCESS_EVENT: 'order_process_event',
};

const eventBridgeConfig = {
  source: process.env.EVENT_BRIDGE_CREATE_PAYMENT_EVENT!,
};

const connectToDatabase = async (): Promise<Client | null> => {
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
  try {
    await client.connect();
    console.log('Successfully connected to the database.');
    return client;
  } catch (error) {
    console.log(`Failed to connect to the database: ${error}`);
  }
  return null;
};

const fetchUserData = async (accountId: number) => {
  try {
    const client = await connectToDatabase();
    if (!client) {
      throw new Error('Error executing query');
    }
    const query = 'SELECT u.email, u.userName FROM public."user" u WHERE u.userId = $1';
    const values = [accountId];
    const res = await client.query(query, values);
    if (res.rows.length === 0) {
      console.log('Account not found');
      return null;
    } else {
      return res.rows[0];
    }
  } catch (error) {
    console.log('Error executing query:', error);
    throw new Error('Error executing query');
  }
};

const sendEmail = async (toEmail: string, subject: string, body: string) => {
  const client = new SESClient();
  const command = new SendEmailCommand({
    Destination: {
      ToAddresses: [toEmail],
    },
    Message: {
      Body: {
        Html: {
          Charset: 'UTF-8',
          Data: 'Money boiz',
        },
        Text: {
          Charset: 'UTF-8',
          Data: body,
        },
      },
      Subject: {
        Charset: 'UTF-8',
        Data: subject,
      },
    },
    Source: 'phongtran270997@gmail.com',
  });

  try {
    const response = await client.send(command);
    console.log(`Email sent to ${toEmail}`, response);
  } catch (error) {
    console.log('Error sending email:', error);
    throw new Error('Error sending email');
  }
};

export const handler = async (event: any) => {
  console.log('Processing even:', event);
  const { userId, status } = event.detail;
  try {
    const user = await fetchUserData(userId);
    if (!user) {
      return {
        statusCode: 404,
        body: JSON.stringify({
          message: 'User not found',
        }),
      };
    }

    if (event.stepId === 2 || event.stepId === 3) {
      console.log('Invoking event bridge..: ', EventBridgeType.CREATE_PAYMENT_EVENT);
      const eventParams = {
        Source: eventBridgeConfig.source,
        DetailType: EventBridgeType.CREATE_PAYMENT_EVENT,
        Detail: JSON.stringify({ user_id: userId }),
      };
      await sendEvent(eventParams);
    } else {
      const userEmail = user.email;
      const userName = user.userName;
      const emailSubject = 'Payment Status Update';
      const emailBody = `Dear ${userName},\n\nYour payment id 201718281882 status is: ${status}\n\nThank you!`;
      await sendEmail(userEmail, emailSubject, emailBody);

      return {
        statusCode: 200,
        body: JSON.stringify({
          message: 'Email sent successfully',
        }),
      };
    }
  } catch (error) {
    console.log(error);
    return {
      statusCode: 500,
      body: JSON.stringify({
        message: 'Internal Server Error',
        error: error,
      }),
    };
  }
};

const sendEvent = async (params: IEventBridgeParams) => {
  try {
    console.log(params);
    await eventBridgeClient.send(
      new PutEventsCommand({
        Entries: [
          {
            Detail: params.Detail,
            EventBusName: 'my-event-bus',
            DetailType: params.DetailType,
            Source: params.Source,
          },
        ],
      }),
    );
    console.log('Event sent successfully');
  } catch (error) {
    console.error('Error sending event to EventBridge', error);
    throw new Error('Error sending event to EventBridge');
  }
};
