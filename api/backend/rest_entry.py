from flask import Flask
from flask import make_response
from backend.db_connection import db
import os
from dotenv import load_dotenv

def create_app():
    app = Flask(__name__)

    # Load environment variables
    # This function reads all the values from inside
    # the .env file (in the parent folder) so they
    # are available in this file.  See the MySQL setup 
    # commands below to see how they're being used.
    load_dotenv()

    # secret key that will be used for securely signing the session 
    # cookie and can be used for any other security related needs by 
    # extensions or your application
    app.config['SECRET_KEY'] = os.getenv('SECRET_KEY')

    # To the 'app' object, we add some config options that will be used by the MySQL
    # connection object to establish the connection.  
    app.config['MYSQL_DATABASE_USER'] = os.getenv('DB_USER').strip()
    app.config['MYSQL_DATABASE_PASSWORD'] = os.getenv('MYSQL_ROOT_PASSWORD').strip()
    app.config['MYSQL_DATABASE_HOST'] = os.getenv('DB_HOST').strip()
    app.config['MYSQL_DATABASE_PORT'] = int(os.getenv('DB_PORT').strip())
    app.config['MYSQL_DATABASE_DB'] = os.getenv('DB_NAME').strip()  # Change this to your DB name

    # Initialize the database object with the settings above. 
    # Also notice the use of a logger command.  You can use these in place of 'print'
    # statements to help with debugging. 
    app.logger.info('current_app(): starting the database connection')
    db.init_app(app)

    # ------------------------------------------------------------------------------------
    # Home route - return simple polite message
    @app.route("/", methods=['GET'])
    def sayHello():
        response = make_response("<h1>Hello from your First Flask Api App<h1>")
        response.status_code = 200
        return response
      
    # ------------------------------------------------------------------------------------
    # This route will connect to the database, retrieve the full names
    # of all of the users and then returns them to the client.
    @app.route("/users", methods=['GET'])
    def get_users():
        # Get a cursor object from the database connection
        cursor = db.get_db().cursor()
        
        # Execute an SQL query to select the full_name column from the Users table
        cursor.execute("SELECT full_name FROM Users")
        
        # Fetch all the results from the executed query
        users = cursor.fetchall()
        
        # Create a response object with the fetched users data
        response = make_response(users)
        
        # Set the HTTP status code of the response to 200 (OK)
        response.status_code = 200
        
        # Return the response object
        return response


    # Don't forget to return the app object (back to the
    # backend_app function in this case)
    return app

