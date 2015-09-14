//
//  ComposeTweetViewController.swift
//  Twitter_swift
//
//  Created by Tang Zhang on 9/14/15.
//  Copyright (c) 2015 Tang Zhang. All rights reserved.
//

import UIKit

class ComposeTweetViewController: UIViewController {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!    
    @IBOutlet weak var composeField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let user = User.currentUser {
            nameLabel.text = user.name ?? ""
            var screenName = user.screenname ?? ""
            screenNameLabel.text = "@\(screenName)"
            profileImageView.setImageWithURL(NSURL(string: user.profileImageUrl!))
            composeField.becomeFirstResponder()
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func onCancel(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func onTweet(sender: AnyObject) {
        Tweet.createTweet(composeField.text)
        dismissViewControllerAnimated(true, completion: nil)        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
