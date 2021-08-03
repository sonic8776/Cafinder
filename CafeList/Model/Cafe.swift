//
//  Cafe.swift
//  CafeList
//
//  Created by Judy Tsai on 2021/6/17.
//

import Foundation

class Cafe: Codable, Equatable {
    
    static func == (lhs: Cafe, rhs: Cafe) -> Bool {
        return lhs === rhs
    }
    
    var id: String
    var name: String
    var city: String
    var address: String
    var wifi: Double
    var seat: Double
    var quiet: Double
    var tasty: Double
    var cheap: Double
    var music: Double
    var weburl: String
    var latitude: String
    var longitude: String
    var limited_time: String
    var socket : String
    var standing_desk : String // 可能為空字串
    var mrt : String // 可能為空字串
    var open_time : String // 可能為空字串
    var isFavorite: Bool!
    
    init(cafeid: String, cafename: String, cafecity: String, cafeaddress: String, cafewifi: Double, cafeseat: Double, cafequiet: Double, cafetasty: Double, cafecheap: Double, cafemusic: Double, cafeweburl: String, cafeLatitude: String, cafeLongitude: String, cafeLimited_time: String, cafeSocket: String, cafeStanding_desk: String, cafeMrt: String, cafeOpen_time: String) {
        self.id = cafeid
        self.name = cafename
        self.city = cafecity
        self.address = cafeaddress
        self.wifi = cafewifi
        self.seat = cafeseat
        self.quiet = cafequiet
        self.tasty = cafetasty
        self.cheap = cafecheap
        self.music = cafemusic
        self.weburl = cafeweburl
        self.latitude = cafeLatitude
        self.longitude = cafeLongitude
        self.limited_time = cafeLimited_time
        self.socket = cafeSocket
        self.standing_desk = cafeStanding_desk
        self.mrt = cafeMrt
        self.open_time = cafeOpen_time
        self.isFavorite = false
    }
    
    init?(json: [String: Any]) {
        guard let cafeid = json["id"] as? String,
              let cafename = json["name"] as? String,
              let cafecity = json["city"] as? String,
              let cafeaddress = json["address"] as? String,
              let cafewifi = json["wifi"] as? Double,
              let cafeseat = json["seat"] as? Double,
              let cafequiet = json["quiet"] as? Double,
              let cafetasty = json["tasty"] as? Double,
              let cafecheap = json["cheap"] as? Double,
              let cafemusic = json["music"] as? Double,
              let cafeweburl = json["url"] as? String,
              let cafeLatitude = json["latitude"] as? String,
              let cafeLongitude = json["longitude"] as? String,
              let cafeLimited_time = json["limited_time"] as? String,
              let cafeSocket = json["socket"] as? String,
              let cafeStanding_desk = json["standing_desk"] as? String,
              let cafeMrt = json["mrt"] as? String,
              let cafeOpen_time = json["open_time"] as? String
        else {
            return nil
        }
        self.id = cafeid
        self.name = cafename
        self.city = cafecity
        self.address = cafeaddress
        self.wifi = cafewifi
        self.seat = cafeseat
        self.quiet = cafequiet
        self.tasty = cafetasty
        self.cheap = cafecheap
        self.music = cafemusic
        self.weburl = cafeweburl
        self.latitude = cafeLatitude
        self.longitude = cafeLongitude
        self.limited_time = cafeLimited_time
        self.socket = cafeSocket
        self.standing_desk = cafeStanding_desk
        self.mrt = cafeMrt
        self.open_time = cafeOpen_time
        self.isFavorite = false
    }
}
