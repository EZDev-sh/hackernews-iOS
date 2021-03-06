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
    
    @IBOutlet weak var stackView: UIStackView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    var newsItem: Hacker?
    
    override func loadView() {
        super.loadView()
        
        // navigation bar item 색상 변경
        // create by EZDev on 2020.04.19
        self.navigationController?.navigationBar.tintColor = .white
        
        // text view에 테두리 설정
        self.commentTextView.layer.borderColor = UIColor.systemGray.cgColor
        self.commentTextView.layer.borderWidth = 1

        // 버튼 모서리 둥글게
        self.sendBtn.layer.cornerRadius = 15
        self.sendBtn.layer.masksToBounds = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        commentTextView.delegate = self
        // 선택한 코멘트의 상위 글을 불러온다.
        if let code = newsItem?.parentId  {
            APIMgr.manager.connectParent("\(code)")
        }
        // 
        else if let code = newsItem?.objectID {
            APIMgr.manager.connectParent("\(code)")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 상위 글의 데이터를 화면에 표현해준다.
        NotificationCenter.default.addObserver(forName: APIMgr.completedParent, object: nil, queue: OperationQueue.main) { [weak self] (noti) in
            
            
            let parent = APIMgr.manager.parent
            
            if let title = parent?.title {
                self?.content.text = title.htmlEscaped
            }
            else {
                self?.content.text = parent?.text?.htmlEscaped
            }
            
            if let points = parent?.points {
                self?.point.text = "\(points) point"
            }
            else {
                self?.point.text = "0 point"
            }
            
            
            
            self?.date.text = parent?.dateTime
            if let author = parent?.author {
                self?.author.text = "by \(author)"
            }

            var commentCnt = 0
            
            if let comments = parent?.children {
                commentCnt = comments.count
                for comment in comments {
                    if let cnt = self?.addCommentCard(baseView: self?.stackView, comment: comment) {
                        commentCnt += cnt
                    }
                    
                }
            }
            
            if let numComment = parent?.numComments {
                self?.comment.text = "\(numComment) comment"
            }
            else {
                self?.comment.text = "\(commentCnt) comment"
            }
            
            
            
            // scrollView의 content size를 유동적으로 변경합니다.
            // create by EZDev on 2020.04.24
            if let height = self?.stackView.frame.height, let viewHeight = self?.view.bounds.height {
                
                self?.scrollView.contentSize.height = height + viewHeight
            }
            
            self?.loading.stopAnimating()
            
        }
    }
    
    
    // 해당글에 작성된 모든 댓글을 표현해줍니다.
    // create by EZDev on 2020.04.27
    var depth = 0
    func addCommentCard(baseView: UIStackView?, comment: Hacker) -> Int {
        
        var num = 0
        // 댓글에 작성된 댓글을 표현해주기위한 stackView
        let commentStackView = UIStackView()
        commentStackView.axis = .vertical
        commentStackView.alignment = .fill
        commentStackView.distribution = .equalSpacing
        commentStackView.spacing = 10
        // 댓글의 댓글이라는 것을 표현해주기위한 들여쓰기
        let leftMargin = CGFloat(depth * 10)
        commentStackView.layoutMargins = UIEdgeInsets(top: 0, left: leftMargin, bottom: 0, right: 0)
        commentStackView.isLayoutMarginsRelativeArrangement = true
        
        // 댓글의 내용이 들어갈 컴포넌트
        let commentCard = CommentCard()
        commentCard.author.text = comment.author
        commentCard.date.text = comment.dateTime
        commentCard.commentText.text = comment.text?.htmlEscaped
        
        commentStackView.addArrangedSubview(commentCard)
        
        // 댓글이 달린것이 있는지 확인
        if let kids = comment.children {
            num = kids.count
            // 댓글의 깊이 추가
            depth += 1
            for kid in kids {
                num += self.addCommentCard(baseView: commentStackView, comment: kid)
            }
        }
        // 댓글의 깊이를 다시 이전으로 되돌리기
        depth -= 1
        
        baseView?.addArrangedSubview(commentStackView)
        return num
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
