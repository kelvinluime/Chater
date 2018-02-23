//
//  LoginViewController.swift
//  Chater
//
//  Created by Kelvin Lui on 2/21/18.
//  Copyright © 2018 Kelvin Lui. All rights reserved.
//

import UIKit
import Parse 

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onSignin(_ sender: Any) {
        loginUser()
    }
    
    @IBAction func onSignup(_ sender: Any) {
        if (usernameField.text?.isEmpty)! || (passwordField.text?.isEmpty)! {
            let alertController = UIAlertController(title: "Username or password is empty", message: "Please try again.", preferredStyle: .alert)
            // create a cancel action
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
                // handle cancel response here. Doing nothing will dismiss the view.
            }
            // add the cancel action to the alertController
            alertController.addAction(cancelAction)
            
            // create an OK action
            let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
                // handle response here.
            }
            // add the OK action to the alert controller
            alertController.addAction(OKAction)
            
            present(alertController, animated: true) {
                // optional code for what happens after the alert controller has finished presenting
            }
        }
        registerUser()
    }
    
    func loginUser() {
        
        let username = usernameField.text ?? ""
        let password = passwordField.text ?? ""
        
        PFUser.logInWithUsername(inBackground: username, password: password) { (user: PFUser?, error: Error?) in
            if let error = error {
                print("User log in failed: \(error.localizedDescription)")
                if (self.usernameField.text?.isEmpty)! || (self.passwordField.text?.isEmpty)! {
                    let alertController = UIAlertController(title: "Error occurs when attempting to login", message: error.localizedDescription, preferredStyle: .alert)
                    // create a cancel action
                    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
                        // handle cancel response here. Doing nothing will dismiss the view.
                    }
                    // add the cancel action to the alertController
                    alertController.addAction(cancelAction)
                    
                    // create an OK action
                    let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
                        // handle response here.
                    }
                    // add the OK action to the alert controller
                    alertController.addAction(OKAction)
                    
                    self.present(alertController, animated: true) {
                        // optional code for what happens after the alert controller has finished presenting
                    }
                }
            } else {
                print("User logged in successfully")
                // display view controller that needs to shown after successful login
                self.performSegue(withIdentifier: "mainViewController", sender: nil)
            }
        }
    }
    
    func registerUser() {
        // initialize a user object
        let newUser = PFUser()
        
        // set user properties
        newUser.username = usernameField.text
        newUser.password = passwordField.text
        
        newUser.signUpInBackground { (success: Bool, error: Error?) in
            if let error = error {
                print(error.localizedDescription)
                if (self.usernameField.text?.isEmpty)! || (self.passwordField.text?.isEmpty)! {
                    let alertController = UIAlertController(title: "Error occurs when attempting to sign up", message: error.localizedDescription, preferredStyle: .alert)
                    // create a cancel action
                    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
                        // handle cancel response here. Doing nothing will dismiss the view.
                    }
                    // add the cancel action to the alertController
                    alertController.addAction(cancelAction)
                    
                    // create an OK action
                    let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
                        // handle response here.
                    }
                    // add the OK action to the alert controller
                    alertController.addAction(OKAction)
                    
                    self.present(alertController, animated: true) {
                        // optional code for what happens after the alert controller has finished presenting
                    }
            } else {
                print("User Registered successfully")
                // manually segue to logged in view
            }
        }
    }
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
