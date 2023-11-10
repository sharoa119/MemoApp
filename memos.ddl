CREATE TABLE memos (
  id serial PRIMARY KEY,
  title character varying NOT NULL,
  content character varying NOT NULL,
  created_at timestamp DEFAULT current_timestamp NOT NULL
);
