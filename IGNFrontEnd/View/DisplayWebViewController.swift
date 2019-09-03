//
//  DisplayWebViewController.swift
//  IGNFrontEnd
//
//  Created by Aramis Knox on 3/23/19.
//  Copyright © 2019 Aramis Knox. All rights reserved.
//

import UIKit
import WebKit

class DisplayWebViewController: UIViewController, WKNavigationDelegate {
    
    public var contentUrl: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let webview = WKWebView()
        webview.navigationDelegate = self
        webview.frame  = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        webview.load(URLRequest(url: contentUrl!))
        self.view.addSubview(webview)
        self.view.sendSubview(toBack: webview)
    }
    
}
