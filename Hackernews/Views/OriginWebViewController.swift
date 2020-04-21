//
//  OriginWebViewController.swift
//  Hackernews
//
//  Created by EZDev on 2020/04/20.
//  Copyright © 2020 EZDev. All rights reserved.
//

import UIKit
import WebKit

class OriginWebViewcontroller: UIViewController {
    
    @IBOutlet weak var webView: WKWebView!
    
    var newsItem: Hacker?
    
    override func loadView() {
        super.loadView()
        
        // navigation bar item 색상 변경
        // create by EZDev on 2020.04.19
        self.navigationController?.navigationBar.tintColor = .white
        
        // navigation bar button에 사용할 이미지 설정
        // create by EZDev on 2020.04.19
        let pointImg = UIImage(named: "point")?.withRenderingMode(.alwaysTemplate)
        let commentImg = UIImage(named: "comments")?.withRenderingMode(.alwaysTemplate)
        
        if let commentNums = newsItem?.numComments {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem.button(image: commentImg!, title: " \(commentNums)", target: self, action: #selector(clickComment(_:)))
        }
        if let point = newsItem?.points {
            self.navigationItem.rightBarButtonItems?.append(UIBarButtonItem.button(image: pointImg!, title: " \(point)", target: self, action: #selector(clickPoint(_:))))

        }
        
        webView.uiDelegate = self
        webView.navigationDelegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let link = newsItem?.url {
            connectOriginal(link)
        }
    }
    
    // webView에 사용할 웹사이트 불러오기
    // create by EZDev on 2020.04.19
    func connectOriginal(_ link: String) {
        guard let url = URL(string: link) else { return }
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    func loadComponents() {
        
    }
    
    @objc func clickComment(_ sender: Any) {
        print("click comment")
    }
    
    @objc func clickPoint(_ sender: Any) {
        print("click point")
    }


}
extension OriginWebViewcontroller: WKUIDelegate, WKNavigationDelegate {
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: { (action) in
            completionHandler()
        })
        
        alertController.addAction(okAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: { (action) in
            completionHandler(true)
        })
        let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: { (action) in
            completionHandler(false)
        })
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
        let alertController = UIAlertController(title: nil, message: prompt, preferredStyle: .alert)
        alertController.addTextField(configurationHandler: { (textField) in
            textField.text = defaultText
        })
        let okAction = UIAlertAction(title: "OK", style: .default, handler: { (action) in
            if let text = alertController.textFields?.first?.text {
                completionHandler(text)
            }
            else {
                completionHandler(defaultText)
            }
        })
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            completionHandler(nil)
        })
        
        alertController.addAction(okAction)
        alertController.addAction(cancel)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if navigationAction.targetFrame == nil {
            webView.load(navigationAction.request)
        }
        return nil
        
    }
    
    func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        webView.reload()
    }
}

