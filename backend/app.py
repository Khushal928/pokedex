from flask_mysqldb import MySQL
import config
import json

def convertint(a):
    lis = []
    for i in a:
        lis.append(int(i))
    return lis

def convertstr(a):
    lis = []
    for i in a:
        lis.append(str(i))
    return lis



mysql = MySQL()

def init_mysql(app):
    app.config['MYSQL_HOST'] = config.MYSQL_HOST
    app.config['MYSQL_USER'] = config.MYSQL_USER
    app.config['MYSQL_PASSWORD'] = config.MYSQL_PASSWORD
    app.config['MYSQL_DB'] = config.MYSQL_DB
    mysql.init_app(app)
    
from flask import Flask, request, jsonify
from flask_cors import CORS
from db_config import mysql, init_mysql

app = Flask(__name__)
CORS(app)

init_mysql(app)

@app.route("/register", methods=["POST"])
def register():
    data = request.get_json()
    username = data.get("username")
    gmail = data.get("gmail")
    password = data.get("password")
    confirmpassword = data.get("confirmpassword")

    if(password!=confirmpassword):
        return jsonify({"error":"password doesnot match"}), 410

    cur = mysql.connection.cursor()
    cur.execute("SELECT * FROM users WHERE gmail = %s", (gmail,))
    existing_user = cur.fetchone()

    if existing_user:
        return jsonify({"error": "User already exists"}), 409

    cur.execute(
        "INSERT INTO users (username, gmail, password) VALUES (%s, %s, %s)",
        (username, gmail, password)
    )
    
    mysql.connection.commit()
    cur.close()

    return jsonify({"message": "User registered successfully"}), 201


@app.route("/login", methods=["POST"])
def login():
    data = request.get_json()
    username = data.get("username")
    password = data.get("password")

    cur = mysql.connection.cursor()
    cur.execute("SELECT * FROM users WHERE username = %s", (username,))
    user = cur.fetchone()
    cur.close()

    if not user:
        return jsonify({"error": "User not found"}), 404

    stored_password = user[3]  
    if password != stored_password:
        return jsonify({"error": "Incorrect password"}), 401

    return jsonify({"message": "Login successful","userid":user[0]}), 200

@app.route("/capture", methods=["POST"])
def capture():
    data = request.get_json()
    username = data.get("username")
    pokeid = data.get("pokeid")


    cur = mysql.connection.cursor()
    cur.execute("SELECT * FROM users WHERE username = %s",(username,))

    user = cur.fetchone()

    capturedpokeids = json.loads(user[4]) 
    capturedpokeids = convertint(capturedpokeids)

    capturedpokeids.append(pokeid)
    capturedpokeids = convertstr(capturedpokeids)

    capturedpokeids = json.dumps(capturedpokeids)
    cur.execute("UPDATE users SET capturedpokeids = %s WHERE username = %s", (capturedpokeids, username))
    mysql.connection.commit()
    cur.close()


    return jsonify({"message": "perfect"}), 200

@app.route("/trade", methods=["POST"])
def trade():
    data = request.get_json()
    traderusername = data.get("traderusername")
    tradeeusername = data.get("tradeeusername")

    pokeid = data.get("pokeid")

    cur = mysql.connection.cursor()
    cur.execute("SELECT * FROM users WHERE username = %s",(tradeeusername,))

    tradee = cur.fetchone()
    if not tradee:
        return jsonify({"error": "user not found"}), 404

    capturedpokeidstradee = json.loads(tradee[4])
    capturedpokeidstradee = convertint(capturedpokeidstradee)

    if(pokeid in capturedpokeidstradee):
        return jsonify({"error": "pokeid already captured by tradee"}), 409

    capturedpokeidstradee.append(pokeid)
    capturedpokeidstradee = convertstr(capturedpokeidstradee)

    capturedpokeidstradee = json.dumps(capturedpokeidstradee)
    cur.execute("UPDATE users SET capturedpokeids = %s WHERE username = %s", (capturedpokeidstradee, tradeeusername))
    mysql.connection.commit()



    cur.execute("SELECT * FROM users WHERE username = %s",(traderusername,))
    trader = cur.fetchone()


    capturedpokeids = json.loads(trader[4]) 
    capturedpokeids = convertint(capturedpokeids)


    capturedpokeids.remove(int(pokeid))
    capturedpokeids = convertstr(capturedpokeids)
    capturedpokeids = json.dumps(capturedpokeids)
    cur.execute("UPDATE users SET capturedpokeids = %s WHERE username = %s", (capturedpokeids, traderusername))
    mysql.connection.commit()


    cur.close()

    return jsonify({"traded": True}), 200


@app.route("/dashboard", methods=["POST"])
def dashboard():
    data = request.get_json()
    username = data.get("username")

    cur = mysql.connection.cursor()
    cur.execute("SELECT * FROM users WHERE username = %s",(username,))

    user = cur.fetchone()
    pokeids = user[4]

    pokeids = json.loads(pokeids)
    pokeids = convertint(pokeids)

    cur.close()

    return jsonify({"pokemon ids": pokeids}),200

@app.route("/check", methods=["POST"])
def check():
    data = request.get_json()
    username = data.get("username")
    pokeid = data.get("pokeid")

    cur = mysql.connection.cursor()
    cur.execute("SELECT * FROM users WHERE username = %s",(username,))

    user = cur.fetchone()
    pokeids = user[4]

    pokeids = json.loads(pokeids)
    pokeids = convertint(pokeids)

    if (pokeid in pokeids):
        return jsonify({"captured": True}),200
    else:
        return jsonify({"captured": False})



