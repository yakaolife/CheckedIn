//
//  LoginViewController.swift
//  CheckedIn
//
//  Created by Ya Kao on 10/26/14.
//  Copyright (c) 2014 Group6. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    var isSignedin = false
    
    @IBOutlet weak var usernameText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func onLogin(sender: AnyObject) {
        PFUser.logInWithUsernameInBackground(usernameText.text, password:passwordText.text) {
            
            (user: PFUser!, error: NSError!) -> Void in
            if error == nil {
                self.isSignedin = true
                println("user login")
                println("current user is \(PFUser.currentUser().username)")
                self.performSegueWithIdentifier("ProfileSegue", sender: self)
                
            } else {
                self.isSignedin = false
                UIAlertView(title: "login error", message: "\(error)" , delegate: nil, cancelButtonTitle: "ok").show()
                
                
            }
        }
    }
    
    @IBAction func onSignUp(sender: AnyObject) {
        println("onSignup")
        self.performSegueWithIdentifier("SignupSegue", sender: self)
    }

}
