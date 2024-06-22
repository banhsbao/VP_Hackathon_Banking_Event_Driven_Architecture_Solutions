export interface IEventBridgeParams {
  Source: string;
  DetailType?: string;
  Detail: string;
}

export interface IParams {
  TableName: string;
  Key?: { [key: string]: any };
  Item?: { [key: string]: any };
}

export interface IUserData {
  status: string;
}

export interface IUserPayment {
  user_id: string;
  status: string;
}
