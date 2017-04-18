//
//  HashGameVC.swift
//  Hash Game
//
//  Created by Kesley Ribeiro on 31/Mar/17.
//  Copyright © 2017 Kesley Ribeiro. All rights reserved.
//

import UIKit
import CoreData

class HashGameVC: UIViewController, UITextFieldDelegate {

    var activePlayer = 1
    var gameActive = true
    var gameState = [0, 0, 0, 0, 0, 0, 0, 0, 0]
    var cliksCount = 0
    var imageButtonPlayer1 = UIImage()
    var imageButtonPlayer2 = UIImage()
    var games : [Game] = []

    // Combinations possible to winner game
    let correctCombinations = [[0, 1, 2], [3, 4, 5], [6, 7, 8], [0, 3, 6], [1, 4, 7], [2, 5, 8], [0, 4, 8], [2, 4, 6]]
    
    // List of images in array 
    let arrayOfImages : NSArray = [UIImage(named: "2 star.png")!,
                                    UIImage(named: "Arrows.png")!,
                                    UIImage(named: "Battery.png")!,
                                    UIImage(named: "Heart.png")!,
                                    UIImage(named: "Oval.png")!,
                                    UIImage(named: "Polygon.png")!,
                                    UIImage(named: "Rectangle edited.png")!,
                                    UIImage(named: "Star.png")!,
                                    UIImage(named: "Triangle.png")!,
                                    UIImage(named: "X.png")!]
    
    let arrayTrayBase : NSArray = [UIImage(named: "base-1.png")!,
                                    UIImage(named: "base-2.png")!,
                                    UIImage(named: "base-3.png")!,
                                    UIImage(named: "base-4.png")!,
                                    UIImage(named: "base-5.png")!,
                                    UIImage(named: "base-6.png")!,
                                    UIImage(named: "base-7.png")!,
                                    UIImage(named: "base-8.png")!,
                                    UIImage(named: "base-9.png")!,
                                    UIImage(named: "base-10.png")!]

    // Objects of view
    @IBOutlet weak var trayBaseImg: UIImageView!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var playAgainButton: UIButton!
    @IBOutlet weak var gameOverLabel: UILabel!
    @IBOutlet weak var namePlayer1Lbl: UILabel!
    @IBOutlet weak var namePlayer2Lbl: UILabel!
    @IBOutlet weak var pointsPlayer1Lbl: UILabel!
    @IBOutlet weak var pointsPlayer2Lbl: UILabel!
    @IBOutlet weak var qttGamesLbl: UILabel!
    @IBOutlet weak var qttStalemateLbl: UILabel!
    @IBOutlet weak var refreshBtn: UIBarButtonItem!
    @IBOutlet weak var statusPlayer1Img: UIImageView!
    @IBOutlet weak var statusPlayer2Img: UIImageView!
    @IBOutlet weak var partPlayer1Img: UIImageView!
    @IBOutlet weak var partPlayer2Img: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Without text in back button item
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem

        // Round edge of Play again button
        playAgainButton.layer.cornerRadius = playAgainButton.bounds.width / 12
        gameOverLabel.layer.masksToBounds = true
        gameOverLabel.layer.cornerRadius = 5
    }

    func getGames() {
        
        context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        do {
            games = try context.fetch(Game.fetchRequest()) as! [Game]
            
            if game.namePlayer1 != nil || game.namePlayer2 != nil {
                self.namePlayer1Lbl.text = game.namePlayer1
                self.namePlayer2Lbl.text = game.namePlayer2
                
                self.pointsPlayer1Lbl.text = "\(game.pointsPlayer1)"
                self.pointsPlayer2Lbl.text = "\(game.pointsPlayer2)"
                self.qttGamesLbl.text = "\(game.qttGames)"
                self.qttStalemateLbl.text = "\(game.qttStalemate)"
                (UIApplication.shared.delegate as! AppDelegate).saveContext()
                
            } else {

                game.namePlayer1 = "Player 1"
                game.namePlayer2 = "Player 2"
                self.namePlayer1Lbl.text = game.namePlayer1
                self.namePlayer2Lbl.text = game.namePlayer2
                self.pointsPlayer1Lbl.text = "\(game.pointsPlayer1)"
                self.pointsPlayer2Lbl.text = "\(game.pointsPlayer2)"
                self.qttGamesLbl.text = "\(game.qttGames)"
                self.qttStalemateLbl.text = "\(game.qttStalemate)"
                (UIApplication.shared.delegate as! AppDelegate).saveContext()
            }
            print("\nDados do Game: \(games)\n")
        } catch {
            print("\nWe have an error!")
        }
    }

    @IBAction func refreshDeleteGameButton(_ sender: Any) {
    
        // Create alert and define parameters title and message
        let alert = UIAlertController(title: "Finish?", message: "You want to finish the current game?", preferredStyle: .alert)
        
        // Add alert to alertActions and define title OK button
        alert.addAction(UIAlertAction(title: "YES", style: .default, handler: { (action) -> Void in
            
            // Call the function to play again
            self.playAgain()
        }))
        
        alert.addAction(UIAlertAction(title: "NO", style: .cancel, handler: {(action) -> Void in }))

        // Show alert in view
        self.present(alert, animated: true, completion: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        getGames()

        playAgainButton.isHidden = true
        gameOverLabel.isHidden = true

        statusPlayer1Img.image = UIImage(named: "active.png")
        statusPlayer2Img.image = UIImage(named: "disactivate.png")
        
        // Call the function to play again
        playAgain()

        randomLayout()
    }
    
    @IBAction func playAgainPressed(_ sender: AnyObject) {

        // Call the function to play again
        playAgain()
    }
    
    // Function to play again
    func playAgain() {

        refreshBtn.isEnabled = true

        // Call the function to random layout
        randomLayout()

        // Define the player 1 as actived
        activePlayer = 1
        statusPlayer1Img.image = UIImage(named: "active.png")
        
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

            var image = UIImage()
            
            // More one clicks cout
            cliksCount += 1
            
            gameState[sender.tag] = activePlayer
            
            // User 1 is active
            if activePlayer == 1 {
                
                image = imageButtonPlayer1 //UIImage(imageButtonPlayer1)!
                
                // Change to active the user 2
                activePlayer = 2
                statusPlayer2Img.image = UIImage(named: "active.png")
                
                // Change to disactivate to user 1
                statusPlayer1Img.image = UIImage(named: "disactivate.png")
            }
            // User 2 is active
            else {
                
                // Set the image of the position
                //image = UIImage(named: "2 star.png")!
                image = imageButtonPlayer2

                // Change to active the user 1
                activePlayer = 1
                statusPlayer1Img.image = UIImage(named: "active.png")
                
                // Change to disactivate to user 2
                statusPlayer2Img.image = UIImage(named: "disactivate.png")
            }
            sender.setImage(image, for: UIControlState())

            for combination in correctCombinations {
                
                if gameState[combination[0]] != 0 && gameState[combination[0]] == gameState[combination[1]] && gameState[combination[1]] == gameState[combination[2]] {

                    var winnerText = "\(game.namePlayer1!) winner! 😛"

                    if gameState[combination[0]] == 2 {
                        winnerText = "\(game.namePlayer2!) winner! 😜"
                        
                        // Set 0 to cliksCount
                        cliksCount = 0

                        // More one point to Player 2
                        pointsPlayer2 += 1
                        game.pointsPlayer2 = Int16(pointsPlayer2)
                        pointsPlayer2Lbl.text = "\(game.pointsPlayer2)"

                        (UIApplication.shared.delegate as! AppDelegate).saveContext()

                    } else {
                        
                        // More one point to Player 1
                        pointsPlayer1 += 1
                        game.pointsPlayer1 = Int16(pointsPlayer1)
                        pointsPlayer1Lbl.text = "\(game.pointsPlayer1)"
                        
                        (UIApplication.shared.delegate as! AppDelegate).saveContext()
                    }

                    self.refreshBtn.isEnabled = false
                    
                    statusPlayer1Img.image = UIImage(named: "active.png")
                    statusPlayer2Img.image = UIImage(named: "disactivate.png")
                    
                    gameOverLabel.text = winnerText

                    // We not have game active in this moment
                    gameActive = false
                    
                    // Set 0 to cliksCount
                    cliksCount = 0

                    // More one to quantityGamesFinished
                    quantityGamesFinished += 1
                    game.qttGames = Int16(quantityGamesFinished)
                    qttGamesLbl.text = "\(game.qttGames)"
                    
                    (UIApplication.shared.delegate as! AppDelegate).saveContext()
                    
                    // Show the label and button
                    gameOverLabel.isHidden = false
                    playAgainButton.isHidden = false

                    // Animation in label and button
                    UIView.animate(withDuration: 0.5, animations: { () -> Void in
                        
                        // Change the position of the label and button 500px to right - standard position
                        self.gameOverLabel.center = CGPoint(x: self.gameOverLabel.center.x + 500, y: self.gameOverLabel.center.y)
                        self.playAgainButton.center = CGPoint(x: self.playAgainButton.center.x + 500, y: self.playAgainButton.center.y)

                    }) {(finished:Bool) in

                        // Finished the firts animation
                        if finished {

                            // Second animation
                            UIView.animate(withDuration: 0.5, delay: 3, animations: {

                                // Change the position of the label and button 500px to right - standard position
                                self.gameOverLabel.center = CGPoint(x: self.gameOverLabel.center.x + 500, y: self.gameOverLabel.center.y)
                            })
                        }
                    }
                }
            }
            // Without winner
            if cliksCount == 9 && gameActive {
            
                self.refreshBtn.isEnabled = false

                statusPlayer1Img.image = UIImage(named: "active.png")
                statusPlayer2Img.image = UIImage(named: "disactivate.png")

                // Set 0 to cliksCount
                cliksCount = 0
                
                // We not have game active in this moment
                gameActive = false

                // Show the label and button
                gameOverLabel.isHidden = false
                playAgainButton.isHidden = false

                gameOverLabel.text = "Without winner.\nPLAY AGAIN!"
                
                // More one to quantityStalemate
                quantityStalemate += 1
                game.qttStalemate = Int16(quantityStalemate)
                qttStalemateLbl.text = "\(game.qttStalemate)"

                // More one to quantityGamesFinished
                quantityGamesFinished += 1
                game.qttGames = Int16(quantityGamesFinished)
                qttGamesLbl.text = "\(game.qttGames)"

                (UIApplication.shared.delegate as! AppDelegate).saveContext()
                
                // Animation in label and button
                UIView.animate(withDuration: 0.5, animations: { () -> Void in
                    
                    // Change the position of the label and button 500px to right - standard position
                    self.gameOverLabel.center = CGPoint(x: self.gameOverLabel.center.x + 500, y: self.gameOverLabel.center.y)
                    self.playAgainButton.center = CGPoint(x: self.playAgainButton.center.x + 500, y: self.playAgainButton.center.y)
                    
                }) { (finished:Bool) in
                    
                    // Finished the firts animation
                    if finished {
                        
                        // Second animation - zoom in
                        UIView.animate(withDuration: 0.5, delay: 3, animations: {
                            
                            // Change the position of the label and button 500px to right - standard position
                            self.gameOverLabel.center = CGPoint(x: self.gameOverLabel.center.x + 500, y: self.gameOverLabel.center.y)
                        })
                    }
                }
                (UIApplication.shared.delegate as! AppDelegate).saveContext()
            }
        }
    }
    
    // Random generating...
    func randomLayout() {
        
        // Random base generating method
        let baserange: UInt32 = UInt32(arrayTrayBase.count)
        let randombase = Int(arc4random_uniform(baserange))
        let generatedbase: AnyObject = arrayTrayBase.object(at: randombase) as AnyObject
        trayBaseImg.image = (generatedbase as? UIImage)!
        
        // Random image 1 generating method
        let imagerange: UInt32 = UInt32(arrayOfImages.count)
        let randomimage = Int(arc4random_uniform(imagerange))
        let generatedimage: AnyObject = arrayOfImages.object(at: randomimage) as AnyObject

        // Random image 2 generating method
        let imagerange2: UInt32 = UInt32(arrayOfImages.count)
        let randomimage2 = Int(arc4random_uniform(imagerange2))
        let generatedimage2: AnyObject = arrayOfImages.object(at: randomimage2) as AnyObject
        
        // If images is equals, then random image again
        if (generatedimage as? UIImage)! == (generatedimage2 as? UIImage)! {
            randomLayout()
        }
        // If images is not equals
        else {
            imageButtonPlayer1 = (generatedimage as? UIImage)!
            imageButtonPlayer2 = (generatedimage2 as? UIImage)!
            partPlayer1Img.image = (generatedimage as? UIImage)!
            partPlayer2Img.image = (generatedimage2 as? UIImage)!
        }
    }
}

