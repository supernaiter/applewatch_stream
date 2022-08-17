# AppleWatchStreamCoreMotionData

This project allows users to stream motion(Accelerometer & Gyroscope) data from the apple watch at 100Hz and print in real-time on to the python console.

## How it works

A UDP server written in python listens for updates from the clients. The UDP client is a Apple Watch that reads device motion data and emits the data to the UDP server.

## Prerequisite

1. You need to install Xcode (version 13.1) on your macbook. Downloaad from here "https://xcodereleases.com/"

## From python side

Run server.py file (applewatch_stream/motiondatafetch/server.py) in the terminal using the command below

```bash
python server.py
```

## From Apple Watch side

1. Pair your iPhone with your apple watch then connect your iphone to your macbook via cable
2. Follow the steps in the video titled "change_host_ios.mp4" to update the value of the "host" variable in 'InterfaceController.swift' file
3. Follow the steps in the video titled "ios_app.mp4" to see how to run the app. You will only need to do this once to install the app on your apple watch. After it is successfully installed just tap on the app to run it.
4. Everytime you connect to a different WIFI/Data network, you need to repeat step 2.

## Updating motion data capture frequency

To update the frequency in which gyroscope or accelerometer data is captured follow the steps below:

1. Open 'WatchStream.xcworkspace' (applewatchstream/WatchStream/WatchStream.xcworkspace)
2. Go into file 'InterfaceController.swift'
3. Change the value of the variable 'updateTimeInterval'

## License

[MIT](https://choosealicense.com/licenses/mit/)
