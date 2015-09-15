//
//  ReplyTweetViewController.swift
//  Twitter_swift
//
//  Created by Tang Zhang on 9/14/15.
//  Copyright (c) 2015 Tang Zhang. All rights reserved.
//

import UIKit

class ReplyTweetViewController: UIViewController {
    
    var repliedTweet: Tweet?

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var replyTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if repliedTweet != nil {
            nameLabel.text = repliedTweet?.user?.name ?? ""
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onDiscard(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func onReply(sender: AnyObject) {
        if let repliedTweet = repliedTweet {
            TwitterClient.sharedInstance.replyTweet(["status": replyTextField.text, "in_reply_to_status_id": "\(repliedTweet.idString!)"], completion: { (tweet, err) -> Void in
                if err == nil {
                    println("replied tweet")
                }else {
                    println("err replying tweet")
                }
            })
        }
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
