//
//  ViewController.swift
//  Gocation
//
//  Created by Billy Harris on 14/04/17.
//  Copyright © 2017 Billy Harris. All rights reserved.
//

import UIKit
import CoreLocation
import FBSDKLoginKit
import FirebaseAuth

class ViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    
    var loginButton: FBSDKLoginButton = FBSDKLoginButton()
    
    @IBOutlet weak var aivLoadingSpinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        FIRAuth.auth()?.addStateDidChangeListener() { (auth, user) in
            if user != nil {
                
                //move user to the homescreen
                let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let homeViewController: UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "HomeView")
                
                self.present(homeViewController, animated: true, completion: nil)
                
            } else{
                
                
                //        FB LOGIN BUTTON
//                let loginButton = FBSDKLoginButton()
                self.loginButton.frame = CGRect(x: 16, y: 300, width: self.view.frame.width - 42, height: 42)
                self.loginButton.readPermissions = ["email", "public_profile"]
                self.loginButton.delegate = self
                self.view.addSubview(self.loginButton)
        
                
                self.loginButton.isHidden = false
                
                
                
                
            }
        
            
            
            
        }
        
        
        

//        //Custom FB Button
//        
//        let customFBButton = UIButton(type: .system)
//        customFBButton.backgroundColor = .blue
//        customFBButton.frame = CGRect(x: 16, y: 116, width: view.frame.width - 32, height: 32)
//        customFBButton.setTitle("Login With Facebook", for: .normal)
//        customFBButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
//        view.addSubview(customFBButton)
//        customFBButton.setTitleColor(.white, for: .normal)
//        
//        
//        customFBButton.addTarget(self, action: #selector(handleCustomFBLogin), for: .touchUpInside)

        
    
        
        
        
       
    }
    
    
    func handleCustomFBLogin() {
        FBSDKLoginManager().logIn(withReadPermissions: ["email", "public_profile"], from: self) { (result, err) in
            if err != nil {
                print("FB Login Failed", err!)
                return
            }
            
                self.showEmailAddress()
//            print(result?.token.tokenString)
        }
        
        
    }

    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        
        print("You are successfully logged out")
        
        
        
        
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
    
        
        self.loginButton.isHidden = true
        
        aivLoadingSpinner.startAnimating()
        
        if error != nil {
            
            print(error)
            return
            
        }
        
        
        
        if(error != nil)
        {
            //handle errors here
            self.loginButton.isHidden = false
            aivLoadingSpinner.stopAnimating()
        }
        else if(result.isCancelled) {
         
            self.loginButton.isHidden = false
            aivLoadingSpinner.stopAnimating()
        }
        else{
        
        
        showEmailAddress()
            
            
        
        let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
        
        _ = FIRAuth.auth()?.currentUser
        FIRAuth.auth()?.signIn(with: credential) { (user, error) in
            // ...
            if error != nil {
                // ...
                return
            }
            
            
            
                
            
            }
            
          
        
            
        }

    }
    
    
    func showEmailAddress(){
        print("Successfully logged in with Facebook")
        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "id, name, email" ]).start { (connection, result, err) in
            
            if err != nil{
                
                print("Failed to get data", err)
                return
            }
            
            
            print(result)
            
            
            
        }
        
        
    }
    
    
    
    
    
    

}

