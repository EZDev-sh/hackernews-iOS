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
    let date: Int
    let children: [Hacker]?
    let commentText: String?
    let storyTitle: String?
    let parentId: Int?
    let text: String?
    let objectID: String?
    
    // 년, 월, 일 만 다시 가져온다.
    // create by EZDev on 2020.04.16
    var dateTime: String {
        let date = Date(timeIntervalSince1970: Double(self.date))
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko")
        dateFormatter.dateFormat = "YYYY-MM-dd"
        
        return dateFormatter.string(from: date)
        
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
    // create by EZDev on 2020.04.14
    enum CodingKeys: String, CodingKey {
        case title, url, author, points, children, text, objectID
        case numComments = "num_comments"
        case date = "created_at_i"
        case commentText = "comment_text"
        case storyTitle = "story_title"
        case parentId = "parent_id"
    }
}
