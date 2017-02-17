//
//  NetworkCallback.swift
//  SeoulHotPle
//
//  Created by KimJingyu on 2017. 2. 17..
//  Copyright © 2017년 SeoulHotPle. All rights reserved.
//

protocol NetworkCallback {
    func networkResult(resultData: Any, code: Int)
    func networkFail()
}

//networkFail() - Extensions에서 구현
