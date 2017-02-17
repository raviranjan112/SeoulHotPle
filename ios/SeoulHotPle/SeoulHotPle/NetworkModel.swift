//
//  NetworkModel.swift
//  SeoulHotPle
//
//  Created by KimJingyu on 2017. 2. 17..
//  Copyright © 2017년 SeoulHotPle. All rights reserved.
//

class NetworkModel {
    
    internal let daumGeoCodeURL = "https://apis.daum.net/local/geo/transcoord"
    internal let seoulStationURL = "http://swopenAPI.seoul.go.kr/api/subway"

    var view: NetworkCallback
    
    init(_ view: NetworkCallback) {
        self.view = view
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
