//
//  InterfaceController.swift
//  WatchStream WatchKit Extension
//
//  Created by Ruttab Haroon on 12/07/2022.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {

    @IBOutlet weak var stopButton: WKInterfaceButton!
    @IBOutlet weak var startButton: WKInterfaceButton!
    
    
    var session = WKExtendedRuntimeSession()
    
    
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
    
}


extension InterfaceController : WKExtendedRuntimeSessionDelegate{
    func setUPSession() {
        // Create the session object.
        session = WKExtendedRuntimeSession()

        // Assign the delegate.
        session.delegate = self

    }
    
    func startSession() {
        session.start()
        MotionDatafetcher.shared.startDeviceMotionFetch()
    }
    
    func stopSession() {
        session.invalidate()
        MotionDatafetcher.shared.stopFetch()
    }
    
    func extendedRuntimeSession(_ extendedRuntimeSession: WKExtendedRuntimeSession, didInvalidateWith reason: WKExtendedRuntimeSessionInvalidationReason, error: Error?) {
        
    }
    
    func extendedRuntimeSessionDidStart(_ extendedRuntimeSession: WKExtendedRuntimeSession) {
        
    }
    
    func extendedRuntimeSessionWillExpire(_ extendedRuntimeSession: WKExtendedRuntimeSession) {
        self.stopSession()
    }
    
}
