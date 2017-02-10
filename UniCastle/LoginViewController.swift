//
//  LoginViewController.swift
//  DotaMatch
//
//  Created by Yerbol Kopzhassar on 05/10/2016.
//  Copyright © 2016 Yerbol Kopzhassar. All rights reserved.
//

import UIKit
import TextFieldEffects
import SCLAlertView
import Parse

class LoginViewController: UIViewController {
    
    //MARK: Variables
    
    @IBOutlet weak var passwordTextField: MadokaTextField!
    @IBOutlet weak var usernameTextField: MadokaTextField!
    
    var searchString : String?
    
    var guestId : Int?
    
    //MARK: viewDid
    
    override func viewDidAppear(_ animated: Bool) {
        if guestId != nil {
            self.performSegue(withIdentifier: "guestSegue", sender: nil)
        }
    }
    
    //MARK: Login Methods
    
    func loginPressed() {
        let username = self.usernameTextField.text
        let password = self.passwordTextField.text
        
        if (((username?.characters.count)! < 4) || ((password?.characters.count)! < 4)) {
            
            let alert = UIAlertController(title: "Invalid!",
                                          message:"Email and Password must be longer than 6 charachters",
                                          preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            
            self.present(alert, animated: true, completion: nil)
            
        } else {
            
            PFUser.logInWithUsername(inBackground: username!, password: password!, block: { (user, error) in
                
                
                if ((user) != nil) {
                    //remember user
                    UserDefaults.standard.set(user!.username, forKey: "username")
                    UserDefaults.standard.synchronize()
                    
                    //call login func
                    let appDelegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
                    
                    appDelegate.login()
                    
                } else {
                    var alert:UIAlertController
                    
                    alert = UIAlertController(title: "Login Failed", message:"Unable to login, either email or password is incorrect. Have you signed up for a DotaMate account?", preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    
                    self.present(alert, animated: true, completion: nil)
                }
                
            })
        }
    }
    
    
    func searchPopUp() {
        
        let alertView = SCLAlertView(appearance: AlertHelper.loginSearchAppearance())
        
        let username = alertView.addTextField("Dota2 name")
        username.spellCheckingType = .no
        username.autocorrectionType = .no
        
        alertView.addButton("Search") {
            self.searchString = username.text
            self.performSegue(withIdentifier: "userSearchSegue", sender: nil)
        }
        
        alertView.showSuccess("Search your SteamID",
                              subTitle: "Please enter your Profile name or Steam64ID",
                              colorStyle: 0x982D1D, colorTextButton: 0xFFFFFF)
        
    }
    
   
    
    //MARK: prepareForSegue
//    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        
//        if segue.identifier == "userSearchSegue" {
//            
//            let vc = segue.destination as! UserSearchTableViewController
//            
//            vc.delegate = self
//            vc.regSearchString = searchString
//            
//        } else if segue.identifier == "guestSegue" {
//            let vc = segue.destination as! DotaMatchViewController
//            
//            vc.guestId = guestId
//        }
//        
//    }
    
    //MARK: IBOutlets
    
    @IBAction func signupButton(_ sender: UIButton) {
        AppService.shared.username = usernameTextField.text!
        AppService.shared.password = passwordTextField.text!
    }
    
    @IBAction func loginButton(_ sender: UIButton) {
        loginPressed()
    }
    
    @IBAction func guestButton(_ sender: UIButton) {
        searchPopUp()
    }
    
}
