//
//  APIMgr.swift
//  Hackernews
//
//  Created by EZDev on 2020/04/17.
//  Copyright © 2020 EZDev. All rights reserved.
//

import Foundation

class APIMgr {
    static let completedData = Notification.Name(rawValue: "completedData")
    static var manager = APIMgr()
    
    // url주소가 변경될때 사용되는 변수와 상수
    // create by EZDev on 2020.04.18
    let tagList = ["story", "comment", "show_hn", "ask_hn", "jobstories"]
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
            if tags == tagList[4] {
                let hacker = try decoder.decode(Hacker.self, from: data)
                return [hacker]
            }
            else {
                let response = try decoder.decode(Response.self, from: data)
                return response.hits
            }
            
        } catch let jsonErr {
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
        
        if tags == tagList[4] {
            url = URL(string: "https://hacker-news.firebaseio.com/v0/\(tags).json")
        }
        else {
            url = URL(string: "https://hn.algolia.com/api/v1/search_by_date?tags=\(tags)&page=\(page)")
        }

        
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
            if self.tags == self.tagList[4] {
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
}
