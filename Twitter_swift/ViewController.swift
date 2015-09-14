//
//  ViewController.swift
//  Twitter_swift
//
//  Created by Tang Zhang on 9/13/15.
//  Copyright (c) 2015 Tang Zhang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func onLogin(sender: AnyObject) {
        
        TwitterClient.sharedInstance.loginWithCompletion(){
            (user: User?, err: NSError?) in
            if (user != nil) {
                // perform segue
                self.performSegueWithIdentifier("loginSegue", sender: self)
            } else {
                // display err
            }
        }
        
    }

}

