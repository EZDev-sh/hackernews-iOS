//
//  UIButton+UnderLine.swift
//  Hackernews
//
//  Created by EZDev on 2020/05/01.
//  Copyright © 2020 EZDev. All rights reserved.
//

import UIKit

extension UIButton {
    func highlightUnderLine() {
        let underLine = CALayer()
        let thickness = CGFloat(4)
        
        underLine.frame = CGRect(x: 0, y: self.frame.height - thickness, width: self.frame.width, height: thickness)
        underLine.backgroundColor = UIColor.white.cgColor
        
        self.layer.addSublayer(underLine)
        
    }
}
