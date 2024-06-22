const { Client } = require("pg");
const client = new Client({
  user: process.env.RDS_USER,
  host: process.env.RDS_HOST,
  database: process.env.RDS_DB,
  password: process.env.RDS_PASSWORD,
  port: 5432,
  ssl: {
    rejectUnauthorized: false,
  },
});
client
  .connect()
  .then(() => {
    console.log("Connected to PostgreSQL");
    const createTableQuery = `
    -- Create the user table
    CREATE TABLE "user" (
        userId SERIAL PRIMARY KEY,
        cognitoId UUID NOT NULL,
        userName VARCHAR(255) NOT NULL,
        balance NUMERIC NOT NULL DEFAULT 0,
        email VARCHAR(255) NOT NULL
    );
    -- Create the transaction table
    CREATE TABLE "transaction" (
        paymentId SERIAL PRIMARY KEY,
        amount NUMERIC NOT NULL,
        createdDate TIMESTAMPTZ NOT NULL DEFAULT (CURRENT_TIMESTAMP AT TIME ZONE 'Asia/Ho_Chi_Minh'),
        userId INT NOT NULL,
        CONSTRAINT fk_user
            FOREIGN KEY(userId)
            REFERENCES "user"(userId)
    );
    -- Create the transaction_status table
    CREATE TABLE transaction_status (
        id SERIAL PRIMARY KEY,
        status VARCHAR(255) NOT NULL,
        paymentId INT NOT NULL,
        CONSTRAINT fk_transaction
            FOREIGN KEY(paymentId)
            REFERENCES "transaction"(paymentId)
    );
    INSERT INTO "user" (cognitoId, userName, balance, email) VALUES
    ('123e4567-e89b-12d3-a456-426614174000', 'Dung', 300, 'dung@example.com'),
    ('223e4567-e89b-12d3-a456-426614174001', 'Bao', 270, 'bao@example.com'),
    ('323e4567-e89b-12d3-a456-426614174002', 'Dang', 250, 'dang@example.com');
    `;
    return client.query(createTableQuery);
  })
  .then(() => {
    console.log("Table created successfully");
  })
  .catch((error) => {
    console.error("Error creating table:", error);
  })
  .finally(() => {
    client.end();
  });
