import { DynamoDBDocumentClient, QueryCommand } from '@aws-sdk/lib-dynamodb';
import { DynamoDBClient, CreateTableCommand, ScanCommand } from '@aws-sdk/client-dynamodb';
import { EventBridgeClient, PutEventsCommand } from '@aws-sdk/client-eventbridge';
import { IEventBridgeParams } from './interface';
import { AppConstant } from './constant';
const { unmarshall } = require('@aws-sdk/util-dynamodb');

const client = new DynamoDBClient({});
const docClient = DynamoDBDocumentClient.from(client);

const eventBridgeClient = new EventBridgeClient();

export const getLastEventOfUserByUserId = async (userId: string) => {
  try {
    const command = new ScanCommand({
      TableName: AppConstant.DYNAMO_USER_PAYMENT_TABLE,
      FilterExpression: 'isPrimary = :isPrimary and userId = :userId',
      ExpressionAttributeValues: {
        ':userId': { S: `${userId}` },
        ':isPrimary': { N: '1' },
      },
      Limit: 1,
    });
    const data = await docClient.send(command);
    if (data.Items !== undefined) {
      const items = data.Items.map((item) => unmarshall(item));
      return items;
    }
  } catch (error) {
    console.log('Error getting item from DynamoDB', error);
    throw new Error('Error getting item from DynamoDB');
  }
};

export const getAllEvents = async () => {
  try {
    const command = new ScanCommand({
      TableName: AppConstant.DYNAMO_USER_PAYMENT_TABLE,
      ConsistentRead: true,
    });
    const data = await docClient.send(command);
    if (data.Items !== undefined) {
      const items = data.Items.map((item) => unmarshall(item));
      return items;
    }
  } catch (error) {
    console.log('Error scanning DynamoDB table', error);
    throw new Error('Error scanning DynamoDB table');
  }
};

export const createTable = async () => {
  const command = new CreateTableCommand({
    TableName: 'EspressoDrinks',
    AttributeDefinitions: [
      {
        AttributeName: 'DrinkName',
        AttributeType: 'S',
      },
    ],
    KeySchema: [
      {
        AttributeName: 'DrinkName',
        KeyType: 'HASH',
      },
    ],
    ProvisionedThroughput: {
      ReadCapacityUnits: 1,
      WriteCapacityUnits: 1,
    },
  });
  await client.send(command);
};

export const sendEvent = async (params: IEventBridgeParams) => {
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
