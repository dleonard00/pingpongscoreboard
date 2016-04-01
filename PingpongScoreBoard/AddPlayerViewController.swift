//
//  AddPlayerViewController.swift
//  PingpongScoreBoard
//
//  Created by doug on 3/18/16.
//  Copyright © 2016 Weave. All rights reserved.
//

import UIKit

class AddPlayerViewController: UIViewController {
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    
    @IBAction func addPlayerButtonWasSelected(sender: AnyObject) {
        
        guard let fName = firstNameTextField.text, let lName = lastNameTextField.text else {
            return
        }
        
        if fName.characters.isEmpty || lName.isEmpty {
            print("Emptiness is unacceptable")
            return
        }
        createNewUser(fName, lastname: lName, success: nil, failure: nil)
    }
}
