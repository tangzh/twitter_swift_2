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
    
    @IBOutlet weak var retweetBtn: UIButton!
    
    @IBOutlet weak var favBtn: UIButton!
    var tweet: Tweet?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadTweetData()
    }
    
    func loadTweetData() {
        if let tweet = tweet {
            var user = tweet.user
            nameLabel.text = user?.name ?? ""
            var screenName = user?.screenname ?? ""
            screenNameLabel.text = "@\(screenName)"
            profileImageView.setImageWithURL(NSURL(string: user!.profileImageUrl!))
            contentLabel.text = tweet.text
            retweetsCountLabel.text = "\(tweet.retweetCount!)"
            favsCountLabel.text = "\(tweet.favCount!)"
            
            var formatter = NSDateFormatter()
            formatter.dateFormat = "MM/dd/yyyy HH:mm"
            timeLabel.text = formatter.stringFromDate(tweet.createdAt!)
            
            if (tweet.hasFaved != nil) {
                if tweet.hasFaved! {
                    favBtn.setImage(UIImage(named: "favorite_on.png"), forState: .Normal)
                }
            }
            
            if (tweet.hasRetweeted != nil) {
                if tweet.hasRetweeted! {
                    retweetBtn.setImage(UIImage(named: "retweet_on.png"), forState: .Normal)
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func onReply(sender: AnyObject) {
        
    }
    
    @IBAction func onRetweet(sender: AnyObject) {
        if let tweet = tweet {
            if tweet.hasRetweeted != nil && !tweet.hasRetweeted! {
                TwitterClient.sharedInstance.retweetTweet(tweet.idString, params: nil) { (tweet, err) -> Void in
                    if err == nil {
                        println("retweeted tweet ")
                        self.tweet!.hasRetweeted = true
                        self.tweet!.retweetCount! = self.tweet!.retweetCount! + 1
                        self.loadTweetData()
                    }else {
                        println("something wrong retweeting tweet : \(err)")
                    }
                }
            }
        }
    }
    
    @IBAction func onFav(sender: AnyObject) {
        if let tweet = tweet {
            if tweet.hasFaved != nil && !tweet.hasFaved! {
                TwitterClient.sharedInstance.likeTweet(tweet.idString, params: nil) { (tweet, err) -> Void in
                    if err == nil {
                        println("liked tweet ")
                        self.tweet!.hasFaved = true
                        self.tweet!.favCount! = self.tweet!.favCount! + 1
                        self.loadTweetData()
                    }else {
                        println("something wrong liking tweet : \(err)")
                    }
                }
            }
        }
    }
    
    


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            if identifier == "replyTweet" {
                let navc = segue.destinationViewController as? UINavigationController
                let vc = navc?.topViewController as? ReplyTweetViewController
                vc?.repliedTweet = tweet
            }
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }


}
