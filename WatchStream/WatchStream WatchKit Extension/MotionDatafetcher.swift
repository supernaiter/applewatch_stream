//
//  MotionDatafetcher.swift
//  WatchStream
//
//  Created by Ruttab Haroon on 12/07/2022.
//


import WatchKit
import CoreMotion
import HealthKit
import UIKit

class MotionDatafetcher  {

    private init () {}
    static let shared = MotionDatafetcher()
    
    
    private var timer: Timer?
    private var updateTimeInterval: Double = 0
    private let manager = CMMotionManager()
    
    lazy var conformingVC: WKInterfaceController = WKInterfaceController()
    
    
    //healthkit
//    private let healthStore = HKHealthStore()
//    private var session : HKWorkoutSession?
//    private var builder : HKLiveWorkoutBuilder?
    
    
    private lazy var session = WKExtendedRuntimeSession()
    
    
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
    
    func startDeviceMotionFetch(_ updateTimeInterval: Double) {
        self.updateTimeInterval = updateTimeInterval
        var values: [String:String] = [:]
        if manager.isDeviceMotionAvailable {
            self.manager.deviceMotionUpdateInterval = updateTimeInterval
            self.manager.showsDeviceMovementDisplay = true
            self.manager.startDeviceMotionUpdates(using: .xMagneticNorthZVertical, to: .main, withHandler: { [weak self] (data, error) in
                guard let weakSelf = self else {return}
              // Make sure the data is valid befrore accessing it.
                  if let validData = data {
                     // Get the attitude relative to the magnetic north reference frame.
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
                          weakSelf.manager.accelerometerUpdateInterval = weakSelf.updateTimeInterval
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
                      
                      //RealtimeDBHelper.shared.update(values: values)
                      MySocketManager.shared.sendUDP(values.debugDescription)
                }
           })
        }
        else {
            print("Device Motion is not available")
        }
    }
    
    func stopFetch() {
        timer?.invalidate()
        timer = nil
        manager.stopGyroUpdates()
        manager.stopAccelerometerUpdates()
        manager.stopDeviceMotionUpdates()
    }
    
//    func startWorkoutSession() {
//        let allTypes = Set([HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!])
//
//        healthStore.requestAuthorization(toShare: allTypes, read: allTypes) { [weak self] (success, error) in
//            guard let weakSelf = self else {return}
//            if !success {
//                // Handle the error here.
//            }
//            else {
//                let configuration = HKWorkoutConfiguration()
//                configuration.activityType = .walking
//
//                do {
//                    weakSelf.session = try HKWorkoutSession(healthStore: weakSelf.healthStore, configuration: configuration)
//                    if let _ = weakSelf.session {
//                        weakSelf.builder = weakSelf.session!.associatedWorkoutBuilder()
//                        weakSelf.builder!.dataSource = HKLiveWorkoutDataSource(healthStore: weakSelf.healthStore,
//                                                                     workoutConfiguration: configuration)
////                        weakSelf.session!.delegate = self
////                        weakSelf.builder!.delegate = self
//                        weakSelf.session!.startActivity(with: Date())
//                        weakSelf.builder!.beginCollection(withStart: Date()) { (success, error) in
//
//                            guard success else {
//                                // Handle errors.
//                                print("SOMETHING WENT WRONG HERE!: \(error?.localizedDescription)")
//                                return
//                            }
//
//                            weakSelf.startDeviceMotionFetch()
//
//                            // Indicate that the session has started.
//                        }
//                    }
//                } catch let error{
//                    // Handle failure here.
//                    print("SOMETHING WENT WRONG HERE!: \(error.localizedDescription)")
//                    return
//                }
//
//            }
//        }
//    }
//
//    func stopWorkoutSEssion() {
//        if let s = self.session {
//            if let b = self.builder {
//                s.stopActivity(with: Date())
//                b.workoutSession!.stopActivity(with: Date())
//            }
//        }
//        stopFetch()
//    }
    

}

