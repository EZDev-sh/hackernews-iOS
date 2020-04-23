//
//  CommentCard.swift
//  Hackernews
//
//  Created by EZDev on 2020/04/23.
//  Copyright © 2020 EZDev. All rights reserved.
//

import UIKit

class CommentCard: UIView {
    
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var commentText: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setupUI() {
        
        let view = Bundle.main.loadNibNamed("CommentCard", owner: self, options: nil)?.first as! UIView
        
        view.frame = self.bounds
        
        self.addSubview(view)
        
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.borderWidth = 1
    }
}
