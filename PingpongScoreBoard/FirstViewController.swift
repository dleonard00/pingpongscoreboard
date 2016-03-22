//
//  FirstViewController.swift
//  PingpongScoreBoard
//
//  Created by doug on 3/4/16.
//  Copyright © 2016 Weave. All rights reserved.
//

import UIKit
import WatchConnectivity

class FirstViewController: UIViewController {
    private var counterData = [Int]()
    private let session: WCSession? = WCSession.isSupported() ? WCSession.defaultSession() : nil

    @IBOutlet weak var player1Label: UILabel!
    @IBOutlet weak var player1ScoreLabel: UILabel!
    @IBOutlet weak var player2Label: UILabel!
    @IBOutlet weak var player2ScoreLabel: UILabel!
    @IBOutlet weak var turnToServeLabel: UILabel!
    @IBOutlet weak var gameButton: UIButton!
    
    var player1Score = 0
    var player2Score = 0
    var gameOver = true
    var tento10 = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureWCSession()
        // Do any additional setup after loading the view, typically from a nib.
        resetGameParameters()
        setupGestureRecognizers()
        gameOver = true // wait for user to start game before enabling gestures
        self.gameButton.setTitle("Start Game", forState:.Normal)
    }
    
    private func configureWCSession() {
        session?.delegate = self
        session?.activateSession()
    }
    
    func setupGestureRecognizers() {
        let swipeRightRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(addP2))
        swipeRightRecognizer.direction = .Right
        self.view.addGestureRecognizer(swipeRightRecognizer)
        let swipeLeftRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(addP1))
        swipeLeftRecognizer.direction = .Left
        self.view.addGestureRecognizer(swipeLeftRecognizer)
        let swipeDownRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipedDown))
        swipeDownRecognizer.direction = .Down
        self.view.addGestureRecognizer(swipeDownRecognizer)
    }
    
    func addP1(){
        print("Player1 Scored")
        if gameOver == true { return }
        player1Score = player1Score < 50 ? player1Score + 1 : player1Score
        player1ScoreLabel.text = player1Score.description
        if player1Score > 10 {
            determineWinner()
        }
        checkWhoServesNext()
    }
    
    func addP2(){
        print("Player2 Scored")
        if gameOver == true { return }
        player2Score = player2Score < 50 ? player2Score + 1 : player2Score
        player2ScoreLabel.text = player2Score.description
        if player2Score > 10 {
            determineWinner()
        }
        checkWhoServesNext()
    }
    
    func determineWinner(){
        if player1Score - player2Score > 1 {
            player1Label.text = "⭐️Winner⭐️"
            gameOver = true
            self.gameButton.setTitle("Start Game", forState:.Normal)
        } else if player2Score - player1Score > 1 {
            player2Label.text = "⭐️Winner⭐️"
            gameOver = true
            self.gameButton.setTitle("Start Game", forState:.Normal)
        }
    }
    
    func minusP1(){
        if gameOver == true { return }
        print("Player1 didn't actually score")
        player1Score = player1Score > 0 ? player1Score - 1 : player1Score
        
        player1ScoreLabel.text = player1Score.description
        
        checkWhoServesNext()
    }
    
    func minusP2(){
         print("Player2 didn't actually score")
        if gameOver == true { return }
        
        player2Score = player2Score > 0 ? player2Score - 1 : player2Score
        
        player2ScoreLabel.text = player2Score.description
        checkWhoServesNext()
    }

    @IBAction func newGameButtonWasSelected(sender: AnyObject) {
        resetGameParameters()
        alertWhoServesFirst()
        self.gameButton.setTitle("New Game", forState:.Normal)
    }
    
    func alertWhoServesFirst(){
        let alert = UIAlertController(title: "Which player will serve first?", message: nil, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Player 1", style: .Default, handler: { action -> Void in
            self.turnToServeLabel.text = "←"
        }))
        alert.addAction(UIAlertAction(title: "Player 2", style: .Default, handler: { action -> Void in
            self.turnToServeLabel.text = "→"
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func swipedDown(){
        print("swipedDown")
        if gameOver == true { return }
        player1Score = player1Score > 0 ? player1Score - 1 : player1Score
        player2Score = player2Score > 0 ? player2Score - 1 : player2Score
        
        player1ScoreLabel.text = player1Score.description
        player2ScoreLabel.text = player2Score.description
        checkWhoServesNext()
    }

    
    func checkWhoServesNext(){
        if player1Score == 10 && player2Score == 10 {
            tento10 = true
        }
        if tento10 {
            swapWhoServesNext()
        } else {
            if (player1Score + player2Score) % 2 == 0 {
                swapWhoServesNext()
            }
        }
    }
    
    func swapWhoServesNext(){
        if turnToServeLabel.text == "→" {
            turnToServeLabel.text = "←"
        } else {
            turnToServeLabel.text = "→"
        }
    }
    
    func resetGameParameters(){
        player1Score = 0
        player2Score = 0
        player1ScoreLabel.text = player1Score.description
        player2ScoreLabel.text = player2Score.description
        player1Label.text = "Player 1"
        player2Label.text = "Player 2"
        gameOver = false
        tento10 = false
    }

}

extension FirstViewController: WCSessionDelegate {
    
    func session(session: WCSession, didReceiveMessage message: [String : AnyObject], replyHandler: ([String : AnyObject]) -> Void) {
        
        //Use this to update the UI instantaneously (otherwise, takes a little while)
        dispatch_async(dispatch_get_main_queue()) {
            //let applicationData = ["Player" : 1, "PosOrNeg":false]
            // Determin wich Player
            // Determin + or -
            //Change score
            if let player = message["Player"] as? Int, addPoint = message["PosOrNeg"] as? Bool {
                if player == 1 {
                    if addPoint {
                        self.addP1()
                    } else {
                        self.minusP1()
                    }
                } else {
                    if addPoint {
                        self.addP2()
                    } else {
                        self.minusP2()
                    }
                }
            }
        }
    }
}


