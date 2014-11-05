//
//  SignUpViewController.swift
//  CheckedIn
//
//  Created by Ya Kao on 10/25/14.
//  Copyright (c) 2014 Group6. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var usernameText: UITextField!
    @IBOutlet weak var displaynameText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var zipcodeText: UITextField!


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        backButton.backgroundColor = UIColor.clearColor()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onSignUp(sender: AnyObject) {
        var newUser = PFUser()
        newUser.username = usernameText.text
        newUser.password = passwordText.text
        newUser.email = emailText.text
        newUser["zipcode"] = zipcodeText.text
        newUser["screenName"] = displaynameText.text
        newUser.signUpInBackgroundWithBlock { (successed: Bool, error: NSError!) -> Void in
            
            if successed {
                self.dismissViewControllerAnimated(true, nil)
                
            }else{
                println("user sign up error:\(error)")
                UIAlertView(title: "sign up error", message: "\(error)", delegate: nil, cancelButtonTitle: "OK").show()
            }
            
        }
        

        
    }

    @IBAction func goBack(sender: AnyObject) {
            self.dismissViewControllerAnimated(true, nil)
    }

}
