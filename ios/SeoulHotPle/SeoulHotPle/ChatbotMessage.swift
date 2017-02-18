//
//  ChatbotMessage.swift
//  SeoulHotPle
//
//  Created by KimJingyu on 2017. 2. 18..
//  Copyright © 2017년 SeoulHotPle. All rights reserved.
//

struct ChatbotMessage {
    var one_station: String?
    var restaurant: String?
    var location: String?
    var phone: String?
    var population: Int?
    
    init?() {}
    
    init(one_station: String?, restaurant: String?, location: String?, population: Int?, phone: String?){
        self.one_station = one_station
        self.restaurant = restaurant
        self.location = location
        self.population = population
        self.phone = phone
    }
}
