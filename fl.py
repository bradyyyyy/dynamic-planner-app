from flask import Flask
import sqlite3

DATABASE = 'database/planner.db'

app = Flask(__name__)

def init_db():
    # Connect to the SQLite database
    conn = sqlite3.connect(DATABASE)
    cursor = conn.cursor()

    # Read SQL commands from schema.sql file
    with open('database/schema.sql', 'r') as f:
        sql_commands = f.read()

    # Execute SQL commands
    cursor.executescript(sql_commands)

    # Commit changes and close connection
    conn.commit()
    conn.close()

    print("Database initialized successfully.")

@app.route('/')
def index():
    return 'Hello from Flask!'

if __name__ == '__main__':
    # Initialize the database when the application starts
    init_db()
    app.run(debug=True)