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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addPlayerButtonWasSelected(sender: AnyObject) {
        
        guard let fName = firstNameTextField.text, let lName = lastNameTextField.text else {
            return
        }
        
        if fName.characters.isEmpty || lName.isEmpty {
            print("Emptyness is unacceptable")
            return
        }
        
        createNewUser(fName, lastname: lName, success: nil, failure: nil)
    }
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
