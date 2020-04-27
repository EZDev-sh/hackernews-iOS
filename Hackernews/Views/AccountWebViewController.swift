//
//  AccountWebViewController.swift
//  Hackernews
//
//  Created by EZDev on 2020/04/26.
//  Copyright © 2020 EZDev. All rights reserved.
//

import UIKit
import WebKit

class AccountWebViewController: UIViewController {
    
    @IBOutlet weak var webView: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.tintColor = .white
        webView.uiDelegate = self
        webView.navigationDelegate = self

       connectAccount("https://news.ycombinator.com/login")
        
        
        
    }
    
    func connectAccount(_ link: String) {
        guard let url = URL(string: link) else { return }
        
        let webrequest = URLRequest(url: url)
        
        webView.load(webrequest)
    }

}

extension AccountWebViewController:  WKUIDelegate, WKNavigationDelegate {
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
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("end")
        WKWebsiteDataStore.default().httpCookieStore.getAllCookies({ (cookies) in
            for cookie in cookies {
                print("cookie: \(cookie.name) - \(cookie.value)")
            }
        })
    }
}

