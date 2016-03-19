//
//  FirstViewController.swift
//  PingpongScoreBoard
//
//  Created by doug on 3/4/16.
//  Copyright © 2016 Weave. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

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
        // Do any additional setup after loading the view, typically from a nib.
        resetGameParameters()
        setupGestureRecognizers()
        gameOver = true // wait for user to start game before enabling gestures
        self.gameButton.setTitle("Start Game", forState:.Normal)
    }
    
    func setupGestureRecognizers() {
        let swipeRightRecognizer = UISwipeGestureRecognizer(target: self, action: "swipedRight")
        swipeRightRecognizer.direction = .Right
        self.view.addGestureRecognizer(swipeRightRecognizer)
        let swipeLeftRecognizer = UISwipeGestureRecognizer(target: self, action: "swipedLeft")
        swipeLeftRecognizer.direction = .Left
        self.view.addGestureRecognizer(swipeLeftRecognizer)
        let swipeDownRecognizer = UISwipeGestureRecognizer(target: self, action: "swipedDown")
        swipeDownRecognizer.direction = .Down
        self.view.addGestureRecognizer(swipeDownRecognizer)
    }

    func swipedRight(){
        print("swipedRight")
        if gameOver == true { return }

        player2Score = player2Score + 1
        player2ScoreLabel.text = player2Score.description
        if player2Score > 10 {
            determineWinner()
        }
        checkWhoServesNext()
    }
    
    func swipedLeft(){
        print("swipedLeft")
        if gameOver == true { return }

        player1Score = player1Score + 1
        player1ScoreLabel.text = player1Score.description
        
        if player1Score > 10 {
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
    
    func swipedDown(){
        print("swipedDown")
        if gameOver == true { return }
        player1Score = player1Score > 0 ? player1Score - 1 : player1Score
        player2Score = player2Score > 0 ? player2Score - 1 : player2Score

        player1ScoreLabel.text = player1Score.description
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
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        guard let navController = segue.destinationViewController as? UINavigationController, PTVC = navController.topViewController as? PlayerTableViewController else {
            return
        }
        PTVC.firstVC = self
        
    }


}

