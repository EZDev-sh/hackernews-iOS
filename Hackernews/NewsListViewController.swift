//
//  NewsListViewController.swift
//  Hackernews
//
//  Created by EZDev on 2020/04/12.
//  Copyright © 2020 EZDev. All rights reserved.
//

import UIKit

class NewsListViewController: UIViewController {
    
    // 변경 되어야할 UI Component
    @IBOutlet weak var newsTable: UITableView!
    
    // UITableView에 첨부되어야할 데이터
    // create by EZDev on 2020.04.13
    let tagList = ["story", "comment", "show_hn", "ask_hn", "jobstories"]
    var newsList: [Hacker] = []
    var page: Int = 0
    var tags: String = "jobstories"
    var jobsList: [Jobs] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        connectAPI()
    }
    
    // hacker news api에서 받은 데이터를 json 형식으로 변환
    // create by EZDev on 2020.04.13
    func parseHacker(_ data: Data) -> [Hacker]? {
        do {
            let decoder = JSONDecoder()
            let response = try decoder.decode(Response.self, from: data)
            return response.hits
        } catch let jsonErr {
            print(jsonErr.localizedDescription)
            return nil
        }
    }
    
    func parse(_ data: Data) {
        do {
            let decoder = JSONDecoder()
            let response = try decoder.decode(Jobs.self, from: data)
            self.jobsList.append(response)
        } catch let jsonError {
            print("job json")
            print(jsonError)
        }
    }
    
    func connectJobCode(_ code: String) {
        guard let url = URL(string: "https://hacker-news.firebaseio.com/v0/item/\(code).json") else { return }
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
            
            self.parse(getData)
            
            // 정보 업데이트
            //            self.newsList += self.parseHacker(getData) ?? []
            
            OperationQueue.main.addOperation {
                // UITableView UI 업데이트
                self.newsTable.reloadData()
            }
            
        }
        dataTask.resume()
    }
    
    func parseJobs(_ data: Data){
        do {
            let response = try JSONSerialization.jsonObject(with: data, options: []) as? [AnyObject]
            if let res = response {
                for i in (page * 20)..<(page * 20 + 20){
                    connectJobCode("\(res[i])")
                }
            }
        } catch let jsonError {
            print(jsonError)
        }
    }
    func connectJobAPI() {
        guard let url = URL(string: "https://hacker-news.firebaseio.com/v0/\(tags).json") else { return }
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
            
            self.parseJobs(getData)
            
            // 정보 업데이트
            //            self.newsList += self.parseHacker(getData) ?? []
            
            OperationQueue.main.addOperation {
                // UITableView UI 업데이트
                self.newsTable.reloadData()
            }
            
        }
        dataTask.resume()
    }
    
    // hacker news api에 접속하여 데이터를 업데이트 한다.
    // create by EZDev on 2020.04.13
    func connectAPI() {
        if tags == tagList[4] {
            connectJobAPI()
            return
        }
        guard let url = URL(string: "https://hn.algolia.com/api/v1/search_by_date?tags=\(tags)&page=\(page)") else { return }
        
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
            self.newsList += self.parseHacker(getData) ?? []
            
            OperationQueue.main.addOperation {
                // UITableView UI 업데이트
                self.newsTable.reloadData()
            }
            
        }
        dataTask.resume()
    }
    
    @IBAction func headerBtn(_ sender: UIButton) {
        page = 0
        tags = tagList[sender.tag]
        newsList.removeAll()
        connectAPI()
    }
    
    @IBAction func addComment(_ sender: UIBarButtonItem) {
        print("add comment")
    }
    
}

// UITableView의 데이터와 행동 컨트롤
// create by EZDev on 2020.04.13
extension NewsListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tags == "jobstories" {
            return jobsList.count
        }
        else {
            return newsList.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsCell.cellIdentifire, for: indexPath) as? NewsCell else { return UITableViewCell()}
        
        if tags == "jobstories" {
            cell.updateJobs(job: jobsList[indexPath.row])
        }
        else {
            cell.updateUI(hacker: newsList[indexPath.row])
        }
        
        
        return cell
    }
    
    // 스크롤 제일 아래로 내렸을경우 데이터를 업데이트 해준다.
    // create by EZDev on 2020.04.13
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let contentHeight = scrollView.contentSize.height
        let scrollBottom = scrollView.contentOffset.y + scrollView.bounds.height
        
        if contentHeight <= scrollBottom {
            page += 1
            connectAPI()
        }
        
    }
    
}
