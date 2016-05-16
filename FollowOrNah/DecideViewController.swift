//
//  DecideViewController.swift
//  FollowOrNah
//
//  Created by Anton Novoselov on 16/05/16.
//  Copyright © 2016 Anton Novoselov. All rights reserved.
//

import UIKit
import Accounts
import Social

class DecideViewController: UIViewController {
    @IBOutlet weak var friendLabel: UILabel!
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    
    var account: ACAccount?
    var twitterUsers = [TwitterUser]()

    override func viewDidLoad() {
        super.viewDidLoad()

        print(account)
        
        getFollowingCount()
        getFriends()
    }
    
    
    func showTopUser() {
        let user = twitterUsers.first!
        
        userNameLabel.text = user.name
        
        NSURLSession.sharedSession().dataTaskWithURL(NSURL(string: user.imageUrl)!) { (data: NSData?, response: NSURLResponse?, error: NSError?) in
            
            
            dispatch_async(dispatch_get_main_queue(), {
                if let unwrpData = data {
                    let image = UIImage(data: unwrpData)
                    
                    self.imageView.image = image
                }
                
            })
            
            
        }.resume()
        
    }
    
    
    
    
    func getFollowingCount() {
        
        let verifyAccountURL = NSURL(string: "https://api.twitter.com/1.1/account/verify_credentials.json")
        
        let verifyAccountRequest = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: .GET, URL: verifyAccountURL, parameters: nil)
        
        verifyAccountRequest.account = account!
        
        verifyAccountRequest.performRequestWithHandler { (data: NSData!, response: NSHTTPURLResponse!, error: NSError!) in
            
            if error == nil {
                print("roll tide")
                
                // !!!IMPORTANT!!!
                // NSJSONSerialization use example
                do {
                    let responseJSONDictionary = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableLeaves) as! [String: AnyObject]
//                    print(responseJSONDictionary)
                    
                    let friendCount = responseJSONDictionary["friends_count"] as! Int
                    print(friendCount)
                    
                    self.friendLabel.text = "You are following \(friendCount) accounts"
                    
                } catch {
                    
                }
                
                
            } else {
                print("we got a problem")
            }
        }
        
        
    }
    
    

    
    func getFriends() {
        let verifyAccountURL = NSURL(string: "https://api.twitter.com/1.1/friends/ids.json")
        
        let verifyAccountRequest = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: .GET, URL: verifyAccountURL, parameters: nil)
        
        verifyAccountRequest.account = account!
        
        verifyAccountRequest.performRequestWithHandler { (data: NSData!, response: NSHTTPURLResponse!, error: NSError!) in
            
            if error == nil {
                
                do {
                    let responseJSONDictionary = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableLeaves) as! [String: AnyObject]
//                    print(responseJSONDictionary)
                    
                    let theIds = responseJSONDictionary["ids"] as! [Int]
                    self.getHydratedUsers(theIds)
                    
                    
                } catch {
                    
                }
                
                
            } else {
                print("we got a problem")
            }
        }

    }
    
    
    
    
    func getHydratedUsers(twitterIds: [Int]) {
        
        print("let's hydrate")
        
        var hunderedIds = [String]()
        var count = 1
        
        for twitId in twitterIds {
            
            if count <= 100 {
                hunderedIds.append("\(twitId)")
            } else {
                break
            }
            
            count += 1
        }
        
        
        
        let verifyAccountURL = NSURL(string: "https://api.twitter.com/1.1/users/lookup.json")
        
        let verifyAccountRequest = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: .GET, URL: verifyAccountURL, parameters: ["user_id": hunderedIds])
        
        verifyAccountRequest.account = account!
        
        verifyAccountRequest.performRequestWithHandler { (data: NSData!, response: NSHTTPURLResponse!, error: NSError!) in
            
            if error == nil {
                
                do {
                    let responseJSONArray = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableLeaves) as! [AnyObject]
                    print(responseJSONArray)
                    
                    
                    for user in responseJSONArray {
                        
                        let userDictionary = user as! [String : AnyObject]
                        
                        let twitterUser = TwitterUser()
                        
                        twitterUser.name = userDictionary["name"] as! String
                        
                        twitterUser.imageUrl = userDictionary["profile_image_url_https"] as! String
                        
                        twitterUser.userId = userDictionary["id"] as! Int
                            
                        self.twitterUsers.append(twitterUser)
                        
                    }
                    
                    dispatch_async(dispatch_get_main_queue(), { 
                        self.showTopUser()

                    })
                    
                    
                    
                } catch {
                    
                }
                
                
            } else {
                print("we got a problem")
            }
        }
        
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
    @IBAction func unfollowTapped(sender: AnyObject) {
        
        let user = twitterUsers.first
        
        let verifyAccountURL = NSURL(string: "https://api.twitter.com/1.1/friendships/destroy.json")
        
        let verifyAccountRequest = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: .POST, URL: verifyAccountURL, parameters: ["user_id": "\(user!.userId)"])
        
        verifyAccountRequest.account = account!
        
        verifyAccountRequest.performRequestWithHandler { (data: NSData!, response: NSHTTPURLResponse!, error: NSError!) in
            
            if error == nil {
                print("roll tide")
                
                // !!!IMPORTANT!!!
                // NSJSONSerialization use example
                do {
                    let responseJSONDictionary = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableLeaves) as! [String: AnyObject]
                    
                    print(responseJSONDictionary)
                    
                    
                } catch {
                    
                }
                
                
            } else {
                print("we got a problem")
            }
        }
        
        twitterUsers.removeAtIndex(0)
        showTopUser()
        
    }
    
    
    @IBAction func keepFollowingTapped(sender: AnyObject) {
        
        twitterUsers.removeAtIndex(0)
        showTopUser()
        
    }
    

}

















