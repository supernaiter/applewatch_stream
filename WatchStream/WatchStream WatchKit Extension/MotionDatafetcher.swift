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
    private var updateTimeInterval: Double = 0.01
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
    
    func startDeviceMotionFetch() {
        var values: [String:String] = [:]
        if manager.isDeviceMotionAvailable {
            self.manager.deviceMotionUpdateInterval = 1.0 / 60.0
            self.manager.showsDeviceMovementDisplay = true
            self.manager.startDeviceMotionUpdates(using: .xMagneticNorthZVertical, to: .main, withHandler: { [weak self] (data, error) in
                guard let weakSelf = self else {return}
              // Make sure the data is valid befrore accessing it.
                  if let validData = data {
                     // Get the attitude relative to the magnetic north reference frame.
                     let roll = validData.attitude.roll
                     let pitch = validData.attitude.pitch
                     let yaw = validData.attitude.yaw

 
                      print("Gyroscope Roll \(validData.attitude.roll)")
                      print("Gyroscope Pitch \(validData.attitude.pitch)")
                      print("Gyroscope Yaw  \(validData.attitude.yaw)")
                      print("Gyroscope Rotation X \(validData.rotationRate.x)")
                      print("Gyroscope Rotation Y \(validData.rotationRate.y)")
                      print("Gyroscope Rotation Z \(validData.rotationRate.z)")
                      
                      values["Gyroscope Roll"] = String(validData.attitude.roll)
                      values["Gyroscope Pitch"] = String(validData.attitude.pitch)
                      values["Gyroscope Yaw"] = String(validData.attitude.yaw)
                      values["Gyroscope Rotation X"] = String(validData.rotationRate.x)
                      values["Gyroscope Rotation Y"] = String(validData.rotationRate.y)
                      values["Gyroscope Rotation Z"] = String(validData.rotationRate.z)
                      
                     
                      if weakSelf.manager.isAccelerometerAvailable {
                          weakSelf.manager.accelerometerUpdateInterval = 1.0/60
                          self?.manager.startAccelerometerUpdates(to: .main, withHandler: { data, error in
                              if let e = error {
                                  print(e.localizedDescription)
                              }
                              else {
                                  print("Accelerometer X \(data!.acceleration.x)")
                                  print("AccelerometerY \(data!.acceleration.y)")
                                  print("Accelerometer Z \(data!.acceleration.z)")
                                  
                                  values["Accelerometer X"] = String(data!.acceleration.x)
                                  values["Accelerometer Y"] = String(data!.acceleration.y)
                                  values["Accelerometer Z"] = String(data!.acceleration.z)
                              }
                          })
                      }
                      else {
                          print("Accelerometer is not available")
                      }
                      
                      RealtimeDBHelper.shared.update(values: values)
                }
           })
        }
        else {
            print("Device Motion is not available")
        }
    }
    
    func stopFetch() {
        timer?.invalidate()
        manager.stopGyroUpdates()
        manager.stopAccelerometerUpdates()
        manager.stopDeviceMotionUpdates()
    }
    
}


