//
//  PlayerTableViewController.swift
//  PingpongScoreBoard
//
//  Created by doug on 3/4/16.
//  Copyright © 2016 Weave. All rights reserved.
//

import UIKit
import Firebase


class PlayerTableViewController: UITableViewController {

    @IBOutlet weak var navTitle: UINavigationItem!
    
    var firstVC = FirstViewController()
    
    let usersRef = Firebase(url: "https://pingpongscoreboard.firebaseio.com/users")

    var userArray = [String : User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "addPlayer")
        
        self.navigationItem.rightBarButtonItem = addButton
        self.navigationItem.leftBarButtonItem = self.editButtonItem()

        let failureClosure = {
//            print("failed")
        }
        
        let successClosure = {
//            print("success")
        }
        
        createNewUser("user-fname\(Int(arc4random_uniform(1000)))", lastname: "user-lname\(Int(arc4random_uniform(1000)))", success: successClosure, failure: failureClosure)

        fetchUserList()
    }
    
    func addPlayer(){
        print("addPlayer")
        
        let addPlayerAlert = UIAlertController(title: "Add Player", message: "", preferredStyle: .Alert)
        
        addPlayerAlert.addTextFieldWithConfigurationHandler { (textField) -> Void in
            textField.placeholder = "First Name"
        }
        
        addPlayerAlert.addTextFieldWithConfigurationHandler { (textField) -> Void in
            textField.placeholder = "Last Name"
        }
        
        let addAction = UIAlertAction(title: "Add", style: .Default) { (alertAction) -> Void in
            print("add: \(addPlayerAlert.textFields!.first?.text) \(addPlayerAlert.textFields!.last?.text)")
            guard let fName = addPlayerAlert.textFields!.first?.text, let lName = addPlayerAlert.textFields!.last?.text else {
                return
            }
            
            if fName.characters.isEmpty || lName.isEmpty {
                print("Emptyness is unacceptable")
                return
            }
            createNewUser(fName, lastname: lName, success: nil, failure: nil)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .Default, handler: nil)
        
        addPlayerAlert.addAction(addAction)
        addPlayerAlert.addAction(cancelAction)
        self.presentViewController(addPlayerAlert, animated: true, completion: nil)
        
        }
    
    func fetchUserList(){
        usersRef.observeEventType(.ChildAdded, withBlock: { snapshot in
            guard let first = snapshot.value.objectForKey("firstname") as? String, last = snapshot.value.objectForKey("lastname") as? String else {
                return
            }
            let newUser = User(uid:snapshot.key, firstname: first, lastname: last)
            self.userArray[snapshot.key] = newUser
            self.tableView.reloadData()
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return userArray.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)
        let cell = UITableViewCell(style: .Subtitle, reuseIdentifier: "cell")
        let user = Array(userArray.values)[indexPath.row]
        cell.textLabel?.text = "\(user.firstname) \(user.lastname)"
        
        return cell
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }


    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            let cellOfInterest = tableView.cellForRowAtIndexPath(indexPath)
            guard let fullName = cellOfInterest?.textLabel?.text else {
                print("There was in issue with the textLable of the cellOfInterest")
                return
            }
        
            let userOfInterest = userArray.filter({ "\($0.1.firstname) \($0.1.lastname)" == fullName })
            guard let userOfInterestUnwrapped = userOfInterest.first else {
                print("issue getting the first userOfInterest")
                return
            }
            let deleteRef = usersRef.childByAppendingPath(userOfInterestUnwrapped.0)
            deleteRef.removeValue()
            self.userArray.removeValueForKey(userOfInterestUnwrapped.0)
            
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cellOfInterest = tableView.cellForRowAtIndexPath(indexPath)

        if navTitle.title == "Select Player 2" {
            firstVC.player2Label.text = cellOfInterest?.textLabel?.text
            navTitle.title = "Select Player 1"
            self.dismissViewControllerAnimated(true, completion: nil)
            return
        }
        
        firstVC.player1Label.text = cellOfInterest?.textLabel?.text
        navTitle.title = "Select Player 2"
    }
    
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
