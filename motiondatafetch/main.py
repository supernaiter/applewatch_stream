import pyrebase

firebaseConfig = {
    "apiKey": "AIzaSyD0UKdG2VQ3u7zQksxB3KpmcPiv1xle7Dw",
    "authDomain": "watchstream-cc32c.firebaseapp.com",
    "databaseURL": "https://watchstream-cc32c-default-rtdb.firebaseio.com",
    "projectId": "watchstream-cc32c",
    "storageBucket": "watchstream-cc32c.appspot.com",
    "messagingSenderId": "638113024234",
    "appId": "1:638113024234:web:35db1f6a8688898b8cef93"
}

firebase = pyrebase.initialize_app(firebaseConfig)


def stream_handler(message):
    print(message["event"])  # put
    print(message["path"])  # /-K7yGTTEp7O549EzTYtI
    print(message["data"])  # {'title': 'Pyrebase', "body": "etc..."}


db = firebase.database()


my_stream = db.child("data").stream(stream_handler)
print(my_stream)


#my_stream1 = db.child("data").child("Accelerometer").stream(stream_handler)
#my_stream2 = db.child("data").child("Gyroscope").stream(stream_handler)
#print(my_stream1)
#print(my_stream2)
