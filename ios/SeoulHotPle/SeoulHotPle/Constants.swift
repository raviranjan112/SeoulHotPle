//
//  File.swift
//  SeoulHotPle
//
//  Created by KimJingyu on 2017. 2. 17..
//  Copyright © 2017년 SeoulHotPle. All rights reserved.
//

class Constants {
    
    //ID
//    public static let GOOGLE_CLIENT_ID = "40351710073-l2k87q1t73bbeson1sdui6ur81ke23ds.apps.googleusercontent.com"
    public static let GOOGLE_CLIENT_ID = "673326100706-18q8u6f7i1oqdndc46brles255p47nu3.apps.googleusercontent.com"
    
    //API KEY
//    public static let API_GOOGLE = "AIzaSyBlvahsZxJzhAg1avcHWjch5zlxYt9LwTE"
    public static let API_GOOGLE = "AIzaSyBlvahsZxJzhAg1avcHWjch5zlxYt9LwTE"
    public static let API_DAUM_GEOCODE = "bc00c31732663855acc78807ba0669ea"
    public static let API_SEOULSTATION = "4a4c4c664f6a696e37344355524d54"
    
    //current location
    public static var CURRENT_LOCATION_WGS84_X: Double? //구글
    public static var CURRENT_LOCATION_WGS84_Y: Double?
    public static var CURRENT_LOCATION_WTM_X: Double? //다음, 서울지하철
    public static var CURRENT_LOCATION_WTM_Y: Double?
    
    //destination
    public static var DEST_LOCATION_NAME: String?
    public static var DEST_LOCATION_X: Double?
    public static var DEST_LOCATION_Y: Double?
    
    //Network Code
    static let CODE_DAUM_COORDI = 100 //다음 좌표계전환API
    static let CODE_SEOUL_STATION = 101
    static let CODE_RETURN_NIL = 400
    static let CODE_CHATBOT = 102
    
    
    //ChatURL
    public static let CHAT_URL = "https://seoulhp-58dca.firebaseapp.com/"
    
    //
    public static var CURRENT_STATION = ""

}
