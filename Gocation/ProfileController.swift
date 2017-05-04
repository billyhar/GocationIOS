//
//  ProfileController.swift
//  Gocation
//
//  Created by Billy Harris on 30/04/17.
//  Copyright © 2017 Billy Harris. All rights reserved.
//

import UIKit
import FirebaseAuth
import FBSDKCoreKit
import UserNotifications
import NotificationCenter

class ProfileController: UIViewController {
    
    
    @IBOutlet weak var ProfilePic: UIImageView!
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var id: UILabel!
    
    @IBOutlet weak var userEmail: UILabel!

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        
        self.ProfilePic.layer.cornerRadius = self.ProfilePic.frame.size.width/2
        
        self.ProfilePic.clipsToBounds = true
        
        
        
        
        
        let user = FIRAuth.auth()?.currentUser
        if let user = user {
            let name = user.displayName
            let userID = user.uid
            let emailAddress = user.email
            let photoURL = user.photoURL
            
            
            self.userEmail.text = emailAddress
            self.userName.text = name
            self.id.text = userID
            let data = NSData(contentsOf: photoURL!)
            self.ProfilePic.image = UIImage(data: data! as Data)
            
            
            
        }else{
            
            
            
        }


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    let center = UNUserNotificationCenter.current()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        center.getPendingNotificationRequests { (notifications) in
            print("Count: \(notifications.count)")
            for item in notifications {
                print(item.content)
            }
        }
    }
    
    
    

}
