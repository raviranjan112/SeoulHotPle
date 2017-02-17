//
//  ViewController.swift
//  SeoulHotPle
//
//  Created by KimJingyu on 2017. 2. 17..
//  Copyright © 2017년 SeoulHotPle. All rights reserved.
//

import UIKit
import GoogleSignIn
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var btnAnonymously: UIButton!
    
    //익명로그인
    @IBAction func loginAnonymouslyDidTapped(_ sender: Any) {
        print("login anonymously did tapped")
        Helper.helper.loginAnonymously()
    }
    
    //구글로그인
    @IBAction func googleLoginDidTapped(_ sender: Any) {
        print("login google did tapped")
        GIDSignIn.sharedInstance().signIn()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //set border color
        btnAnonymously.layer.borderWidth = 2.0
        btnAnonymously.layer.borderColor = UIColor.white.cgColor
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        FIRAuth.auth()?.addStateDidChangeListener({ (auth: FIRAuth, user: FIRUser?) in
            if user != nil {
                print(user)
                Helper.helper.switchToNavigationViewController()
            }
            else {
                print("Unauthorized")
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

