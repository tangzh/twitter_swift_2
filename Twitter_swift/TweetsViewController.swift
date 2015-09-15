//
//  TweetsViewController.swift
//  Twitter_swift
//
//  Created by Tang Zhang on 9/13/15.
//  Copyright (c) 2015 Tang Zhang. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var tweets: [Tweet]?
    var refreshControl: UIRefreshControl!

    @IBOutlet weak var tableView: UITableView!
    
    func refresh(sender:AnyObject) {
        TwitterClient.sharedInstance.homeTimelineWithParams(nil, completion: { (tweets, err) -> Void in
            if err == nil {
                self.tweets = tweets
                self.tableView.reloadData()
            }else {
                println("err getting tweets")
            }
            self.refreshControl.endRefreshing()
        })
        
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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func logout(sender: AnyObject) {
        User.currentUser?.logout()
    }
    
    @IBAction func onLogout(sender: AnyObject) {
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TweetCell") as! TweetCell
        cell.tweet = tweets![indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated:true)
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
            println("\(segue.identifier)")
            println("\(sender?.superview)")
            
        }
        
        
//        if segue.identifier != nil {
//            if segue.identifier! == "composeTweet" {
//                if let vc = segue.destinationViewController as? ComposeTweetViewController {
////                    vc.tweet
//                }
//            
//            }
//        }
    }


}
