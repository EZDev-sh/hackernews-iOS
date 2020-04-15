//
//  DataModel.swift
//  Hackernews
//
//  Created by EZDev on 2020/04/12.
//  Copyright © 2020 EZDev. All rights reserved.
//

import Foundation

struct Response: Codable {
    let hits: [Hacker]
}

// hacker news search api json 형식
// create by EZDev on 2020.04.13
struct Hacker: Codable {
    let title: String?
    let url: String?
    let author: String?
    let numComments: Int?
    let points: Int?
    let date: String?
    
    // 년, 월, 일 만 다시 가져온다.
    // create by EZDev on 2020.04.13
    var dateTime: String {
        let startIndex = self.date?.startIndex
        let endIndex = self.date?.index(startIndex!, offsetBy: 10)
        let range = startIndex!..<endIndex!
        
        return String(self.date![range])
    }
    
    // 출처가 어느 사이트인지만 가져온다.
    // create by EZDev on 2020.04.13
    var host: String? {
        if let reference = self.url {
            guard let url = URL(string: reference) else { return nil }
            return url.host
        }
        else { return nil }
    }
    
    // json 형식을 swift에 맞춰서 변수를 사용하기 위한 작업
    // create by EZDev on 2020.03.14
    enum CodingKeys: String, CodingKey {
        case title, url, author, points
        case numComments = "num_comments"
        case date = "created_at"
    }
    
}

// hacker news api json 형식
// create by EZDev on 2020.04.15
struct Jobs: Codable {
    let author: String
    let title: String
    let time: Int
    let kids: [Int]?
    let id: Int
    let url: String
    
    var host: String? {
        guard let url = URL(string: self.url) else { return nil }
        return url.host
    }
    
    var dateTime: String {
        let date = Date(timeIntervalSince1970: Double(self.time))
        let dateFormatter = DateFormatter()
        
        dateFormatter.locale = Locale(identifier: "ko")
        dateFormatter.timeStyle = .none
        dateFormatter.dateStyle = .medium
        dateFormatter.dateFormat = "YYYY-MM-DD"
        
        return dateFormatter.string(from: date)
    }
    
    var numComments: String {
        if let cnt = self.kids?.count {
            return "\(cnt)"
        }
        else {
            return "0"
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case author = "by"
        case title, time, kids, id, url
    }
}

//
//"by" : "nickb",
//"id" : 8952,
//"kids" : [ 9153 ],
//"parent" : 8863,
//"text" : "The only problem is that you have to install something. See, it's not the same as USB drive. Most corporate laptops are locked and you can't install anything on them. That's gonna be the problem. Also, another point where your USB comparison fails is that USB works in places where you don't have internet access. <p>My suggestion is to drop the \"Throw away your USB drive\" tag line and use something else... it will just muddy your vision.<p>Kudos for launching it!!! Launching/shipping is extremely hard and you pulled it off! Super!",
//"time" : 1175727286,
//"type" : "comment"
