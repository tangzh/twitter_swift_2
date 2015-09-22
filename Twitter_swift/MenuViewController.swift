//
//  MenuViewController.swift
//  Twitter_swift
//
//  Created by Tang Zhang on 9/21/15.
//  Copyright (c) 2015 Tang Zhang. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var viewControllers: [UIViewController] = []
    var tweetsViewController: UINavigationController!
    var profileViewController: UINavigationController!
    var mentionsViewController: UINavigationController!
    
    var titles = ["Homeline", "My Profile", "My Mentions"]
    var hamburgerViewController: HamburgerMenuViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        println("load menu view")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 30
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        mentionsViewController = storyboard.instantiateViewControllerWithIdentifier("TweetsNavController") as! UINavigationController
        let mentionsVC = mentionsViewController.topViewController as! TweetsViewController
        mentionsVC.isMentionsView = true
        mentionsVC.title = "Mentions"
        
        tweetsViewController = storyboard.instantiateViewControllerWithIdentifier("TweetsNavController") as! UINavigationController
        
        profileViewController = storyboard.instantiateViewControllerWithIdentifier("TweetsNavController") as! UINavigationController
        profileViewController.title = "Profile"
        let profileVC = profileViewController.topViewController as! TweetsViewController
        profileVC.profileViewUser = User.currentUser
        profileVC.title = "My Profile"
        
        viewControllers.append(tweetsViewController)
        viewControllers.append(profileViewController)
        viewControllers.append(mentionsViewController)
        
        hamburgerViewController?.contentViewController = tweetsViewController
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MenuCell", forIndexPath: indexPath) as! MenuCell
        cell.menuNameLabel.text = titles[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if indexPath.row == 0 {
            println("chooose first")
            let navVC =  viewControllers[indexPath.row] as! UINavigationController
            let homelineVC = navVC.topViewController as! TweetsViewController
            homelineVC.profileViewUser = nil
            homelineVC.viewDidLoad()
        }
        hamburgerViewController?.contentViewController = viewControllers[indexPath.row]
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
