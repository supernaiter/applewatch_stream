//
//  RealtimeDBHelper.swift
//  WatchStream
//
//  Created by Ruttab Haroon on 12/07/2022.
//

import Foundation

import FirebaseCore
import FirebaseAuth
import FirebaseDatabase

class RealtimeDBHelper {
    private init () {}
    static let shared = RealtimeDBHelper()
    
    private var ref: DatabaseReference = Database.database().reference()
    
    func update(values: [String:String]) {
        self.ref.child("data").setValue(
            [
                "Accelerometer X": values["Accelerometer X"] ?? "",
                "Accelerometer Y": values["Accelerometer Y"] ?? "",
                "Accelerometer Z": values["Accelerometer Z"] ?? "",
                "Gyroscope X": values["Gyroscope X"] ?? "",
                "Gyroscope Y": values["Gyroscope Y"] ?? "",
                "Gyroscope Z": values["Gyroscope X"] ?? "",
            ]
        )
    }
    
    
}
