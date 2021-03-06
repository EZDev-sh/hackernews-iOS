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
    @IBOutlet weak var loginBtn: UIBarButtonItem!
    
    @IBOutlet var headerBtns: [UIButton]!
    
    @IBOutlet weak var header: UIView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // xcode 11.4.1에서 스토리보드상에서 navigationbar large title = true일때 tintColor 설정이 안되는 부분을 구현
        // create by EZDev on 2020.04.16
        if #available(iOS 13.0, *) {
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.configureWithOpaqueBackground()
            navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
            navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
            navBarAppearance.backgroundColor = .systemYellow
            self.navigationController?.navigationBar.standardAppearance = navBarAppearance
            self.navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        }
        
        if let name = APIMgr.manager.userName {
            loginBtn.title = name
        }
        else {
            loginBtn.title = "Log In"
        }
        

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // api에 접속하여 데이터 추출을 시도한다.
        APIMgr.manager.connectAPI()
        
        // 데이터 추출이 끝났을경우 알림이오는 노티피케이션
        NotificationCenter.default.addObserver(forName: APIMgr.completedData, object: nil, queue: OperationQueue.main) { [weak self] (noti) in
            self?.newsTable.reloadData()
        }
        
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // header highlight
        if let cnt = headerBtns[0].layer.sublayers?.count, cnt == 1 {
            headerBtns[0].highlightUnderLine()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        // 사용된 노티피게이션을 NewsListViewController가 꺼지면 제거한다.
        // create by EZDev on 2020.04.18
        NotificationCenter.default.removeObserver(self)
    }
    
    // 페이지 전환
    // create by EZDev on 2020.04.16
    @IBAction func headerBtn(_ sender: UIButton) {
        for btn in headerBtns {
            if let cnt = btn.layer.sublayers?.count, cnt > 1 {
                btn.layer.sublayers?.removeLast()
            }
        }
        sender.highlightUnderLine()
        APIMgr.manager.page = 0
        APIMgr.manager.tags = APIMgr.manager.tagList[sender.tag]
        APIMgr.manager.newsList.removeAll()
        APIMgr.manager.connectAPI()
    }
    
    
    
    @IBAction func notRealize(_ sender: UIBarButtonItem) {
        self.showToastMsg(message: "아직 기능 구현중 입니다.", seconds: 1.0)
    }
  
}

// UITableView의 데이터와 행동 컨트롤
// create by EZDev on 2020.04.13
extension NewsListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return APIMgr.manager.newsList.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsCell.cellIdentifire, for: indexPath) as? NewsCell else { return UITableViewCell()}
        
        cell.updateUI(hacker: APIMgr.manager.newsList[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sendData = APIMgr.manager.newsList[indexPath.row]
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        
        if let _ = sendData.url {
            guard let webView = storyBoard.instantiateViewController(withIdentifier: "webView") as? OriginWebViewcontroller else { return }
            webView.newsItem = sendData
            self.navigationController?.pushViewController(webView, animated: true)
 
        }
        else {
            guard let detailView = storyBoard.instantiateViewController(withIdentifier: "detailView") as? DetailViewController else { return }
            
            detailView.newsItem = sendData
            self.navigationController?.pushViewController(detailView, animated: true)
            
        }
    }
    
    // 스크롤 제일 아래로 내렸을경우 데이터를 업데이트 해준다.
    // create by EZDev on 2020.04.13
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let contentHeight = scrollView.contentSize.height
        let scrollBottom = scrollView.contentOffset.y + scrollView.bounds.height
        
        if contentHeight <= scrollBottom {
            APIMgr.manager.page += 1
            APIMgr.manager.connectAPI()
        }
    }
    
}
