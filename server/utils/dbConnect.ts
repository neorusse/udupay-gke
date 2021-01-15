import connect from "@databases/pg";

const {
  POSTGRES_USERNAME,
  POSTGRES_PASSWORD,
  POSTGRES_HOSTNAME,
  POSTGRES_PORT,
  POSTGRES_DB
} = process.env;

const url = `postgres://${POSTGRES_USERNAME}:${POSTGRES_PASSWORD}@${POSTGRES_HOSTNAME}:${POSTGRES_PORT}/${POSTGRES_DB}`;


const db = connect(url);

export default db;
