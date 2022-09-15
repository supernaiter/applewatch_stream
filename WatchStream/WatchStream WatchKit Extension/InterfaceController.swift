//
//  InterfaceController.swift
//  WatchStream WatchKit Extension
//
//  Created by Ruttab Haroon on 12/07/2022.
//

import WatchKit
import Foundation
import Network
import UIKit


class InterfaceController: WKInterfaceController {

    @IBOutlet weak var stopButton: WKInterfaceButton!
    @IBOutlet weak var startButton: WKInterfaceButton!
    
    
    var session = WKExtendedRuntimeSession()
    
    private var host: NWEndpoint.Host = "172.16.105.162"
    private var port: NWEndpoint.Port = 20001
    private var updateTimeInterval: Double = 1/60
    
    
    override func awake(withContext context: Any?) {
        // Configure interface objects here.
        
        
//        startButton.setHidden(false)
        startButton.setEnabled(true)
//
//        stopButton.setHidden(true)
        stopButton.setEnabled(false)
        
                
        setUPSession()
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        print("ACTIVATE")
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        print("DEACTIVATE")
    }
    
    @IBAction func actionStop() {
//        startButton.setHidden(false)
        startButton.setEnabled(true)
//
//        stopButton.setHidden(true)
        stopButton.setEnabled(false)
        
        self.stopSession()
        
       // MotionDatafetcher.shared.startSession() //stopWorkoutSEssion() //stopFetch()
    }
    
    
    @IBAction func actionStart() {
//        startButton.setHidden(true)
        startButton.setEnabled(false)
//
//        stopButton.setHidden(false)
        stopButton.setEnabled(true)
        
        self.startSession()
        
       // MotionDatafetcher.shared.startFetch()
        
        //MotionDatafetcher.shared.stopSession() //startWorkoutSession() //startDeviceMotionFetch()
    }
    
    @objc func willResignActive(_ notification: Notification) {
        // code to execute
    }

    
}


extension InterfaceController : WKExtendedRuntimeSessionDelegate{
    func setUPSession() {
        // Create the session object.
        session = WKExtendedRuntimeSession()

        // Assign the delegate.
        session.delegate = self
        
        MySocketManager.shared.setUpConn()
    }
    
    func startSession() {
        session.start()
        MySocketManager.shared.connectToUDP(host, port)
        MotionDatafetcher.shared.startDeviceMotionFetch(updateTimeInterval)
    }
    
    func stopSession() {
        session.invalidate()
        MotionDatafetcher.shared.stopFetch()
        MySocketManager.shared.cancelConnToUDP()
    }
    
    func extendedRuntimeSession(_ extendedRuntimeSession: WKExtendedRuntimeSession, didInvalidateWith reason: WKExtendedRuntimeSessionInvalidationReason, error: Error?) {
        print("SESSION HAS STOPPED because of an error \(error?.localizedDescription)")
    }
    
    func extendedRuntimeSessionDidStart(_ extendedRuntimeSession: WKExtendedRuntimeSession) {
        print("SESSION HAS STARTED")
    }
    
    func extendedRuntimeSessionWillExpire(_ extendedRuntimeSession: WKExtendedRuntimeSession) {
        print("SESSION HAS STOPPED")
        self.stopSession()
    }
    
}
