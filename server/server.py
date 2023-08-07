import json
import threading
import redis
from flask_socketio import SocketIO, emit
from flask_cors import CORS
from flask import Flask, request, jsonify
import re
import pandas as pd
import pyttsx3
from sklearn import preprocessing
from sklearn.tree import DecisionTreeClassifier,_tree
import numpy as np
from sklearn.model_selection import train_test_split
from sklearn.model_selection import cross_val_score
from sklearn.svm import SVC
import csv
import warnings
warnings.filterwarnings("ignore", category=DeprecationWarning)
app = Flask(__name__)
CORS(app) 
app.config['SECRET_KEY'] = 'secret'
socketio = SocketIO(app)
socketio.init_app(app, cors_allowed_origins="*")
redis_client = redis.StrictRedis(host='localhost', port=6379, db=0)
message_queue_key = 'message_queue'

# global variables 
symptoms_exp=[]
status=0
count=0
days=0
users=dict()

training = pd.read_csv('Data/Training.csv')
testing= pd.read_csv('Data/Testing.csv')
cols= training.columns
cols= cols[:-1]
x = training[cols]
y = training['prognosis']
y1= y


reduced_data = training.groupby(training['prognosis']).max()

#mapping strings to numbers
le = preprocessing.LabelEncoder()
le.fit(y)
y = le.transform(y)


x_train, x_test, y_train, y_test = train_test_split(x, y, test_size=0.33, random_state=42)
testx    = testing[cols]
testy    = testing['prognosis']  
testy    = le.transform(testy)


clf1  = DecisionTreeClassifier()
clf = clf1.fit(x_train,y_train)
# print(clf.score(x_train,y_train))
# print ("cross result========")
scores = cross_val_score(clf, x_test, y_test, cv=3)
# print (scores)
print (scores.mean())


model=SVC()
model.fit(x_train,y_train)
print("for svm: ")
print(model.score(x_test,y_test))

importances = clf.feature_importances_
indices = np.argsort(importances)[::-1]
features = cols



severityDictionary=dict()
description_list = dict()
image_list = dict()
precautionDictionary=dict()

symptoms_dict = {}

for index, symptom in enumerate(x):
       symptoms_dict[symptom] = index
def calc_condition(exp,days):
    sum=0
    for item in exp:
         sum=sum+severityDictionary[item]
    if((sum*days)/(len(exp)+1)>13):
        return "You should take the consultation from doctor. "
    else:
        return "It might not be that bad but you should take precautions."


def getImage():
    global image_list
    with open('MasterData/symptom_image.csv') as csv_file:
        csv_reader = csv.reader(csv_file, delimiter=',')
        line_count = 0
        for row in csv_reader:
            _description={row[0]:row[1]}
            image_list.update(_description)

def getDescription():
    global description_list
    with open('MasterData/symptom_Description.csv') as csv_file:
        csv_reader = csv.reader(csv_file, delimiter=',')
        line_count = 0
        for row in csv_reader:
            _description={row[0]:row[1]}
            description_list.update(_description)

def getSeverityDict():
    global severityDictionary
    with open('MasterData/symptom_severity.csv') as csv_file:

        csv_reader = csv.reader(csv_file, delimiter=',')
        line_count = 0
        try:
            for row in csv_reader:
                _diction={row[0]:int(row[1])}
                severityDictionary.update(_diction)
        except:
            pass


def getprecautionDict():
    global precautionDictionary
    with open('MasterData/symptom_precaution.csv') as csv_file:

        csv_reader = csv.reader(csv_file, delimiter=',')
        line_count = 0
        for row in csv_reader:
            _prec={row[0]:[row[1],row[2],row[3],row[4]]}
            precautionDictionary.update(_prec)


def check_pattern(dis_list,inp):
    pred_list=[]
    inp=inp.replace(' ','_')
    patt = f"{inp}"
    regexp = re.compile(patt)
    pred_list=[item for item in dis_list if regexp.search(item)]
    if(len(pred_list)>0):
        return 1,pred_list
    else:
        return 0,[]
def sec_predict(symptoms_exp):
    df = pd.read_csv('Data/Training.csv')
    X = df.iloc[:, :-1]
    y = df['prognosis']
    X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.3, random_state=20)
    rf_clf = DecisionTreeClassifier()
    rf_clf.fit(X_train, y_train)

    symptoms_dict = {symptom: index for index, symptom in enumerate(X)}
    input_vector = np.zeros(len(symptoms_dict))
    for item in symptoms_exp:
      input_vector[[symptoms_dict[item]]] = 1

    return rf_clf.predict([input_vector])


def print_disease(node):
    node = node[0]
    val  = node.nonzero() 
    disease = le.inverse_transform(val[0])
    return list(map(lambda x:x.strip(),list(disease)))
 
def recurse(node, depth):
        indent = "  " * depth
        if tree_.feature[node] != _tree.TREE_UNDEFINED:
            name = feature_name[node]
            threshold = tree_.threshold[node]

            if name == disease_input:
                val = 1
            else:
                val = 0
            if  val <= threshold:
                recurse(tree_.children_left[node], depth + 1)
            else:
                symptoms_present.append(name)
                recurse(tree_.children_right[node], depth + 1)
        else:
            global symptoms_given
            global present_disease
            present_disease = print_disease(tree_.value[node])
            
            red_cols = reduced_data.columns 
            symptoms_given = red_cols[reduced_data.loc[present_disease].values[0].nonzero()]
            
        


tree_ = clf.tree_
global feature_name
feature_name = [cols[i] if i != _tree.TREE_UNDEFINED else "undefined!" for i in tree_.feature]

chk_dis=",".join(cols).split(",")
symptoms_present = []

getSeverityDict()
getDescription()
getprecautionDict()
getImage()


@app.route('/')
def index():
    return "hellow "
# socket io implementation 
@socketio.on("connect")
def handle_connect():
    print("A user connected")
    print(users)
    # Get the user ID for the connected socket
    



@socketio.on("disconnect")
def handle_disconnect():
    global users
    disconnected_user_id = None
    for user_id, socket_id in users.items():
        if socket_id == request.sid:
            disconnected_user_id = user_id
            break

    if disconnected_user_id:
        del users[disconnected_user_id]
        print(f"User with ID {disconnected_user_id} has disconnected.")
        # Perform any additional cleanup or notification tasks here


@socketio.on("join")
def handle_join(userId):
    socket_id = request.sid
    if userId not in users:
        # Add the user to the users dictionary if it's the first connection
        users[userId] = socket_id
        print(users)

    if users[userId]:
        # Retrieve and process pending messages for the connected user
        user_message_queue_key = f'message_queue_{userId}'
        message_queue = redis_client.lrange(user_message_queue_key, 0, -1)

        if message_queue:
            for message_json in message_queue:
                try:
                    message_data = json.loads(message_json)  # Parse the JSON string to a Python dictionary
                    senderId = message_data.get("senderId")
                    receiverId = message_data.get("receiverId")
                    message = message_data.get("message")
                    print(message_data)

                    if receiverId == userId:
                        emit("message", {"senderId": senderId, "receiverId": receiverId, "message": message},
                             room=socket_id)
                        # Remove processed message from the user's Redis queue
                        redis_client.lrem(user_message_queue_key, 0, message_json)

                except json.decoder.JSONDecodeError:
                    print("Failed to decode JSON data:", message_json)

@socketio.on("message")
def handle_message(data):
    senderId = data.get("senderId")
    receiverId = data.get("receiverId")
    message = data.get("message")

    receiverSocketId = users.get(receiverId)

    if receiverSocketId:
        # If the receiver is online, send the message directly
        emit("message", {"senderId": senderId, "receiverId": receiverId, "message": message}, room=receiverSocketId)
    else:
        print(f"Receiver {receiverId} is offline. Adding message to Redis queue.")
        # If the receiver is offline, add the message to the Redis message queue
        message_json = json.dumps(data)  # Convert the message to JSON string
        user_message_queue_key = f'message_queue_{receiverId}'
        redis_client.rpush(user_message_queue_key, message_json)


@app.route('/bot_response', methods=['POST'])
def bot_response():
    global status
    global symptoms_exp
    data = request.json
    message = data['message']
    
    if status==0:
        response=""
        status=1
        for index, disease in enumerate(chk_dis):
            response+=f"Select Disease: {' '.join(disease.split('_'))},  "
            if index > 10:
                break
        return jsonify({"response":{'content': f"{response}\nWrite Symptoms You Are Experiencing : ",'image':''}})
    if status==1:
        global cnf_dis # take int
        conf,cnf_dis=check_pattern(chk_dis,message)
        if conf ==1:
            response=""
            for index, x in enumerate(cnf_dis):
                response += f"{index}) for {x}.\n"
            response+="Please send option number indicate next to option"
            status=2
            return jsonify({'response': {'content':response,'image':''}})
        else:
            return jsonify({"response":{'content':"Enter valid option.",'image':''}})
            
    elif status==2:
        global disease_input
        try:

            disease_input=cnf_dis[int(message)]
            recurse(0, 1)
            status=3
            return jsonify({"response":{'content':f"Are you experiencing : {' '.join(symptoms_given[0].split('_'))}",'image':''}})
        except:
            return jsonify({"response":{'content':"Invalid Input",'image':''}})
        
    elif status==3:
        global count
        if message.lower() == 'yes':
            symptoms_exp.append(symptoms_given[count])  # Add the current symptom to symptoms_exp

        count += 1  # Move to the next symptom

        if count >= len(symptoms_given):
            status=4
            return jsonify({"response": {'content':"From How Many days you are suffering..",'image':''}})
        else:
            return jsonify({"response": {'content':" ".join(symptoms_given[count].split("_")),'image':''}})

    elif status==4:
        global days
        response=""
        try:
            days=int(message)
            
        except:
            return jsonify({"response":{'content':"Please Write Appropiate day in number",'image':''}}) 
        response +="Warning :  "+calc_condition(symptoms_exp,days)+"\n"
        second_prediction =sec_predict(symptoms_exp)
        if(present_disease[0]==second_prediction[0]):
            response+="You may have "+ present_disease[0]+"\n\n"
            response+=description_list[present_disease[0]]
        else:
            response+="You may have "+ present_disease[0]+ "or "+ second_prediction[0] +"\n"
            response+=description_list[present_disease[0]]+"\n\n"
            response+=description_list[second_prediction[0]]+"\n"
        precution_list=precautionDictionary[present_disease[0]]
        response+="\nTake following measures : \n"
        for  i,j in enumerate(precution_list):
            response+=str(i+1)+") "+j+"\n"
            # print(i+1,")",j)
        
        return jsonify({"response":{'content':response,'image':image_list[present_disease[0]]}})
    
def save_redis_snapshot():
    # Save the snapshot every 60 seconds (you can adjust this interval based on your needs)
    redis_client.save()
    # Schedule the next snapshot
    threading.Timer(60, save_redis_snapshot).start()
if __name__ == '__main__':
    try:
        redis_client = redis.StrictRedis(host='localhost', port=6379, db=0)
        response = redis_client.ping()
        print("Redis is running on port 6379:", response)
        # Start the timer for snapshotting
        # save_redis_snapshot()
    except redis.exceptions.ConnectionError:
        print("Redis is not running on port 6379")
    # socketio.run(app, debug=True)
    socketio.run(app, host="0.0.0.0",port=5000,debug=True)