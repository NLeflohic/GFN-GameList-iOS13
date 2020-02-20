//
//  WebViewController.swift
//  GFN-GameList
//
//  Created by nicolas le flohic on 12/02/2020.
//  Copyright © 2020 nicolas le flohic. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    
    //var webView: WKWebView!
    var urlToGo = "https://www.google.fr"
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
        if let url = URL (string: urlToGo){
            let requestObj = URLRequest(url: url)
            webView.load(requestObj)
        }
    }
}

extension WebViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print ("Animation start")
        activityIndicator.startAnimating()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicator.stopAnimating()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        activityIndicator.stopAnimating()
    }
}
