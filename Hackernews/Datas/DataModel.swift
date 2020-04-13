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

// hacker news api json 형식
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
