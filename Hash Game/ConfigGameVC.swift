//
//  ConfigGameVC.swift
//  Hash Game
//
//  Created by Kesley Ribeiro on 31/Mar/17.
//  Copyright © 2017 Kesley Ribeiro. All rights reserved.

//

import UIKit

class ConfigGameVC: UIViewController, UITextFieldDelegate {    

    @IBOutlet weak var namePlayer1Txt: UITextField!
    @IBOutlet weak var namePlayer2Txt: UITextField!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var namePlayer1Lbl: UILabel!
    @IBOutlet weak var namePlayer2Lbl: UILabel!
    @IBOutlet weak var pointsPlayer1Lbl: UILabel!
    @IBOutlet weak var pointsPlayer2Lbl: UILabel!
    @IBOutlet weak var qttGamesLbl: UILabel!
    @IBOutlet weak var qttStalemateLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Round edge of Save button
        saveBtn.layer.cornerRadius = saveBtn.bounds.width / 9

        // Begin the button inactive
        saveBtn.isEnabled = false
        saveBtn.alpha = 0.3
        
        // Delegate the textField
        namePlayer1Txt.delegate = self
        namePlayer2Txt.delegate = self

        namePlayer1Txt.text! = game.namePlayer1!
        namePlayer2Txt.text! = game.namePlayer2!
        pointsPlayer1Lbl.text = "\(game.pointsPlayer1)"
        pointsPlayer2Lbl.text = "\(game.pointsPlayer2)"
        qttGamesLbl.text = "\(game.qttGames)"
        qttStalemateLbl.text = "\(game.qttStalemate)"
        namePlayer1Lbl.text = game.namePlayer1
        namePlayer2Lbl.text = game.namePlayer2

        (UIApplication.shared.delegate as! AppDelegate).saveContext()

        // Add target to execute function in textfield
        namePlayer1Txt.addTarget(self, action: #selector(ConfigGameVC.textFieldDidChange(_:)), for: .editingChanged)
        namePlayer2Txt.addTarget(self, action: #selector(ConfigGameVC.textFieldDidChange(_:)), for: .editingChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }

    // If some information in textfiel was modified
    func textFieldDidChange(_ textField : UITextView) {
        
        // If textfield is empty - inactivate Save button
        if namePlayer1Txt.text!.isEmpty || namePlayer2Txt.text!.isEmpty && namePlayer1Txt.text!.characters.count < 3 && namePlayer2Txt.text!.characters.count < 3 {

            saveBtn.isEnabled = false
            saveBtn.alpha = 0.3
            
        }// If textfield was modified - activate Save button
        else {
            saveBtn.isEnabled = true
            saveBtn.alpha = 1
        }
    }

    @IBAction func saveDataBtn(_ sender: Any) {
    
        // Remove the keyboard
        self.view.endEditing(false)
        
        game.namePlayer1 = namePlayer1Txt.text!
        game.namePlayer2 = namePlayer2Txt.text!
        namePlayer1Lbl.text = game.namePlayer1
        namePlayer2Lbl.text = game.namePlayer2

        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        print(game)
    }
    
    // Hide keyboard when user touch in view
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        namePlayer1Txt.resignFirstResponder()
        namePlayer2Txt.resignFirstResponder()
        return true
    }
    
    @IBAction func redefineNumbersBtn(_ sender: Any) {

        pointsPlayer1 = 0
        pointsPlayer2 = 0
        quantityGamesFinished = 0
        quantityStalemate = 0

        game.pointsPlayer1 = 0
        game.pointsPlayer2 = 0
        game.qttGames = 0
        game.qttStalemate = 0
        
        pointsPlayer1Lbl.text = "\(game.pointsPlayer1)"
        pointsPlayer2Lbl.text = "\(game.pointsPlayer2)"
        qttGamesLbl.text = "\(game.qttGames)"
        qttStalemateLbl.text = "\(game.qttStalemate)"

        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
}
