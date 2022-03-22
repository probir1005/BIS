//
//  BISPrivacyPolicyVC.swift
//  BIS
//
//  Created by TSSIOS on 12/06/20.
//  Copyright © 2020 TSSIOS. All rights reserved.
//

import UIKit
import WebKit

protocol PrivacyPolicyVCProtocol: class {
    var onError: (() -> Void)? { get set }
    var onFinish: (() -> Void)? { get set }
    var onBack: (() -> Void)? { get set }
}

class BISPrivacyPolicyVC: BaseViewController, PrivacyPolicyVCProtocol {

    @IBOutlet weak var webView: WKWebView!
    var onError: (() -> Void)?
    var onBack: (() -> Void)?
    var onFinish: (() -> Void)?
    var urlRequest: URLRequest?
    lazy var privacyUrl: URL? = {
        return URL(string: "https://www.kuonitumlare.com/privacy-policy")
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.leftBackAction { _ in
            self.onBack?()
        }
        self.initializeWebView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        customTabBarController()?.hideTabBar(isHide: true)
    }

    func initializeWebView() {
        self.webView.uiDelegate = self
        self.webView.navigationDelegate = self
        if let url = privacyUrl {
            let request = URLRequest(url: url)
            self.urlRequest = request
            self.webView.load(request)
        }
    }
}

extension BISPrivacyPolicyVC: WKUIDelegate, WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        CustomNavigationController.appDelegate.InitializeIndicatorView(message: "Loading..")
    }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            IndicatorView.dismiss()
        }

        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            IndicatorView.dismiss()
        }

        func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
            IndicatorView.dismiss()
            // Error View
        }
}
