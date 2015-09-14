//
//  TweetDetailViewController.swift
//  Twitter_swift
//
//  Created by Tang Zhang on 9/13/15.
//  Copyright (c) 2015 Tang Zhang. All rights reserved.
//

import UIKit

class TweetDetailViewController: UIViewController {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var retweetsCountLabel: UILabel!
    @IBOutlet weak var favsCountLabel: UILabel!
    
    var tweet: Tweet?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let tweet = tweet {
            var user = tweet.user
            nameLabel.text = user?.name ?? ""
            var screenName = user?.screenname ?? ""
            screenNameLabel.text = "@\(screenName)"
            profileImageView.setImageWithURL(NSURL(string: user!.profileImageUrl!))
            contentLabel.text = tweet.text
            
            var formatter = NSDateFormatter()
            formatter.dateFormat = "MM/dd/yy HH:mm"
            timeLabel.text = formatter.stringFromDate(tweet.createdAt!)
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
