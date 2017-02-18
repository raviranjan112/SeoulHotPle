//
//  APIService.swift
//  SeoulHotPle
//
//  Created by KimJingyu on 2017. 2. 17..
//  Copyright © 2017년 SeoulHotPle. All rights reserved.
//
import Alamofire
import SwiftyJSON

class APIServiceModel: NetworkModel {
    
    func transCoor(x: Double, y: Double, fromCoord: String, toCoord: String) {
        
        let url = "\(daumGeoCodeURL)"
        
        Alamofire.request(url,
                          parameters:
            [
                "apikey":Constants.API_DAUM_GEOCODE,
                "fromCoord":fromCoord,
                "toCoord":toCoord,
                "output":"json",
                "x":x,
                "y":y,
                ]
            
            ).responseJSON() { res in
                switch res.result {
                case .success:
                    if let value = res.result.value {
                        //                        print(value)
                        let data = JSON(value)
                        let location = [data["x"].doubleValue, data["y"].doubleValue]
                        //                        print(location)
                        self.view.networkResult(resultData: location, code: Constants.CODE_DAUM_COORDI)
                    }
                    
                case .failure(let err):
                    print(err)
                    self.view.networkFail()
                }
        }
    }
    
    func getStation(x: Double, y: Double) {
        
        print("서울 역정보 가져오기###########")
        
        let url = "http://swopenapi.seoul.go.kr/api/subway/\(Constants.API_SEOULSTATION)/json/nearBy/1/20/\(x)/\(y)"
        
        Alamofire.request(url).responseJSON() { res in
            switch res.result {
            case .success:
                if let value = res.result.value {
                    //                        print(value)
                    let jsonData = JSON(value)
                    
                    if let jsonArray = jsonData["stationList"].array {
                        var stationList = [Station]()
                        var lastStation = ""
                        for item in jsonArray {
                            if let diffStation = item["statnNm"].string {
                                if diffStation != lastStation {
                                    lastStation = diffStation
                                    let stationItem = Station(statnNm: item["statnNm"].string, subwayXcnts: item["subwayXcnts"].double, subwayYcnts: item["subwayYcnts"].double, subwayNm: item["subwayNm"].string)
                                    stationList.append(stationItem)
                                }
                            }
                        }
                        
                        self.view.networkResult(resultData: stationList, code: Constants.CODE_SEOUL_STATION)
                    }
                    else {
                        self.view.networkResult(resultData: "", code: Constants.CODE_RETURN_NIL)
                    }
                }
                
            case .failure(let err):
                print("getStation에러")
                print(err)
                self.view.networkFail()
            }
            
        }
    }
    
    func postMessage(station: String, keyword: String) {
        let url = "https://hotple-psypu.c9users.io:8080/searchpost/"
        
        let params = [
            "keyword" : keyword,
            "station" : station
        ]
        
        Alamofire.request(url, method: .post, parameters: params).responseJSON(){ res in
            switch res.result {
            case .success:
                if let value = res.result.value {
                    let data = JSON(value)
                    print("postMessageToServer")
                    print(data)
                    let message = ChatbotMessage(one_station: data["one_station"].string, restaurant: data["restaurant"].string, location: data["location"].string, population: data["population"].int, phone: data["phone"].string)
                    self.view.networkResult(resultData: message, code: Constants.CODE_CHATBOT)
                }
            case .failure(let err):
                print(err)
                self.view.networkFail()
            }
            
        }
    }
    
}
