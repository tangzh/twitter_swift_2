//
//  TweetCell.swift
//  Twitter_swift
//
//  Created by Tang Zhang on 9/13/15.
//  Copyright (c) 2015 Tang Zhang. All rights reserved.
//

import UIKit

protocol TweetCellDelegate: class{
    func tweetCell(tweetCell: TweetCell)
    func updateTweet(tweetCell: TweetCell, didChangedTweet tweet: Tweet)
    func presentProfileView(tweetCell: TweetCell)
}

class TweetCell: UITableViewCell {
    
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var replyBtn: UIButton!
    @IBOutlet weak var retweetBtn: UIButton!
    @IBOutlet weak var favBtn: UIButton!
    
    var tweetCellDelegate: TweetCellDelegate?
    
    @IBAction func onReply(sender: AnyObject) {
        tweetCellDelegate?.tweetCell(self)
    }
    
    @IBAction func onRetweet(sender: AnyObject) {
        if let tweet = tweet {
            if tweet.hasRetweeted != nil && !tweet.hasRetweeted! {
                TwitterClient.sharedInstance.retweetTweet(tweet.idString, params: nil) { (tweet, err) -> Void in
                    if err == nil {
                        println("retweeted tweet ")
                        self.tweet!.hasRetweeted = true
                        self.tweetCellDelegate?.updateTweet(self, didChangedTweet: self.tweet!)
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
                        self.tweet! = tweet!
                        self.tweetCellDelegate?.updateTweet(self, didChangedTweet: tweet!)
                        
                    }else {
                        println("something wrong liking tweet : \(err)")
                    }
                }
            }
        }
        
    }
    
    @IBAction func onTapProfileImgae(sender: AnyObject) {
//        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
//        let navVC = storyboard.instantiateViewControllerWithIdentifier("TweetsNavController") as? UINavigationController
//        let vc = navVC?.topViewController as? TweetsViewController
//        vc?.profileViewUser = nil
//        presentViewController(navVC!, animated: true, completion: nil)
        tweetCellDelegate?.presentProfileView(self)        
    }
    var tweet: Tweet! {
        didSet {
            var user = tweet.user
            nameLabel.text = user?.name ?? ""
            var screenName = user?.screenname ?? ""
            screenNameLabel.text = "@\(screenName)"
            profileImage.setImageWithURL(NSURL(string: user!.profileImageUrl!))
            contentLabel.text = tweet!.text
            
            var formatter = NSDateFormatter()
            formatter.dateFormat = "MM/dd/yy"
            timeLabel.text = formatter.stringFromDate(tweet!.createdAt!)
            
            if (tweet.hasFaved != nil && tweet.hasFaved!) {
                favBtn.setImage(UIImage(named: "favorite_on.png"), forState: .Normal)
            }else {
                favBtn.setImage(UIImage(named: "favorite.png"), forState: .Normal)
            }

            if (tweet.hasRetweeted != nil && tweet.hasRetweeted!) {
                retweetBtn.setImage(UIImage(named: "retweet_on.png"), forState: .Normal)
            }else {
                retweetBtn.setImage(UIImage(named: "retweet.png"), forState: .Normal)
            }
            
        }
    }
        
    override func awakeFromNib() {
        super.awakeFromNib()
        screenNameLabel.preferredMaxLayoutWidth = screenNameLabel.layer.frame.width
        profileImage.layer.cornerRadius = 3
        profileImage.clipsToBounds = true

        
        if tweet != nil {
            
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        screenNameLabel.preferredMaxLayoutWidth = screenNameLabel.layer.frame.width
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
