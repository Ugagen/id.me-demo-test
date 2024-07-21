CREATE TABLE IF NOT EXISTS greetings (
  message TEXT NOT NULL
);

INSERT INTO greetings (message) 
VALUES ('Hello World') 
ON CONFLICT (message) DO NOTHING;