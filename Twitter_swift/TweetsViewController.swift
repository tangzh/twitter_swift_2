//
//  TweetsViewController.swift
//  Twitter_swift
//
//  Created by Tang Zhang on 9/13/15.
//  Copyright (c) 2015 Tang Zhang. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, TweetCellDelegate, ComposeTweetViewControllerDelegate{
    var tweets: [Tweet]?
    var refreshControl: UIRefreshControl!
    var profileViewUser: User?
    
    @IBOutlet weak var backgroundImage: UIImageView!   
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var tweetsNum: UILabel!    
    @IBOutlet weak var followingNum: UILabel!
    @IBOutlet weak var followersNum: UILabel!
    
    var tableViewOriginalCenter: CGPoint!
    var viewSize: CGSize!

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerView: UIView!
    
    func refresh(sender:AnyObject) {
        if profileViewUser == nil {
            TwitterClient.sharedInstance.homeTimelineWithParams(nil, completion: { (tweets, err) -> Void in
                if err == nil {
                    self.tweets = tweets
                    self.tableView.reloadData()
                }else {
                    println("err getting tweets")
                }
                self.refreshControl.endRefreshing()
            })
        }else {
            TwitterClient.sharedInstance.userTimeline(["screen_name": profileViewUser!.screenname!], completion: { (tweets, err) -> Void in
                if err == nil {
                    self.tweets = tweets
                    self.tableView.reloadData()
                }else {
                    println("err getting tweets")
                }
                self.refreshControl.endRefreshing()
            })
        }
        
        
    }
    
    func loadHeaderView() {
        if let user = profileViewUser {
            headerView.frame = CGRectMake(0 , 0, self.view.frame.width, 250)
            headerView.alpha = 1
            nameLabel.text = user.name ?? ""
            followingNum.text = "\(user.followingNum!)"
            followersNum.text = "\(user.followersNum!)"
            tweetsNum.text = "\(user.tweetsNum!)"
            var screenName = user.screenname ?? ""
            screenNameLabel.text = "@\(screenName)"
            profileImage.setImageWithURL(NSURL(string: user.profileImageUrl!))
            backgroundImage.setImageWithURL(NSURL(string: user.backgroundImageUrl!))
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(refreshControl)
        refresh(self)

        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        
        if profileViewUser != nil {
            loadHeaderView()
        }else {
            headerView.frame = CGRectMake(0 , 0, self.view.frame.width, 0)
            headerView.alpha = 0
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func logout(sender: AnyObject) {
        User.currentUser?.logout()
    }
    
    @IBAction func onPanned(sender: UIPanGestureRecognizer) {
        let panGestureRecognizer = sender
        let translation = sender.translationInView(tableView)
        var point = panGestureRecognizer.locationInView(view)
        var velocity = panGestureRecognizer.velocityInView(view)
        
        if panGestureRecognizer.state == UIGestureRecognizerState.Began {
            tableViewOriginalCenter = tableView.center
        } else if panGestureRecognizer.state == UIGestureRecognizerState.Changed {
            tableView.center = CGPoint(x: tableViewOriginalCenter.x + translation.x, y: tableViewOriginalCenter.y)
        } else if panGestureRecognizer.state == UIGestureRecognizerState.Ended {
            if velocity.x > 0 { // it is moving right
                tableView.center = CGPoint(x: tableViewOriginalCenter.x + view.bounds.width/2 , y: tableViewOriginalCenter.y)
            }else {
                tableView.center = CGPoint(x: tableViewOriginalCenter.x - view.bounds.width/2, y: tableViewOriginalCenter.y)
            }
        }
        
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TweetCell") as! TweetCell
        cell.tweet = tweets![indexPath.row]
        cell.tweetCellDelegate = self
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated:true)
    }
    
    
    // MARK: - Delegate
    
    func tweetCell(tweetCell: TweetCell) {
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let navVC = storyboard.instantiateViewControllerWithIdentifier("ReplyTweetNavController") as? UINavigationController
        let vc = navVC?.topViewController as? ReplyTweetViewController
        vc?.repliedTweet = tweetCell.tweet
        presentViewController(navVC!, animated: true, completion: nil)
    }
    
    func updateTweet(tweetCell: TweetCell, didChangedTweet tweet: Tweet) {
        let indexPath = tableView.indexPathForCell(tweetCell)
        tweets![indexPath!.row] = tweet
        tableView.reloadData()
    }
    
    func composeTweetViewControllerNewTweet(vc: ComposeTweetViewController, newTweet tweet: Tweet) {
        tweets?.insert(tweet, atIndex: 0)
        tableView.reloadData()
    }
    
    func presentProfileView(tweetCell: TweetCell) {
        println("should present profile view")
        profileViewUser = tweetCell.tweet.user
        loadHeaderView()
        refresh(self)

    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        let vc = segue.destinationViewController as? TweetDetailViewController
        if vc != nil {
            var indexPath = tableView.indexPathForCell(sender as! TweetCell)!
            println("get tweet")
            vc!.tweet = tweets![indexPath.row]
        }
        
        if segue.identifier != nil {
            if let id = segue.identifier {
                let navc = segue.destinationViewController as? UINavigationController
                let vc = navc?.topViewController as? ComposeTweetViewController
                if let vc = vc {
                    vc.delegate = self
                }
            }
        }
    }


}
