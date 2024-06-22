export const AppConstant = {
  DYNAMO_USER_PAYMENT_TABLE: 'vp_payment',
};

export const PaymentStatus = {
  STARTED: 'STARTED',
  IN_PROGRESS: 'IN_PROGRESS',
  FINISHED: 'FINISHED',
};

export const EventBridgeType = {
  CREATE_PAYMENT_EVENT: 'create_payment_event',
  ORDER_PROCESS_EVENT: 'order_process_event',
};

export const eventBridgeConfig = {
  source: process.env.EVENT_BRIDGE_CREATE_PAYMENT_EVENT!,
};
