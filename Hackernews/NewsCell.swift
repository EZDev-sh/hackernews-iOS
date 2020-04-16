//
//  NewsCell.swift
//  Hackernews
//
//  Created by EZDev on 2020/04/12.
//  Copyright © 2020 EZDev. All rights reserved.
//

import UIKit

class NewsCell: UITableViewCell {
    // 변화되어야 할 UI Components
    // create by EZDev on 2020.04.13
    @IBOutlet weak var headLine: UILabel!
    @IBOutlet weak var point: UILabel!
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var reference: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var comments: UILabel!
    
    // 이 셀의 이름
    // create by EZDev on 2020.04.13
    static let cellIdentifire = "newsCell"
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // data에 따른 UI 내용 변경
    // create by EZDev on 2020.04.13
    func updateUI(hacker: Hacker) {
        self.reference.text = hacker.host
        self.date.text = hacker.dateTime
        
        if let title = hacker.title {
            self.headLine.text = title
        }
        else {
            self.headLine.text = hacker.commentText
            self.reference.text = hacker.storyTitle
        }
        
        if let writer = hacker.author {
            self.author.text = "by \(writer)"
        }
        
        if let point = hacker.points {
            self.point.text = "\(point)"
        }
        
        if let comment = hacker.numComments {
            self.comments.text = "\(comment)"
        }
        
    }

}
