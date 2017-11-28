//
//  ViewController.swift
//  DateCourse
//
//  Created by Gimin Moon on 11/16/17.
//  Copyright © 2017 Gimin Moon. All rights reserved.
//

import UIKit
import FirebaseCore
import FirebaseAuth

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    //var userID = Auth.auth().currentUser?.uid
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameField.delegate = self
        passwordField.delegate = self
        self.hidKeyBoardWhenTapped()
    }

    @IBAction func logInButtonTapped(_ sender: UIButton) {
        Auth.auth().signIn(withEmail: usernameField.text!, password: passwordField.text!){
            (user, error) in
            //wrong error credientials
            if(error != nil){
                let loginerrorAlert = UIAlertController(title: "Login error!", message: "\(error!.localizedDescription) Please try again.", preferredStyle: .alert)
                loginerrorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(loginerrorAlert, animated: true, completion: nil)
                return
            }
            //take user to realtime firebase database
            if user!.isEmailVerified{
                //if logged in, move on to the next viewcontroller
                //self.performSegue(withIdentifier: "ToHomeScreen", sender: nil)
                let storyboard:UIStoryboard = UIStoryboard(name:"Main", bundle:nil)
                let homeVC:MainViewController = storyboard.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
                self.present(homeVC, animated: true, completion: nil)
            }
            else{
                let notVerfiedAlert = UIAlertController(title:"Not verified", message: "Your account is pending verification. Please check your email and verify your account.", preferredStyle: .alert)
                notVerfiedAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(notVerfiedAlert, animated: true, completion: nil)
                do{
                    try Auth.auth().signOut()
                } catch{
                    //handle error
                }
            }
            
        }
    }
    @IBAction func forgotPasswordTapped(_ sender: Any) {
        let forgotPwAlert = UIAlertController(title:"Forgot Password?", message : "Enter your email to reset your password", preferredStyle: .alert)
        forgotPwAlert.addTextField{(textField) in textField.placeholder = "Enter your email address"
        }
        forgotPwAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        forgotPwAlert.addAction(UIAlertAction(title: "Reset Password", style: .default, handler: {(action) in
            let resetEmail = forgotPwAlert.textFields?.first?.text
            Auth.auth().sendPasswordReset(withEmail: resetEmail!, completion: {(error) in
                if error != nil{
                    let resetFailedAlert = UIAlertController(title: "Reset Failed", message: "Error: \(String(describing: error?.localizedDescription))", preferredStyle: .alert)
                    resetFailedAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(resetFailedAlert, animated: true, completion: nil)
                }else{
                    let resetEmalSentAlert = UIAlertController(title: "Reset Email Sent", message: "A password reset email has been sent to your registered email. Please check your email for further password reset instructions", preferredStyle: .alert)
                    
                    //creates an ok button so when the user taps, the alert goes away
                    resetEmalSentAlert.addAction(UIAlertAction(title: "OK", style: .default, handler:nil))
                    //need to present to show it to the user
                    self.present(resetEmalSentAlert, animated: true, completion: nil)
                }
            })
        }))
        self.present(forgotPwAlert, animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == usernameField{
            passwordField.becomeFirstResponder()
        }else{
            usernameField.becomeFirstResponder()
        }
        return true
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

