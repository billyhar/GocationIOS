//
//  HomeViewController.swift
//  Gocation
//
//  Created by Billy Harris on 17/04/17.
//  Copyright © 2017 Billy Harris. All rights reserved.
//

import UIKit
import FirebaseAuth
import FBSDKCoreKit
import MapKit

class HomeViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var userName: UILabel!

    @IBOutlet weak var trailingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var ProfilePic: UIImageView!
    
    @IBOutlet weak var mapView: MKMapView!
  
    
    
    @IBOutlet weak var table: UITableView!
    
    
    @IBAction func showMenu(_ sender: Any) {
    
    leadingConstraint.constant = 100
    trailingConstraint.constant = -100
        
    
    }
    
    
    
    @IBAction func didTapLogout(_ sender: UIButton) {
        
        //sigining out of the firbease app
        let firebaseAuth = FIRAuth.auth()
        do {
            try firebaseAuth?.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
        
        
        //sigining out of the fb app
        FBSDKAccessToken.setCurrent(nil)
        
        
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController: UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "LoginView")
        
        self.present(viewController, animated: true, completion: nil)
        
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        //Map Pin adding
        addPin()
        focusMapView()
        
        self.ProfilePic.layer.cornerRadius = self.ProfilePic.frame.size.width/2
        
        self.ProfilePic.clipsToBounds = true
        
        
       
        

        
        let user = FIRAuth.auth()?.currentUser
        if let user = user {
            let name = user.displayName
            _ = user.uid
            _ = user.email
            let photoURL = user.photoURL
           
            

            self.userName.text = name
            let data = NSData(contentsOf: photoURL!)
            self.ProfilePic.image = UIImage(data: data! as Data)
            
            
            
        }else{
            
            
            
        }
        

        
        
            
    
    }
    
    
    //Map Pin
    
    func addPin() {
        let annotation = MKPointAnnotation()
        let centerCoordinate = CLLocationCoordinate2D(latitude: -41.296115, longitude:174.775305)
        annotation.coordinate = centerCoordinate
        annotation.title = "Beacon 1 - Main Stage"
        mapView.addAnnotation(annotation)
    }

    
    func focusMapView() {
        let mapCenter = CLLocationCoordinate2DMake(-41.296115, 174.775305)
        let span = MKCoordinateSpanMake(0.1, 0.1)
        let region = MKCoordinateRegionMake(mapCenter, span)
        mapView.region = region
    }
    


}
