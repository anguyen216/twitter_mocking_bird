//
//  homeTableViewController.swift
//  Twitter
//
//  Created by Anh Nguyen on 3/4/21.
//  Copyright © 2021 Dan. All rights reserved.
//

import UIKit

class homeTableViewController: UITableViewController {

    
    var tweetArray = [NSDictionary]()
    var numberOfTweet: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadTweets()
    }
    
    func loadTweets() {
        let tweetsUrl = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        let myParams = ["count": 20]
        TwitterAPICaller.client?.getDictionariesRequest(url: tweetsUrl, parameters: myParams, success: { (tweets: [NSDictionary]) in
            self.tweetArray.removeAll()  // clean up tweet array before adding new goodies
            for tweet in tweets {
                self.tweetArray.append(tweet)
            }
            self.tableView.reloadData()
        }, failure: { (Error) in
            print("Could not retrieve tweet!")
        })
    }
    
    
    @IBAction func onLogoutButton(_ sender: Any) {
        TwitterAPICaller.client?.logout()
        self.dismiss(animated: true, completion: nil)
        UserDefaults.standard.set(false, forKey: "userLoggedIn")
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // get data for cell content
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath) as! tweetCell
        let user = self.tweetArray[indexPath.row]["user"] as! NSDictionary
        cell.usernameLabel.text = user["name"] as? String
        cell.usernameLabel.sizeToFit()
        cell.tweetContent.text = self.tweetArray[indexPath.row]["text"] as? String
        cell.tweetContent.sizeToFit()
        
        // set user profile pic
        let imageUrl = URL(string: (user["profile_image_url_https"] as? String)!)
        let data = try? Data(contentsOf: imageUrl!)
        if let imageData = data {
            cell.profileImageView.image = UIImage(data: imageData)
        }
        // customize image view of profile pic to be a circle
        cell.profileImageView.layer.masksToBounds = true
        cell.profileImageView.layer.cornerRadius = cell.profileImageView.bounds.width / 2
        
        // config custom cell - so the divider span across the entire screen :)
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        
        return cell
    }
    
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tweetArray.count
    }

}
