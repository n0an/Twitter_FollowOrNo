//
//  SignInViewController.swift
//  FollowOrNah
//
//  Created by Anton Novoselov on 16/05/16.
//  Copyright © 2016 Anton Novoselov. All rights reserved.
//

import UIKit
import Accounts
import Social


class SignInViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    // !!!IMPORTANT!!!
    // TWITTER API
    @IBAction func signInTapped(sender: AnyObject) {
        
        let account = ACAccountStore()
        let accountTypeTwitter = account.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)
        
        account.requestAccessToAccountsWithType(accountTypeTwitter, options: nil) { (granted: Bool, error: NSError!) in
            
            if granted {
                
                let allAcounts = account.accountsWithAccountType(accountTypeTwitter)
                if allAcounts.count <= 0 {
                    print("no accounts")
                } else if allAcounts.count == 1 {
                    print("they only have one, let's use it")
                } else {
                    print("they have more than one. let's ask which one they want")
                    
                    dispatch_async(dispatch_get_main_queue(), { 
                        self.performSegueWithIdentifier("chooseAccountSegue", sender: allAcounts)
                    })
                    
                }
                
                
            } else {
                print("it didn't worked")
            }
            
        }
        
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "chooseAccountSegue" {
            let selectVC = segue.destinationViewController as! SelectAccountViewController
            selectVC.accounts = sender as! [ACAccount]
        }
    }
    
    func moveToViewControllerWithAccount(account: ACAccount) {
        print("You made it!")
    }
    
    

}










