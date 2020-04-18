//
//  AccountViewController.swift
//  Hackernews
//
//  Created by EZDev on 2020/04/18.
//  Copyright © 2020 EZDev. All rights reserved.
//

import UIKit

class AccountViewController: UIViewController {
    
    // ui custom 처리를 위한 components
    // create by EZDev on 2020.04.18
    @IBOutlet weak var loginNameLabel: UILabel!
    @IBOutlet weak var loginPWLabel: UILabel!
    @IBOutlet weak var signUpNameLable: UILabel!
    @IBOutlet weak var signUpPWLabel: UILabel!
    
    @IBOutlet weak var loginNameText: UITextField!
    @IBOutlet weak var longinPWText: UITextField!
    @IBOutlet weak var signUpNameText: UITextField!
    @IBOutlet weak var signUpPWText: UITextField!
    
    override func loadView() {
        super.loadView()
        // textFiedl에 bottomBorder 추가
        // create by EZDev on 2020.04.18
        loginNameText.addBottomBorder()
        longinPWText.addBottomBorder()
        signUpNameText.addBottomBorder()
        signUpPWText.addBottomBorder()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
 
    }

}

extension AccountViewController: UITextFieldDelegate {
    
    // textField를 선택했을때 해당부분의 label을 강조해준다.
    // create by EZDev on 2020.04.18
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField.tag {
        case 0:
            loginNameLabel.font = .boldSystemFont(ofSize: 20)
            loginNameLabel.textColor = .systemYellow
            
            loginPWLabel.font = .systemFont(ofSize: 17)
            loginPWLabel.textColor = .systemGray
            
            signUpNameLable.font = .systemFont(ofSize: 17)
            signUpNameLable.textColor = .systemGray
            
            signUpPWLabel.font = .systemFont(ofSize: 17)
            signUpPWLabel.textColor = .systemGray
        case 1:
            loginNameLabel.font = .systemFont(ofSize: 17)
            loginNameLabel.textColor = .systemGray
            
            loginPWLabel.font = .boldSystemFont(ofSize: 20)
            loginPWLabel.textColor = .systemYellow
            
            signUpNameLable.font = .systemFont(ofSize: 17)
            signUpNameLable.textColor = .systemGray
            
            signUpPWLabel.font = .systemFont(ofSize: 17)
            signUpPWLabel.textColor = .systemGray
        case 2:
            
            loginNameLabel.font = .systemFont(ofSize: 17)
            loginNameLabel.textColor = .systemGray
            
            loginPWLabel.font = .systemFont(ofSize: 17)
            loginPWLabel.textColor = .systemGray
            
            signUpNameLable.font = .boldSystemFont(ofSize: 20)
            signUpNameLable.textColor = .systemYellow
            
            signUpPWLabel.font = .systemFont(ofSize: 17)
            signUpPWLabel.textColor = .systemGray
        case 3:
            loginNameLabel.font = .systemFont(ofSize: 17)
            loginNameLabel.textColor = .systemGray
            
            loginPWLabel.font = .systemFont(ofSize: 17)
            loginPWLabel.textColor = .systemGray
            
            signUpNameLable.font = .systemFont(ofSize: 17)
            signUpNameLable.textColor = .systemGray
            
            signUpPWLabel.font = .boldSystemFont(ofSize: 20)
            signUpPWLabel.textColor = .systemYellow
        default:
            print("default")
        }
    }
}


