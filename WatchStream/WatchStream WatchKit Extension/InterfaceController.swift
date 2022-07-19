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
    
    
    override func awake(withContext context: Any?) {
        // Configure interface objects here.
        
        startButton.setHidden(false)
        startButton.setEnabled(true)

        stopButton.setHidden(true)
        stopButton.setEnabled(false)
                
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
    }
    
    @IBAction func actionStop() {
        startButton.setHidden(false)
        startButton.setEnabled(true)
        
        stopButton.setHidden(true)
        stopButton.setEnabled(false)
        
        MotionDatafetcher.shared.stopFetch()
    }
    
    
    @IBAction func actionStart() {
        startButton.setHidden(true)
        startButton.setEnabled(false)
        
        stopButton.setHidden(false)
        stopButton.setEnabled(true)
        
        //MotionDatafetcher.shared.startFetch()
        
        MotionDatafetcher.shared.startDeviceMotionFetch()
    }
    
}
