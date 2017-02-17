//
//  Station.swift
//  SeoulHotPle
//
//  Created by KimJingyu on 2017. 2. 17..
//  Copyright © 2017년 SeoulHotPle. All rights reserved.
//

struct Station {
    var statnNm: String?
    var subwayXcnts: Double?
    var subwayYcnts: Double?
    var subwayNm: String?
    var chatCnt: Int?
    
    init?() {}
    
    init(statnNm: String?, subwayXcnts: Double?, subwayYcnts: Double?, subwayNm: String?){
        self.statnNm = statnNm
        self.subwayXcnts = subwayXcnts
        self.subwayYcnts = subwayYcnts
        self.subwayNm = subwayNm
    }
}
