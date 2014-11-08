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
    
    @IBOutlet weak var animateLogo: UIImageView!
    @IBOutlet weak var usernameText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    var imageNames = ["logo01.png", "logo02.png", "logo03.png", "logo04.png", "logo05.png", "logo06.png", "logo07.png", "logo07.png", "logo07.png", "logo07.png", "logo07.png", "logo07.png"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        var images = NSMutableArray()
        for var index = 0; index < imageNames.count; index++ {
            images.addObject(UIImage(named: imageNames[index])!)
        }

        animateLogo.animationImages = images
        animateLogo.animationDuration = 1.5
        animateLogo.startAnimating()
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
