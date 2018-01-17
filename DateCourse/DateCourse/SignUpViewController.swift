//
//  SignUpViewController.swift
//  DateCourse
//
//  Created by Gimin Moon on 11/16/17.
//  Copyright © 2017 Gimin Moon. All rights reserved.
//

import UIKit
import Firebase
import FirebaseCore
import FirebaseAuth
import FirebaseDatabase

class SignUpViewController: UIViewController, UITextFieldDelegate {
    //note that they're all optionals
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var reenterPasswordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.usernameField.delegate = self
        self.passwordField.delegate = self
        self.reenterPasswordField.delegate = self
        self.hidKeyBoardWhenTapped()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    @IBAction func cancelButtonTapped(_ sender: Any) {
        //dismiss when its tapped
        dismiss(animated: true, completion: nil)
        print("hi")
    }
    @IBAction func createAccountTapped(_ sender: Any) {
        if passwordField.text == reenterPasswordField.text{
            Auth.auth().createUser(withEmail: usernameField.text!, password: passwordField.text!, completion: {(user,error) in
                
                if error != nil {
                    let signuperrorAlert = UIAlertController(title: "Sign Up Error", message: "\(String(describing: error?.localizedDescription)) Please try again later", preferredStyle: .alert)
                    signuperrorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(signuperrorAlert, animated: true, completion: nil)
                    return
                }
                
                let user = Auth.auth().currentUser
                guard let uid = user?.uid else{
                    return
                }
                let ref = Database.database(url: "https://datecourse-app.firebaseio.com/").reference()
                let userReference = ref.child("users").child(uid)
                let values = ["email": self.usernameField.text]
                userReference.updateChildValues(values, withCompletionBlock: {(err,ref) in
                    if err != nil {
                        print(err)
                        return
                    }
                    print("saved user in firebase")
                })
                self.sendEmail()
                self.dismiss(animated: true, completion: nil)
            })
        }
        else{
            let passNotMatch = UIAlertController(title: "Error!", message: "Passwords Do Not Match! Please try again", preferredStyle: .alert)
            passNotMatch.addAction(UIAlertAction(title: "OK", style: .default, handler: {(action) in
                self.passwordField.text = ""
                self.reenterPasswordField.text = ""
            }))
            present(passNotMatch, animated: true, completion: nil)
        
        }
    }
    
    func sendEmail(){
        Auth.auth().signIn(withEmail: usernameField.text!, password: passwordField.text!, completion: {(user, error) in
            if error != nil{
                print("Error: \(String(describing:error!.localizedDescription))")
                return
            }
            Auth.auth().currentUser?.sendEmailVerification(completion: { (error) in
                if error != nil{
                    let emailNotSentAlert = UIAlertController(title: "Email Verification", message: "verification email failed to send: \(String(describing: error?.localizedDescription))", preferredStyle: .alert)
                    self.present(emailNotSentAlert, animated: true, completion: nil)
                }
                else{
                    let emailSentAlrt = UIAlertController(title: "Email Verification", message: "Verficiation email has been sent. Please tap on the link in the email to verfiy your account.", preferredStyle: .alert)
                    self.present(emailSentAlrt, animated: true, completion: {
                        self.dismiss(animated: true, completion: nil)
                    })
                }
                do{
                    try Auth.auth().signOut()
                } catch{
                    //error handle
                }
            })
        })
    }
    // know this -> first responder
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        if textField == usernameField{
            passwordField.becomeFirstResponder()
        } else if textField == passwordField{
            reenterPasswordField.becomeFirstResponder()
        } else{
            textField.resignFirstResponder()
        }
        
        return true
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

// extension to get keyboard out of the way

