//
//  InterfaceController.swift
//  PingPongWatch Extension
//
//  Created by Dan Leonard on 3/22/16.
//  Copyright © 2016 MacMeDan. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity


class InterfaceController: WKInterfaceController, WCSessionDelegate {

    private let session : WCSession? = WCSession.isSupported() ? WCSession.defaultSession() : nil
    
    override init() {
        super.init()
        
        session?.delegate = self
        session?.activateSession()
    }
    
    @IBAction func pluseOneForPlayerOne() {
        let applicationData = ["Player" : 1, "PosOrNeg": true]
        if let session = session where session.reachable {
            session.sendMessage(applicationData,
                                replyHandler: { replyData in
                                    // handle reply from iPhone app here
                                    print(replyData)
                }, errorHandler: { error in
                    // catch any errors here
                    print(error)
            })
        } else {
            // when the iPhone is not connected via Bluetooth
        }
    }
    
    @IBAction func pluseOneForPlayerTwo() {
        let applicationData = ["Player" : 2, "PosOrNeg": true]
        if let session = session where session.reachable {
            session.sendMessage(applicationData,
                                replyHandler: { replyData in
                                    // handle reply from iPhone app here
                                    print(replyData)
                }, errorHandler: { error in
                    // catch any errors here
                    print(error)
            })
        } else {
            // when the iPhone is not connected via Bluetooth
        }

    }
    
    @IBAction func minusOneForPlayerOne() {
        let applicationData = ["Player" : 1, "PosOrNeg": false]
        if let session = session where session.reachable {
            session.sendMessage(applicationData,
                                replyHandler: { replyData in
                                    // handle reply from iPhone app here
                                    print(replyData)
                }, errorHandler: { error in
                    // catch any errors here
                    print(error)
            })
        } else {
            // when the iPhone is not connected via Bluetooth
        }

    }
    
    @IBAction func minusOneForPlayerTwo() {
        let applicationData = ["Player" : 2, "PosOrNeg":false]
        if let session = session where session.reachable {
            session.sendMessage(applicationData,
                                replyHandler: { replyData in
                                    // handle reply from iPhone app here
                                    print(replyData)
                }, errorHandler: { error in
                    // catch any errors here
                    print(error)
            })
        } else {
            // when the iPhone is not connected via Bluetooth
        }

    }
    
    
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
    }
    
    override func willActivate() {
        super.willActivate()
    }
    
    override func didDeactivate() {
        super.didDeactivate()
    }

}
