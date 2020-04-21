//  DetailViewController.swift
//  Hackernews
//
//  Created by EZDev on 2020/04/17.
//  Copyright © 2020 EZDev. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var point: UILabel!
    @IBOutlet weak var comment: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var author: UILabel!
    
    @IBOutlet weak var commentTextView: UITextView!
    
    @IBOutlet weak var sendBtn: UIButton!
    
    var newsItem: Hacker?
    
    override func loadView() {
        super.loadView()
        
        // navigation bar item 색상 변경
        // create by EZDev on 2020.04.19
        self.navigationController?.navigationBar.tintColor = .white
        
        // navigation bar button에 사용할 이미지 설정
        // create by EZDev on 2020.04.19
        let commentImg = UIImage(named: "comments")?.withRenderingMode(.alwaysTemplate)
        
        if let commentNums = newsItem?.numComments {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem.button(image: commentImg!, title: " \(commentNums)", target: self, action: #selector(clickComment(_:)))
        }
        else {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem.button(image: commentImg!, title: " 0", target: self, action: #selector(clickComment(_:)))
        }
        
        commentTextView.layer.borderColor = UIColor.systemGray.cgColor
        commentTextView.layer.borderWidth = 1
        
        sendBtn.layer.cornerRadius = 15
        sendBtn.layer.masksToBounds = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        commentTextView.delegate = self
//        print(newsItem?.parentId)
//        let parent = APIMgr.manager.connectParent("\(newsItem?.parentId)")
//
//        if let title = parent?.title {
//            content.text = title
//        }
//        else {
//            content.text = parent?.commentText
//        }
//        point.text = "\(parent?.points) point"
//        if let numComment = parent?.numComments as? String {
//            comment.text = "\(numComment) comment"
//        }
//        date.text = parent?.dateTime
//        author.text = parent?.author
        
        
//        NotificationCenter.default.addObserver(forName: APIMgr.completedParent, object: Hacker.self, queue: OperationQueue.main) { [weak self] (noti) in
//
//            let parent = object
//
//        }
        if let code = newsItem?.parentId  {
            APIMgr.manager.connectParent("\(code)")
            print(code)
        }
        else {
            print("faile")
        }
        
        NotificationCenter.default.addObserver(forName: APIMgr.completedParent, object: nil, queue: OperationQueue.main) { [weak self] (noti) in
            
            let parent = APIMgr.manager.parent
            
            if let title = parent?.title {
                self?.content.text = title
            }
            else {
                self?.content.text = parent?.text
            }
            
            if let points = parent?.points {
                self?.point.text = "\(points) point"
            }
            else {
                self?.point.text = "0 point"
            }
            
            if let numComment = parent?.numComments {
                self?.comment.text = "\(numComment) comment"
            }
            else if let numComment = parent?.children?.count {
                self?.comment.text = "\(numComment) comment"
            }
            
            self?.date.text = parent?.dateTime
            if let author = parent?.author {
                self?.author.text = "by \(author)"
            }
            
            

        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @objc func clickComment(_ sender: Any) {
        print("click comment")
    }
    
}

// textview에 placehold기능 추가
// create by EZDev on 2020.04.21
extension DetailViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        initTextview()
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if commentTextView.text == "" {
            initTextview()
        }
    }
    func initTextview() {
        if commentTextView.text == "내용을 입력하세요" {
            commentTextView.text = ""
            commentTextView.textColor = .black
        }
        else if commentTextView.text == "" {
            commentTextView.text = "내용을 입력하세요"
            commentTextView.textColor = .lightGray
        }
        else {
            commentTextView.textColor = .black
        }
    }
}
