//
//  LoginHelper.swift
//  SeoulHotPle
//
//  Created by KimJingyu on 2017. 2. 17..
//  Copyright © 2017년 SeoulHotPle. All rights reserved.
//

import FirebaseAuth
import UIKit
import GoogleSignIn
import FirebaseDatabase

class Helper {
    //singleton
    static let helper = Helper()
    
    public func loginAnonymously() {
        print("login anonymously did tapped")
        //move to navigation CV
        //create a main storyboard instance
        
//        FIRAuth.auth()?.signIn(with: <#T##FIRAuthCredential#>, completion: <#T##FIRAuthResultCallback?##FIRAuthResultCallback?##(FIRUser?, Error?) -> Void#>)
        FIRAuth.auth()?.signInAnonymously() { (anonymousUser: FIRUser?, error) in
            if error == nil {
                print("FIRAUTH")
                let newUser = FIRDatabase.database().reference().child("users").child(anonymousUser!.uid)
                newUser.setValue(["displayname" : "anonymous", "id" : "\(anonymousUser!.uid)", "profileUrl" : ""])
                self.switchToNavigationViewController()
                
            } else {
                print(error!)
            }
        }
    }

    public func switchToNavigationViewController() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let navigationVC = storyboard.instantiateViewController(withIdentifier: "NavigationVC") as! UINavigationController
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = navigationVC
        
    }
}
