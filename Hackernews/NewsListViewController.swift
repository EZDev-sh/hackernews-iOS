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
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        // 사용된 노티피게이션을 NewsListViewController가 꺼지면 제거한다.
        // create by EZDev on 2020.04.18
        NotificationCenter.default.removeObserver(self)
    }
    // cell 선택시 화면 전환하게 해줍니다.
    // create by EZDev on 2020.04.17
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            let vc = segue.destination as? DetailViewController
            
            if let cell = sender as? NewsCell {
                if let indexPath = newsTable.indexPath(for: cell) {
                    vc?.connectURL = APIMgr.manager.newsList[indexPath.row].url
                    vc?.naviTitleStr = APIMgr.manager.tags
                }
            }
            
        }
    }
    
    // 페이지 전환
    // create by EZDev on 2020.04.16
    @IBAction func headerBtn(_ sender: UIButton) {
        APIMgr.manager.page = 0
        APIMgr.manager.tags = APIMgr.manager.tagList[sender.tag]
        APIMgr.manager.newsList.removeAll()
        APIMgr.manager.connectAPI()
    }
    
    @IBAction func addComment(_ sender: UIBarButtonItem) {
        
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
