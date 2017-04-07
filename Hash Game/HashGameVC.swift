//
//  HashGameVC.swift
//  Hash Game
//
//  Created by Kesley Ribeiro on 31/Mar/17.
//  Copyright © 2017 App ao Cubo. All rights reserved.
//

import UIKit
import CoreData

// Global vars
var pointsPlayer1 = 0
var pointsPlayer2 = 0
var quantityGamesFinished = 0

let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
let game = Game(context: context)

class HashGameVC: UIViewController, UITextFieldDelegate {

    var activePlayer = 1
    var gameActive = true
    var gameState = [0, 0, 0, 0, 0, 0, 0, 0, 0]
    var cliksCount = 0
    var firstGame = true
    var playButton = UIButton() // Create new button
    let firstView = UIView() // Create new view
    
    // Combinations possible to winner game
    let correctCombinations = [[0, 1, 2], [3, 4, 5], [6, 7, 8], [0, 3, 6], [1, 4, 7], [2, 5, 8], [0, 4, 8], [2, 4, 6]]

    // Objects of view
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var playAgainButton: UIButton!
    @IBOutlet weak var gameOverLabel: UILabel!
    @IBOutlet weak var namePlayer1Lbl: UILabel!
    @IBOutlet weak var namePlayer2Lbl: UILabel!
    @IBOutlet weak var pointsPlayer1Lbl: UILabel!
    @IBOutlet weak var pointsPlayer2Lbl: UILabel!
    @IBOutlet weak var qttGamesLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Without text in back button item
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
        
        // Round edge of Play again button
        //playButton.layer.cornerRadius = playButton.bounds.width / 12
        playAgainButton.layer.cornerRadius = playAgainButton.bounds.width / 12
        gameOverLabel.layer.masksToBounds = true
        gameOverLabel.layer.cornerRadius = 5
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

        if firstGame == true {
            
            viewFirstGame()
    
            // Hidden the label and button
            playAgainButton.isHidden = true
            gameOverLabel.isHidden = true
        } else {
            
            firstGame = false

            // Hidden the label and button
            playButton.isHidden = true
            playAgainButton.isHidden = true
            gameOverLabel.isHidden = true

            // Call the function to play again
            playAgain()
        }
        // Save status of game in Core Data
        game.firstGame = firstGame
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }

    func viewFirstGame() {
        
        // Show the button
        playButton.isHidden = false

        firstView.backgroundColor = .black // View color
        firstView.frame.size.width = 320 // Width view
        firstView.frame.size.height = 478 // Height view
        firstView.center.y = view.center.y - 78 // Position of view
        firstView.alpha = 0.6 // Opacity of view
        self.view.addSubview(firstView) // Add view to view controller

        playButton = UIButton(frame: CGRect(x: 20, y: firstView.center.y - 76, width: 278, height: 48))
        playButton.setTitle("PLAY", for: .normal) // Set title button
        playButton.setTitleColor(.white, for: .normal) // Title color
        playButton.backgroundColor = color2 // Button color
        playButton.layer.cornerRadius = playButton.bounds.width / 12 // Bounds button
        
        playButton.addTarget(self, action: #selector(HashGameVC.tapped), for: .touchUpInside)
        self.view.addSubview(playButton) // Add button to viewFirstGame
    }
    
    func tapped() {

        firstGame = false

        // Save status of game in Core Data
        game.firstGame = firstGame
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        
        var namePlayer1TextField: UITextField!
        var namePlayer2TextField: UITextField!

        let alertController = UIAlertController(title: "Names of the Players", message: "", preferredStyle: .alert)

        let saveAction = UIAlertAction(title: "SAVE", style: .default, handler: {(action) -> Void in

            if namePlayer1TextField.text!.isEmpty || namePlayer2TextField.text!.isEmpty {

                game.namePlayer1 = "Player 1"
                game.namePlayer2 = "Player 2"
                self.namePlayer1Lbl.text = game.namePlayer1
                self.namePlayer2Lbl.text = game.namePlayer2

                game.pointsPlayer1 = 0
                game.pointsPlayer2 = 0
                game.qttGames = 0

                self.pointsPlayer1Lbl.text = "\(game.pointsPlayer1)"
                self.pointsPlayer2Lbl.text = "\(game.pointsPlayer2)"
                self.qttGamesLbl.text = "\(game.qttGames)"
                
                (UIApplication.shared.delegate as! AppDelegate).saveContext()
            }
            else {

                self.playButton.isHidden = true
                self.firstView.isHidden = true

                game.namePlayer1 = namePlayer1TextField.text!
                game.namePlayer2 = namePlayer2TextField.text!

                self.namePlayer1Lbl.text = game.namePlayer1
                self.namePlayer2Lbl.text = game.namePlayer2

                game.pointsPlayer1 = 0
                game.pointsPlayer2 = 0
                game.qttGames = 0

                self.pointsPlayer1Lbl.text = "\(game.pointsPlayer1)"
                self.pointsPlayer2Lbl.text = "\(game.pointsPlayer2)"
                self.qttGamesLbl.text = "\(game.qttGames)"
                
                (UIApplication.shared.delegate as! AppDelegate).saveContext()
            }
        })
        
        let cancelAction = UIAlertAction(title: "CANCEL", style: .default, handler: {(action) -> Void in })
        
        alertController.addTextField {(textField) -> Void in
            
            textField.text! = "Player 1"
            namePlayer1TextField = textField
            
            // Set red color to text in placeholder
            namePlayer1TextField.attributedPlaceholder = NSAttributedString(string: "First name of the Player 1", attributes: [NSForegroundColorAttributeName: UIColor.red])
        }

        alertController.addTextField { (textField : UITextField!) -> Void in
            
            textField.text! = "Player 2"
            namePlayer2TextField = textField
            
            // Set red color to text in placeholder
            namePlayer2TextField.attributedPlaceholder = NSAttributedString(string: "First name of the Player 2", attributes: [NSForegroundColorAttributeName: UIColor.red])
        }
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func playAgainPressed(_ sender: AnyObject) {
        
        // Call the function to play again
        playAgain()
    }
    
    // Function to play again
    func playAgain() {
        
        // Define the player 1 as actived
        activePlayer = 1
        
        // Define that exist a game active
        gameActive = true
        
        // Array to save the tag of each position selected from the user
        gameState = [0, 0, 0, 0, 0, 0, 0, 0, 0]
        
        // Button of options that user can to select
        var button: UIButton
        
        for i in 0 ..< 9 {
            
            button = view.viewWithTag(i) as! UIButton
            button.setImage(nil, for: UIControlState())
        }

        // Hidden the label and button
        gameOverLabel.isHidden = true
        playAgainButton.isHidden = true

        // Change the position of the label and button 500px to left
        gameOverLabel.center = CGPoint(x: gameOverLabel.center.x - 500, y: gameOverLabel.center.y)
        playAgainButton.center = CGPoint(x: playAgainButton.center.x - 500, y: playAgainButton.center.y)
    }
    
    // When user seletec a position to play
    @IBAction func buttonPressed(_ sender: AnyObject) {

        // If the postion selected has a tag 0 and exist a game active
        if gameState[sender.tag] == 0 && gameActive == true {

            // More one clicks cout
            cliksCount += 1

            var image = UIImage()
            
            gameState[sender.tag] = activePlayer
            
            // User 1 is active
            if activePlayer == 1 {
                
                // Set the image of the position
                image = UIImage(named: "X.png")!
                
                // Change to active the user 2
                activePlayer = 2
            }
            // User 2 is active
            else {
                
                // Set the image of the position
                image = UIImage(named: "2 star.png")!
                
                // Change to active the user 1
                activePlayer = 1
            }
            sender.setImage(image, for: UIControlState())
            
            for combination in correctCombinations {
                
                if gameState[combination[0]] != 0 && gameState[combination[0]] == gameState[combination[1]] && gameState[combination[1]] == gameState[combination[2]] {
                    
                    var winnerText = "Player 1 winner"
                    
                    if gameState[combination[0]] == 2 {
                        winnerText = "Player 2 winner"
                        
                        // Set 0 to cliksCount
                        cliksCount = 0
                        
                        // More one point to Player 2
                        pointsPlayer2 += 1
                        game.pointsPlayer2 = Int16(pointsPlayer2)
                        pointsPlayer2Lbl.text = "\(game.pointsPlayer2)"
                        
                        (UIApplication.shared.delegate as! AppDelegate).saveContext()
                    }
                    
                    gameOverLabel.text = winnerText
                    
                    // Show the label and button
                    gameOverLabel.isHidden = false
                    playAgainButton.isHidden = false
                    
                    // Animation in label and button
                    UIView.animate(withDuration: 0.5, animations: { () -> Void in
                        
                        // Change the position of the label and button 500px to right - standard position
                        self.gameOverLabel.center = CGPoint(x: self.gameOverLabel.center.x + 500, y: self.gameOverLabel.center.y)
                        self.playAgainButton.center = CGPoint(x: self.playAgainButton.center.x + 500, y: self.playAgainButton.center.y)
                    })
                    
                    // We not have game active in this moment
                    gameActive = false
                    
                    // Set 0 to cliksCount
                    cliksCount = 0
                    
                    // More one point to Player 1
                    pointsPlayer1 += 1
                    game.pointsPlayer1 = Int16(pointsPlayer1)
                    pointsPlayer1Lbl.text = "\(game.pointsPlayer1)"
                    
                    // More one to quantityGamesFinished
                    quantityGamesFinished += 1
                    game.qttGames = Int16(quantityGamesFinished)
                    qttGamesLbl.text = "\(game.qttGames)"
                    
                    (UIApplication.shared.delegate as! AppDelegate).saveContext()
                }
            }
            
            // Without winner
            if cliksCount == 9 && gameActive {
                
                // Set 0 to cliksCount
                cliksCount = 0
                
                // We not have game active in this moment
                gameActive = false
                
                // Show the label and button
                gameOverLabel.isHidden = false
                playAgainButton.isHidden = false
                
                gameOverLabel.text = "Without winner.\nPLAY AGAIN!"

                // Animation in label and button
                UIView.animate(withDuration: 0.5, animations: { () -> Void in
                    
                    // Change the position of the label and button 500px to right - standard position
                    self.gameOverLabel.center = CGPoint(x: self.gameOverLabel.center.x + 500, y: self.gameOverLabel.center.y)
                    self.playAgainButton.center = CGPoint(x: self.playAgainButton.center.x + 500, y: self.playAgainButton.center.y)
                })
                
                // More one to quantityGamesFinished
                quantityGamesFinished += 1
                game.qttGames = Int16(quantityGamesFinished)
                qttGamesLbl.text = "\(game.qttGames)"
                
                (UIApplication.shared.delegate as! AppDelegate).saveContext()
            }
        }
    }

}

