//
//  ConfigGameVC.swift
//  Hash Game
//
//  Created by Kesley Ribeiro on 31/Mar/17.
//  Copyright © 2017 App ao Cubo. All rights reserved.
//

import UIKit

// Global vars
var namePlayer1 = String()
var namePlayer2 = String()

class ConfigGameVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var namePlayer1Txt: UITextField!
    @IBOutlet weak var namePlayer2Txt: UITextField!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var namePlayer1Lbl: UILabel!
    @IBOutlet weak var namePlayer2Lbl: UILabel!
    @IBOutlet weak var pointsPlayer1Lbl: UILabel!
    @IBOutlet weak var pointsPlayer2Lbl: UILabel!
    @IBOutlet weak var qttGamesLbl: UILabel!
    
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
        qttGamesLbl.text = "\(quantityGamesFinished)"
        namePlayer1Lbl.text = namePlayer1
        namePlayer2Lbl.text = namePlayer2
        
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
        if namePlayer1Txt.text!.isEmpty {
            
            saveBtn.isEnabled = false
            saveBtn.alpha = 0.3
            
        } // If textfield was modified - activate Save button
        else {
            saveBtn.isEnabled = true
            saveBtn.alpha = 1
        }
    }

    @IBAction func saveDataBtn(_ sender: Any) {
    
        // Remove the keyboard
        self.view.endEditing(false)
        
        namePlayer1 = namePlayer1Txt.text!
        namePlayer2 = namePlayer2Txt.text!
        namePlayer1Lbl.text = namePlayer1
        namePlayer2Lbl.text = namePlayer2

        // Remove task modified in list tasks
        //listTasks.remove(at: indexList)
        
        // Add in listTasks an new task
        //listTasks.append(task.text!)
        
        // Save the new data in user defaults
        //UserDefaults.standard.set(listTasks, forKey: "listTasks")
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
    
        pointsPlayer1Lbl.text = "0"
        pointsPlayer2Lbl.text = "0"
        qttGamesLbl.text = "0"

        pointsPlayer1 = 0
        pointsPlayer2 = 0
        quantityGamesFinished = 0
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
