-- Create the database (if not already created)
-- Note: In docker-compose we already set POSTGRES_DB=tasks
-- So this part is optional if using Docker

-- Create tasks table
CREATE TABLE IF NOT EXISTS tasks (
    id SERIAL PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    done BOOLEAN DEFAULT FALSE
);

-- Optional: Insert some sample tasks
INSERT INTO tasks (title, done) VALUES
('Learn Docker', FALSE),
('Build Task Manager App', TRUE),
('Write README.md', FALSE);

