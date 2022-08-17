//
//  MySocketManager.swift
//  WatchStream
//
//  Created by Ruttab Haroon on 17/08/2022.
//

import CoreMotion
import Network

class MySocketManager {
    
    private var connection: NWConnection?
    private var hostUDP: NWEndpoint.Host = "172.20.10.2"
    private var portUDP: NWEndpoint.Port = 20001
    private var updateInterval : Double = 10
    
    
    static let shared = MySocketManager()
    private init() {}
    
   func setUpConn() {
        // Hack to wait until everything is set up
       var x = 0
       while(x<1000000000) {
           x+=1
       }
       //connectToUDP(hostUDP,portUDP)
    }
    
    func connectToUDP(_ hostUDP: NWEndpoint.Host, _ portUDP: NWEndpoint.Port) {
        
        self.hostUDP = hostUDP
        self.portUDP = portUDP
    
        // Transmited message:
        let messageToUDP = "Test message"

        self.connection = NWConnection(host: hostUDP, port: portUDP, using: .udp)

        self.connection?.stateUpdateHandler = { (newState) in
            print("This is stateUpdateHandler:")
            switch (newState) {
                case .ready:
                    print("State: Ready\n")
                    self.sendUDP(messageToUDP)
                    self.receiveUDP()
                case .setup:
                    print("State: Setup\n")
                case .cancelled:
                    print("State: Cancelled\n")
                case .preparing:
                    print("State: Preparing\n")
                default:
                    print("ERROR! State not defined!\n")
            }
        }

        self.connection?.start(queue: .global())
    }

    func sendUDP(_ content: Data) {
        self.connection?.send(content: content, completion: NWConnection.SendCompletion.contentProcessed(({ (NWError) in
            if (NWError == nil) {
                print("Data was sent to UDP")
            } else {
                print("ERROR! Error when data (Type: Data) sending. NWError: \n \(NWError!)")
            }
        })))
    }

    func sendUDP(_ content: String) {
        let contentToSendUDP = content.data(using: String.Encoding.utf8)
        self.connection?.send(content: contentToSendUDP, completion: NWConnection.SendCompletion.contentProcessed(({ (NWError) in
            if (NWError == nil) {
                print("Data was sent to UDP")
            } else {
                print("ERROR! Error when data (Type: Data) sending. NWError: \n \(NWError!)")
            }
        })))
    }

    func receiveUDP() {
        self.connection?.receiveMessage { (data, context, isComplete, error) in
            if (isComplete) {
                print("Receive is complete")
                if (data != nil) {
                    let backToString = String(decoding: data!, as: UTF8.self)
                    print("Received message: \(backToString)")
                } else {
                    print("Data == nil")
                }
            }
        }
    }
    
    func cancelConnToUDP() {
        self.sendUDP("Connection closed")
        self.connection?.cancel()
    }
    
}

