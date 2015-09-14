//
//  Tweet.swift
//  Twitter_swift
//
//  Created by Tang Zhang on 9/13/15.
//  Copyright (c) 2015 Tang Zhang. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    var user: User?
    var text: String?
    var createdAtString: String?
    var createdAt: NSDate?
    
    var retweetCount: Int?
    var favCount: Int?
    var hasRetweeted: Bool?
    var hasFaved: Bool?
    
    init(dic: NSDictionary) {
        user = User(dic: dic["user"] as! NSDictionary)
        text = dic["text"] as? String
        createdAtString = dic["created_at"] as? String
        retweetCount = dic["retweet_count"] as? Int
        favCount = dic["favorite_count"] as? Int
        hasRetweeted = dic["retweeted"] as? Bool
        hasFaved = dic["favorited"] as? Bool
        
        var formatter = NSDateFormatter()
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        createdAt = formatter.dateFromString(createdAtString!)
        
    }
    
    class func tweetsWithArray(array: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        for dic in array {
            tweets.append(Tweet(dic: dic))
        }
        return tweets
    }
    
    class func createTweet(status: NSString) {
        TwitterClient.sharedInstance.createTweet(status, params: nil, completion: { (tweet, err) -> Void in
            if err == nil {
                println("created tweet ")
            }else {
                println("something wrong creating tweet : \(err)")
            }
        })
    }
    
}
