//
//  ChatVC.swift
//  SeoulHotPle
//
//  Created by KimJingyu on 2017. 2. 17..
//  Copyright © 2017년 SeoulHotPle. All rights reserved.
//

import UIKit

class ChatVC: UIViewController, UIWebViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var webViewChat: UIWebView!
    var chatUrl = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        print("ChatVC didLoad")
        let encodedStationName = chatUrl.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)

        if let url = URL(string: encodedStationName!) {
            let request = URLRequest(url: url)
            webViewChat.loadRequest(request)
        }
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.returnKeyType = UIReturnKeyType.done

    }
    
    
}
