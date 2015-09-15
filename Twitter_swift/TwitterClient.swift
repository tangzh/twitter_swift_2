//
//  TwitterClient.swift
//  Twitter_swift
//
//  Created by Tang Zhang on 9/13/15.
//  Copyright (c) 2015 Tang Zhang. All rights reserved.
//

import UIKit

let twitterConsumerKey = "oZgMBh4PFo8azYXKMowyKVMLr"
let twitterConsumerSecret =  "ZoE4sPhB2eBK1WHZ3Z3dgbvjDb6PQoLPvh2YVtunf7dq7rrkdi"
let twitterBaseUrl = NSURL(string: "https://api.twitter.com")

class TwitterClient: BDBOAuth1RequestOperationManager {
    
    var loginCompletion: ((user: User?, err: NSError?) -> Void)?
    
    class var sharedInstance: TwitterClient {
        struct Static {
            static let instance = TwitterClient(baseURL: twitterBaseUrl, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)
        }
        
        return Static.instance
    }
    
    func loginWithCompletion(completion: (user: User?, err: NSError?) -> Void) {
        loginCompletion = completion
        
        // fetch request token and redirect to auth page
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        TwitterClient.sharedInstance.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "cptwitterdemo://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) -> Void in
            println("get the request token")
            var authURL = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")
            UIApplication.sharedApplication().openURL(authURL!)
            
            }) { (err: NSError!) -> Void in
                println("request token err")
                self.loginCompletion?(user: nil, err: err)
        }
    }
    
    func homeTimelineWithParams(params: NSDictionary?, completion: (tweets: [Tweet]?, err: NSError?)-> Void) {
        GET("1.1/statuses/home_timeline.json", parameters: params, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
//            println("\(response)")
            var tweets = Tweet.tweetsWithArray(response as! [NSDictionary])
            completion(tweets: tweets, err: nil)
            }) { (operation: AFHTTPRequestOperation!, err: NSError!) -> Void in
                println("err getting tweets history \(err)")
                completion(tweets: nil, err: err)
        }
        
    }
    
    func createTweet(params: NSDictionary?, completion: (tweet: Tweet?, err: NSError?)-> Void) {
        POST("1.1/statuses/update.json", parameters: params, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            var tweet = Tweet(dic: response as! NSDictionary)
            completion(tweet: tweet, err: nil)
            }) { (operation: AFHTTPRequestOperation!, err: NSError!) -> Void in
            completion(tweet: nil, err: err)
        }
    }
    
    func replyTweet(params: NSDictionary?, completion: (tweet: Tweet?, err: NSError?)-> Void) {
        POST("1.1/statuses/update.json", parameters: params, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            var tweet = Tweet(dic: response as! NSDictionary)
            completion(tweet: tweet, err: nil)
            }) { (operation: AFHTTPRequestOperation!, err: NSError!) -> Void in
                println("err replying tweet \(err)")
                completion(tweet: nil, err: err)
        }
    }
    
    func likeTweet(likedTweetId: String?, params: NSDictionary?, completion: (tweet: Tweet?, err: NSError?)-> Void) {
        POST("1.1/favorites/create.json?id=\(likedTweetId!)", parameters: params, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            var tweet = Tweet(dic: response as! NSDictionary)
            completion(tweet: tweet, err: nil)
            }) { (operation: AFHTTPRequestOperation!, err: NSError!) -> Void in
                println("err liking tweet \(err)")
                completion(tweet: nil, err: err)
        }
    }
    
    func retweetTweet(retweetedTweetId: String?, params: NSDictionary?, completion: (tweet: Tweet?, err: NSError?)-> Void) {
        POST("1.1/statuses/retweet/\(retweetedTweetId!).json", parameters: params, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            var tweet = Tweet(dic: response as! NSDictionary)
            completion(tweet: tweet, err: nil)
            }) { (operation: AFHTTPRequestOperation!, err: NSError!) -> Void in
                println("err retweeting tweet \(err)")
                completion(tweet: nil, err: err)
        }
    }
    
    func openURL(url: NSURL) {
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: BDBOAuth1Credential(queryString: url.query), success: { (accessToken:BDBOAuth1Credential!) -> Void in
            println("get access token")
            
            TwitterClient.sharedInstance.requestSerializer.saveAccessToken(accessToken)
            
            // fetch the user info
            TwitterClient.sharedInstance.GET("1.1/account/verify_credentials.json", parameters: nil, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                println("get user \(response)")
                var user = User(dic: response as! NSDictionary)
                User.currentUser = user
                self.loginCompletion?(user: user, err: nil)
            
                }, failure: { (operation: AFHTTPRequestOperation!, err: NSError!) -> Void in
                    println("err getting current usr")
                    self.loginCompletion?(user: nil, err: err)
            })
            
            
            }, failure: { (err: NSError!) -> Void in
                println("failed to get access token")
                self.loginCompletion?(user: nil, err: err)
        })
    }
   
}
