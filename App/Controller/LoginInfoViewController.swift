//
//  LoginInfoViewController.swift
//  App
//
//  Created by Đừng xóa on 9/5/18.
//  Copyright © 2018 Đừng xóa. All rights reserved.
//

import UIKit
import GoogleSignIn

class LoginInfoViewController: UIViewController, GIDSignInUIDelegate, GIDSignInDelegate {
    @IBOutlet weak var avarImage: UIImageView!
    @IBOutlet weak var emailLabel: UILabel!
    var dispatchWorkItem: DispatchWorkItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        if let email = UserDefaults.standard.object(forKey: "email") {
            emailLabel.text = email as? String
        }

        if let imageURL = UserDefaults.standard.url(forKey: "imageURL") {
            getImage(from: imageURL, completedHandler: { (image) in
                self.avarImage.image = image
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func logoutButton(_ sender: UIButton) {
        GIDSignIn.sharedInstance().signOut()
        UserDefaults.standard.removeObject(forKey: "email")
        UserDefaults.standard.removeObject(forKey: "imageURL")
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if GIDSignIn.sharedInstance().currentUser != nil {
            if error != nil {
                print(error ?? "google error")
                return
            }
        }
    }
    
    func getImage(from url: URL, completedHandler: @escaping (UIImage?) -> Void) {
        var image: UIImage?
        dispatchWorkItem = DispatchWorkItem(block: {
            if let data = try? Data(contentsOf: url) {
                image = UIImage(data: data)
            }
        })
        DispatchQueue.global().async {
            self.dispatchWorkItem?.perform()
            DispatchQueue.main.async {
                completedHandler(image)
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
