//
//  APIMgr.swift
//  Hackernews
//
//  Created by EZDev on 2020/04/17.
//  Copyright © 2020 EZDev. All rights reserved.
//

import Foundation
//import SwiftSoup

class APIMgr {
    
    static var manager = APIMgr()
    
    var userName: String?
    
    // url주소가 변경될때 사용되는 변수와 상수
    // create by EZDev on 2020.04.18
    let tagList = ["story", "best", "comment", "show_hn", "ask_hn", "jobstories"]
    var tags = "story"
    var page = 0
    
    // NewsListViewController에서 newsTable에 사용되는 데이터 변수
    // create by EZDev on 2020.04.18
    var newsList: [Hacker] = []
    
    var parent: Hacker?
    
    // hacker news search api에서 받은 데이터를 json 형식으로 변환
    // create by EZDev on 2020.04.18
    func parseHacker(_ data: Data) -> [Hacker]? {
        do {
            let decoder = JSONDecoder()
            if tags == tagList[5] {
                let hacker = try decoder.decode(Hacker.self, from: data)
                return [hacker]
            }
            else {
                print(tags)
                let response = try decoder.decode(Response.self, from: data)
                return response.hits
            }
            
        } catch let jsonErr {
            print("parse error")
            print(jsonErr.localizedDescription)
            return nil
        }
    }
    
    // hacker news api 에서 받은 내용을 20개씩 데이터를 업데이트 해준다.
    // create by EZDev on 2020.04.18
    func parseJobs(_ data: Data) {
        do {
            let response = try JSONSerialization.jsonObject(with: data, options: []) as? [AnyObject]
            if let res = response {
                for i in (page * 20)..<(page * 20 + 20){
                    connectCode("\(res[i])")
                }
            }
        } catch let jsonError {
            print(jsonError)
        }
    }
    
    // hacker news search api에서 필요한 데이터를 단일로 가져올때 사용한다.
    // create by EZDev on 2020.04.18
    func connectCode(_ code: String) {
        guard let url = URL(string: "https://hn.algolia.com/api/v1/items/\(code)") else { return }
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let dataTask = session.dataTask(with: url) { (data, response, error) in
            // client error check
            if let clientError = error {
                print(clientError)
                return
            }
            
            // server error check
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode else { return }
            guard (200..<300).contains(statusCode) else {
                print("~~> status code : \(statusCode)")
                // error handle
                return
            }
            
            // result data check
            guard let getData = data else {
                print("data error")
                return
                
            }
            self.newsList += self.parseHacker(getData) ?? []
            
            // 데이터의 변경이 끝났다는것을 NewsListViewController에 알려준다.
            NotificationCenter.default.post(name: APIMgr.completedData, object: nil)
            
        }
        dataTask.resume()
    }
    
    // hacker news search api 혹은 jobs를 위한 hacker news api를 호출한다.
    // create by EZDev on 2020.04.17
    func connectAPI() {
        
        var url: URL!
        
        if tags == tagList[1] {
            url = URL(string: "https://hn.algolia.com/api/v1/search?tags=story&page=\(page)")
        }
        else if tags == tagList[5] {
            url = URL(string: "https://hacker-news.firebaseio.com/v0/\(tags).json")
        }
        else {
            url = URL(string: "https://hn.algolia.com/api/v1/search_by_date?tags=\(tags)&page=\(page)")
        }
        
        print(url)
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let dataTask = session.dataTask(with: url) { (data, response, error) in
            // client error check
            if let clientError = error {
                print(clientError)
                return
            }
            
            // server error check
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode else { return }
            guard (200..<300).contains(statusCode) else {
                print("~~> status code : \(statusCode)")
                // error handle
                return
            }
            
            // result data check
            guard let getData = data else {
                print("data error")
                return
                
            }
            
            // 정보 업데이트
            if self.tags == self.tagList[5] {
                self.parseJobs(getData)
            }
            else {
                self.newsList += self.parseHacker(getData) ?? []
            }
            
            
            // 데이터의 변경이 끝났다는것을 NewsListViewController에 알려준다.
            NotificationCenter.default.post(name: APIMgr.completedData, object: nil)
            
        }
        dataTask.resume()
    }
    
    static let completedParent = Notification.Name(rawValue: "completedParent")
    
    func parseParent(_ data: Data) -> Hacker? {
        do {
            let decoder = JSONDecoder()
            let hacker = try decoder.decode(Hacker.self, from: data)
            return hacker
        } catch let jsonError {
            print(jsonError.localizedDescription)
        }
        return nil
    }
    
    
    func connectParent(_ code: String) {
        guard let url = URL(string: "https://hn.algolia.com/api/v1/items/\(code)") else { return }
        
        print(url)
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let dataTask = session.dataTask(with: url) { (data, response, error) in
            // client error check
            if let clientError = error {
                print(clientError)
                return
            }
            
            // server error check
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode else { return }
            guard (200..<300).contains(statusCode) else {
                print("~~> status code : \(statusCode)")
                // error handle
                return
            }
            
            // result data check
            guard let getData = data else {
                print("data error")
                return
            }
            
            self.parent = self.parseParent(getData)
            
            NotificationCenter.default.post(name: APIMgr.completedParent, object: nil, userInfo: nil)

        }
        dataTask.resume()
    }
    
//    func loginHackerNews(id: String, pw: String) {
//        let baseURL = "https://news.ycombinator.com/login"
//
//        guard let url = URL(string: baseURL) else { return }
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
//        request.setValue("*", forHTTPHeaderField: "Access-Control-Allow-Origin")
//        let body = "acct=\(id)&pw=\(pw)&goto=news".data(using: .utf8, allowLossyConversion: true)
//        request.httpBody = body
//
//        let config = URLSessionConfiguration.default
//        let session = URLSession(configuration: config)
//
//
//        let dataTask = session.dataTask(with: request) { (data, response, error) in
//            // client error check
//            if let clientError = error {
//                print(clientError)
//                return
//            }
//
//            // server error check
//            guard let statusCode = (response as? HTTPURLResponse)?.statusCode else { return }
//            guard (200..<300).contains(statusCode) else {
//                print("~~> status code : \(statusCode)")
//                // error handle
//                return
//            }
//            if let getData = data {
//
//                if let html = String(data: getData, encoding: .utf8) {
//                    self.parseHtml(html: html)
//                }
//
//            }
//        }
//        dataTask.resume()
//
//    }
//
//    func parseHtml(html: String) {
//        var userInfo: [AnyHashable: Any] = [:]
//
//        do {
//            let doc = try SwiftSoup.parse(html)
//            let id = try doc.select("a")
//            let body = try doc.select("body").first()
//
//            if let text = try body?.text() {
//                print(text)
//                if let _ = text.range(of: "Bad login.") {
//                    userInfo["loginResult"] = false
//                }
//                else {
//                    userInfo["loginResult"] = true
//                    for i in id {
//                        if i.id() == "me" {
//                            let userID = try i.text()
//                            self.userName = userID
//                            print(userID)
//                        }
//                    }
//                }
//            }
//            print(userInfo)
//            NotificationCenter.default.post(name: APIMgr.loginResult, object: nil, userInfo: userInfo)
//        } catch let htmlParserError {
//            print(htmlParserError.localizedDescription)
//
//        }
//
//    }
}


extension APIMgr {
    static let completedData = Notification.Name(rawValue: "completedData")
    static let loginResult = Notification.Name(rawValue: "loginResult")
}
