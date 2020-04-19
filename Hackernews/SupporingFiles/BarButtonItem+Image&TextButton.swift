//
//  BarButtonItem+Image&TextButton.swift
//  Hackernews
//
//  Created by EZDev on 2020/04/19.
//  Copyright © 2020 EZDev. All rights reserved.
//

import UIKit


extension UIBarButtonItem {
    // button에 이미지와 글자를동시에 넣기 위한 작업
    // create by EZDev on 2020.04.19
    static func button(image: UIImage, title: String, target: Any, action: Selector) -> UIBarButtonItem {
        let button = UIButton()
        button.setImage(image, for: .normal)
        button.setTitle(title, for: .normal)
        button.addTarget(target, action: action, for: .touchUpInside)
        button.sizeToFit()
        return UIBarButtonItem(customView: button)
    }
}

