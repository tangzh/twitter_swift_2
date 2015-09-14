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
            var tweets = Tweet.tweetsWithArray(response as! [NSDictionary])
            completion(tweets: tweets, err: nil)
            //                for tweet in tweets {
            //                    println("text: \(tweet.text) createdAt: \(tweet.createdAtString)")
            //                }
            
            }) { (operation: AFHTTPRequestOperation!, err: NSError!) -> Void in
                println("err getting tweets history")
                completion(tweets: nil, err: err)
        }
        
    }
    
    func openURL(url: NSURL) {
        
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: BDBOAuth1Credential(queryString: url.query), success: { (accessToken:BDBOAuth1Credential!) -> Void in
            println("get access token")
            
            TwitterClient.sharedInstance.requestSerializer.saveAccessToken(accessToken)
            
            // fetch the user info
            TwitterClient.sharedInstance.GET("1.1/account/verify_credentials.json", parameters: nil, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                var user = User(dic: response as! NSDictionary)
                User.currentUser = user
                self.loginCompletion?(user: user, err: nil)
            
                }, failure: { (operation: AFHTTPRequestOperation!, err: NSError!) -> Void in
                    println("err getting current usr")
                    self.loginCompletion?(user: nil, err: err)
            })
            
            // fetch the tweets history
            
            
            }, failure: { (err: NSError!) -> Void in
                println("failed to get access token")
                self.loginCompletion?(user: nil, err: err)
        })
    }
   
}
