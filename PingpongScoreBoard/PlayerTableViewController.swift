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

    let usersRef = Firebase(url: "https://pingpongscoreboard.firebaseio.com/users")

    var userArray = [String : User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        let failureClosure = {
//            print("failed")
        }
        
        let successClosure = {
//            print("success")
        }
        
        createNewUser("user-fname\(Int(arc4random_uniform(1000)))", lastname: "user-lname\(Int(arc4random_uniform(1000)))", success: successClosure, failure: failureClosure)

        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        fetchUserList()
    }
    
    func fetchUserList(){
        
        // Retrieve new posts as they are added to your database
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
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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
