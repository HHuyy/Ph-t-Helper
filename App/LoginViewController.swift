//
//  ViewController.swift
//  App
//
//  Created by Đừng xóa on 9/5/18.
//  Copyright © 2018 Đừng xóa. All rights reserved.
//

import UIKit
import GoogleSignIn

class LoginViewController: UIViewController, GIDSignInUIDelegate, GIDSignInDelegate {
    @IBOutlet weak var continueButton: UIButton!
    
    @IBOutlet weak var logoutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        continueButton.isHidden = true
        logoutButton.isHidden = true
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error != nil {
            print(error ?? "google error")
            return
        }
        if GIDSignIn.sharedInstance().currentUser != nil {
            continueButton.isHidden = false
            logoutButton.isHidden = false
            UserDefaults.standard.set(user.profile.email, forKey: "email")

            UserDefaults.standard.set(user.profile.imageURL(withDimension: 120), forKey: "imageURL")
            print(user.profile.imageURL(withDimension: 120))
            
        }
    }

    @IBAction func logoutButton(_ sender: UIButton) {
        GIDSignIn.sharedInstance().signOut()
        UserDefaults.standard.removeObject(forKey: "email")
        UserDefaults.standard.removeObject(forKey: "imageURL")
        continueButton.isHidden = true
        logoutButton.isHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

