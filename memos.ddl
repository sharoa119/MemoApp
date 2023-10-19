CREATE TABLE memos (
  id serial PRIMARY KEY,
  title character varying,
  content character varying,
  created_at timestamp DEFAULT current_timestamp
);
