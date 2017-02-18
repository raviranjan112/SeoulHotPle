//
//  Extenstion.swift
//  SeoulHotPle
//
//  Created by KimJingyu on 2017. 2. 17..
//  Copyright © 2017년 SeoulHotPle. All rights reserved.
//
import UIKit
import Kingfisher
import Alamofire

extension UIViewController {
    func simpleAlert(title: String, msg: String?) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
    
    func networkFail() {
        simpleAlert(title: "네트워크 오류", msg: "인터넷 연결을 확인해주세요.")
    }
    
    func getStringNonOptional(_ value: String?) -> String{
        if let value_ = value {
            return value_
        } else {
            return ""
        }
    }
    
    func getIntNonOptional(_ value: Int?) -> Int {
        if let value_ = value {
            return value_
        } else {
            return 0
        }
    }

}

extension UIImageView {
    public func imageViewFromUrl(_ urlString: String?, defaultImgPath : String) {
        let defaultImg = UIImage(named: defaultImgPath)
        if let url = urlString {
            if url.isEmpty {
                self.image = defaultImg
            } else {
                self.kf.setImage(with: URL(string: url), placeholder: defaultImg, options: nil)
            }
        } else {
            self.image = defaultImg
        }
    }
}

extension UIColor {
    class var customGreen: UIColor {
        let darkGreen = 0x008110
        return UIColor.rgb(fromHex: darkGreen)
    }
    class func rgb(fromHex: Int) -> UIColor {
        
        let red =   CGFloat((fromHex & 0xFF0000) >> 16) / 0xFF
        let green = CGFloat((fromHex & 0x00FF00) >> 8) / 0xFF
        let blue =  CGFloat(fromHex & 0x0000FF) / 0xFF
        let alpha = CGFloat(1.0)
        
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
}
