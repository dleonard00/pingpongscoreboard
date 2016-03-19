//
//  PingpongAPI.swift
//  PingpongScoreBoard
//
//  Created by doug on 3/4/16.
//  Copyright © 2016 Weave. All rights reserved.
//

import Foundation
import Firebase

let ref = Firebase(url: "https://pingpongscoreboard.firebaseio.com")

func createNewUser(firstname: String, lastname: String, success: (() -> Void)?, failure: (() -> Void)?){
    let newGroupRef = ref.childByAppendingPath("users").childByAutoId()
    let newGroup = ["firstname": firstname, "lastname": lastname, "created": FirebaseServerValue.timestamp()]
    newGroupRef.setValue(newGroup, withCompletionBlock: {
        (error: NSError?, ref: Firebase!) in
        if error != nil {
            print("createNewUser FAILED")
            failure?()
        } else {
            print("createNewUser SUCCESS!")
            success?()
        }
    })
}
