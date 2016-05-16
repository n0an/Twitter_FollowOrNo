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
    
    var account: ACAccount?

    override func viewDidLoad() {
        super.viewDidLoad()

        print(account)
        
        getFollowingCount()
    }
    
    func getFollowingCount() {
        
        let verifyAccountURL = NSURL(string: "https://api.twitter.com/1.1/account/verify_credentials.json")
        
        let verifyAccountRequest = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: .GET, URL: verifyAccountURL, parameters: nil)
        
        verifyAccountRequest.account = account!
        
        verifyAccountRequest.performRequestWithHandler { (data: NSData!, response: NSHTTPURLResponse!, error: NSError!) in
            
            if error == nil {
                print("roll tide")
                
            } else {
                print("we got a problem")
            }
        }
        
        
    }

    

}
