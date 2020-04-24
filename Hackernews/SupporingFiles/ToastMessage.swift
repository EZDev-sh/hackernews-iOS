//
//  ToastMessage.swift
//  Hackernews
//
//  Created by EZDev on 2020/04/24.
//  Copyright © 2020 EZDev. All rights reserved.
//

import UIKit

extension UIViewController {
    func showToastMsg(message: String, seconds: Double) {
        let toast = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        toast.view.backgroundColor = .black
        toast.view.alpha = 0.6
        toast.view.layer.cornerRadius = 15
        
        self.present(toast, animated: true, completion: nil)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds) {
            toast.dismiss(animated: true, completion: nil)
        }
    }
}

