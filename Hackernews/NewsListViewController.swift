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
    var newsList: [Hacker] = []
    

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
    
    // hacker news api에 접속하여 데이터를 업데이트 한다.
    // create by EZDev on 2020.04.13
    func connectAPI() {
        guard let url = URL(string: "https://hn.algolia.com/api/v1/search_by_date?tags=story") else { return }
        
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
            self.newsList = self.parseHacker(getData) ?? []
            
            OperationQueue.main.addOperation {
                // UITableView UI 업데이트
                self.newsTable.reloadData()
            }
            
        }
        dataTask.resume()
    }

}


extension NewsListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsCell.cellIdentifire, for: indexPath) as? NewsCell else { return UITableViewCell()}
        
        cell.updateUI(hacker: newsList[indexPath.row])
        
        return cell
    }
    
    
}
