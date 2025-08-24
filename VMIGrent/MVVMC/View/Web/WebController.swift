//
//  WebController.swift
//  VMIGrent
//
//  Created by Mikhail Koroteev on 10.07.2022.
//

import Foundation
import UIKit
import WebKit

enum WebControllerType {
    case payment(Int)
    case simple
}

class WebController: UIViewController {
    
    class func openWebController(viewController: UIViewController, url: URL, type: WebControllerType) {
        let storyboard = UIStoryboard(name: "Web", bundle: nil)
        var controllers: [UIViewController] = viewController.navigationController?.viewControllers ?? [viewController]
        let supportArticlesController = storyboard.instantiateInitialViewController() as! WebController
        supportArticlesController.url = url
        supportArticlesController.type = type
        controllers.append(supportArticlesController)
        viewController.navigationController?.setViewControllers(controllers, animated: true)
    }
    
    @IBOutlet weak var webViewContainer: UIView!

    var type: WebControllerType = .simple
    var webView: WKWebView?
    var url: URL!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    deinit {
        print("PaymentController deinit")
    }
    
    @IBAction func backPressed() {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.setupWebView()
    }
    
    func setupWebView() {
        if let view = self.webViewContainer.viewWithTag(333) {
            view.removeFromSuperview()
            self.webView = nil
        }
        self.webView = WKWebView(frame: self.webViewContainer.bounds, configuration: WKWebViewConfiguration())
        self.webView?.cleanAllCookies()
        self.webView?.refreshCookies()
        guard let agreementWebView = self.webView else {return}
        self.webViewContainer.addSubview(agreementWebView)
        agreementWebView.navigationDelegate = self
        agreementWebView.scrollView.contentInset = UIEdgeInsets(top: 10.0, left: 0, bottom: 0, right: 0.0)
        agreementWebView.scrollView.showsVerticalScrollIndicator = false
        agreementWebView.backgroundColor = .clear
        agreementWebView.tag = 333
//        let headerString = "<header><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'></header>"
//        let agreementText = String(format: "<body bgcolor=\"#FFFFFF\" text=\"#000000\" link=\"#578764\" style=\"background-color: transparent\"><span style=\"font-family: SFProText-Light; font-size:14\">%@</span></body>", agreementString)
        self.webView?.navigationDelegate = self
        self.webView?.load(URLRequest(url: self.url))
        
//        agreementWebView.loadHTMLString(headerString + agreementText, baseURL: nil)
    }
    
    
}

extension WKWebView {

    func cleanAllCookies() {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        print("All cookies deleted")

        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
                print("Cookie ::: \(record) deleted")
            }
        }
    }

    func refreshCookies() {
        self.configuration.processPool = WKProcessPool()
    }
}

extension WebController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if let url = self.webView?.url {
            print(url.absoluteString)
            switch self.type {
            case .payment(let id):
                if url.absoluteString.contains("/payments/success") {
                    InfoController.openInfoController(viewController: self, type: .payment(id))
                } else if url.absoluteString.contains("payments/failed") {
                    InfoController.openInfoController(viewController: self, type: .errorPayment)
                }
            case .simple:
                break
            }
        }
    }
    
    func getQueryStringParameter(url: String, param: String) -> String? {
      guard let url = URLComponents(string: url) else { return nil }
      return url.queryItems?.first(where: { $0.name == param })?.value
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
//        self.openErrorAlert { [unowned self] in
//            self.navigationController?.popViewController(animated: true)
//        }
    }
    
}
