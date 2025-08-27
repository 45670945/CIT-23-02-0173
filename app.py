from flask import Flask, render_template, request, redirect, url_for, jsonify
import psycopg2
import os
import time

app = Flask(__name__)

# Database configuration
DB_CONFIG = {
    'host': os.getenv('DB_HOST', 'postgres'),
    'port': os.getenv('DB_PORT', '5432'),
    'database': os.getenv('DB_NAME', 'taskdb'),
    'user': os.getenv('DB_USER', 'postgres'),
    'password': os.getenv('DB_PASSWORD', 'password123')
}

def get_db_connection():
    """Get database connection with retry logic"""
    max_retries = 10
    for i in range(max_retries):
        try:
            conn = psycopg2.connect(**DB_CONFIG)
            return conn
        except psycopg2.OperationalError as e:
            if i == max_retries - 1:
                raise e
            print(f"Database connection failed, retrying in 2 seconds... ({i+1}/{max_retries})")
            time.sleep(2)

def init_db():
    """Initialize database tables"""
    conn = get_db_connection()
    cur = conn.cursor()
    
    cur.execute('''
        CREATE TABLE IF NOT EXISTS tasks (
            id SERIAL PRIMARY KEY,
            title VARCHAR(255) NOT NULL,
            description TEXT,
            status VARCHAR(50) DEFAULT 'pending',
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        )
    ''')
    
    conn.commit()
    cur.close()
    conn.close()

@app.route('/')
def index():
    """Display all tasks"""
    conn = get_db_connection()
    cur = conn.cursor()
    
    cur.execute('SELECT id, title, description, status, created_at FROM tasks ORDER BY created_at DESC')
    tasks = cur.fetchall()
    
    cur.close()
    conn.close()
    
    return render_template('index.html', tasks=tasks)

@app.route('/add_task', methods=['POST'])
def add_task():
    """Add a new task"""
    title = request.form['title']
    description = request.form['description']
    
    conn = get_db_connection()
    cur = conn.cursor()
    
    cur.execute(
        'INSERT INTO tasks (title, description) VALUES (%s, %s)',
        (title, description)
    )
    
    conn.commit()
    cur.close()
    conn.close()
    
    return redirect(url_for('index'))

@app.route('/update_status/<int:task_id>/<status>')
def update_status(task_id, status):
    """Update task status"""
    conn = get_db_connection()
    cur = conn.cursor()
    
    cur.execute(
        'UPDATE tasks SET status = %s WHERE id = %s',
        (status, task_id)
    )
    
    conn.commit()
    cur.close()
    conn.close()
    
    return redirect(url_for('index'))

@app.route('/delete_task/<int:task_id>')
def delete_task(task_id):
    """Delete a task"""
    conn = get_db_connection()
    cur = conn.cursor()
    
    cur.execute('DELETE FROM tasks WHERE id = %s', (task_id,))
    
    conn.commit()
    cur.close()
    conn.close()
    
    return redirect(url_for('index'))

@app.route('/health')
def health():
    """Health check endpoint"""
    return jsonify({"status": "healthy", "service": "task-manager"})

if __name__ == '__main__':
    # Initialize database on startup
    init_db()
    app.run(host='0.0.0.0', port=5000, debug=True)
