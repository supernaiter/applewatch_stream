//
//  MotionDatafetcher.swift
//  WatchStream
//
//  Created by Ruttab Haroon on 12/07/2022.
//


import UIKit
import CoreMotion


class MotionDatafetcher {
    
    private init () {}
    static let shared = MotionDatafetcher()
    
    
    private var timer: Timer?
    private var updateTimeInterval: Double = 0.1
    private let manager = CMMotionManager()
    
    func startFetch() {
        manager.startAccelerometerUpdates()
        manager.accelerometerUpdateInterval = updateTimeInterval
        
        manager.startGyroUpdates()
        manager.gyroUpdateInterval = updateTimeInterval
        
        timer = Timer.scheduledTimer(withTimeInterval: updateTimeInterval, repeats: true) { [weak self] _ in
            
            var values: [String:String] = [:]
            
            if let adata = self?.manager.accelerometerData {
                print("Accelerometer X \(adata.acceleration.x)")
                print("AccelerometerY \(adata.acceleration.y)")
                print("Accelerometer Z \(adata.acceleration.z)")
                
                values["Accelerometer X"] = String(adata.acceleration.x)
                values["Accelerometer Y"] = String(adata.acceleration.y)
                values["Accelerometer Z"] = String(adata.acceleration.z)
            }
            
            if let gData = self?.manager.gyroData {
                print("Gyroscope X \(gData.rotationRate.x)")
                print("Gyroscope Y \(gData.rotationRate.y)")
                print("Gyroscope Z \(gData.rotationRate.z)")
                
                values["Gyroscope X"] = String(gData.rotationRate.x)
                values["Gyroscope Y"] = String(gData.rotationRate.y)
                values["Gyroscope Z"] = String(gData.rotationRate.z)
            }
            
            RealtimeDBHelper.shared.update(values: values)
        }
    }
    
    func stopFetch() {
        timer?.invalidate()
        manager.stopGyroUpdates()
        manager.stopAccelerometerUpdates()
    }
    
}


