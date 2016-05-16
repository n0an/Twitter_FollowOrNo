//
//  SelectAccountViewController.swift
//  FollowOrNah
//
//  Created by Anton Novoselov on 16/05/16.
//  Copyright © 2016 Anton Novoselov. All rights reserved.
//

import UIKit
import Accounts
import Social

class SelectAccountViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    var accounts = [ACAccount]()

    override func viewDidLoad() {
        super.viewDidLoad()

        print(accounts)
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accounts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        
        let account = accounts[indexPath.row]
        
        cell.textLabel?.text = account.username
        
        return cell
    }

    // !!!IMPORTANT!!!
    // DISMISS MODAL VIEW CONTROLLER AND PASS PARAMETER
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let account = accounts[indexPath.row]

        let navigationVC = presentingViewController as! UINavigationController
        
        let signInVC = navigationVC.viewControllers[0] as! SignInViewController
        
        
        
        self.dismissViewControllerAnimated(true) { 
            signInVC.moveToViewControllerWithAccount(account)
        }
    }
    
    
    
   

}















