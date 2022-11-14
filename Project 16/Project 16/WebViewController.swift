//
//  WebViewController.swift
//  Project 16
//
//  Created by Ákos Morvai on 2022. 05. 05..
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate {
    var webView: WKWebView!
    var cityName: String?

    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let url = URL(string: "https://en.wikipedia.org/wiki/\(cityName ?? "")") {
            webView.load(URLRequest(url: url))
        } else {
            webView.load(URLRequest(url: URL(string: "https://en.wikipedia.org/wiki/")!))
        }
    }
}
