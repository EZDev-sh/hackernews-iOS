//
//  TextField+BottomBorder.swift
//  Hackernews
//
//  Created by EZDev on 2020/04/18.
//  Copyright © 2020 EZDev. All rights reserved.
//

import UIKit

// TextField의 밑부분만 systemYello로 색칠해준다.
// create by EZDev on 2020.04.18
extension UITextField {
    func addBottomBorder(){
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: self.frame.size.height - 1, width: self.frame.size.width, height: 1)
        bottomLine.backgroundColor = UIColor.systemYellow.cgColor
        borderStyle = .none
        layer.addSublayer(bottomLine)
    }
}
