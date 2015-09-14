//
//  TweetCell.swift
//  Twitter_swift
//
//  Created by Tang Zhang on 9/13/15.
//  Copyright (c) 2015 Tang Zhang. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {
    
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    @IBAction func onReply(sender: AnyObject) {
    }
    
    @IBAction func onRetweet(sender: AnyObject) {
    }
    
    @IBAction func onFav(sender: AnyObject) {
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
            
        }
    }
    
//    var user: User?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        screenNameLabel.preferredMaxLayoutWidth = screenNameLabel.layer.frame.width
        profileImage.layer.cornerRadius = 3
        profileImage.clipsToBounds = true

        
        if tweet != nil {
            
        }
        // Initialization code
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
