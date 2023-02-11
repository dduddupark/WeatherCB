//
//  AddressViewController.swift
//  WeatherCB
//
//  Created by suyeon park on 2023/02/11.
//

import UIKit
import WebKit


class AddressViewController: UIViewController {
    
    var webView: WKWebView?
    let indicator = UIActivityIndicatorView(style: .medium)
    var address = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    
    }
    
    // MARK: - UI
        private func configureUI() {
            view.backgroundColor = .white
            setAttributes()
            setContraints()
        }
    
    private func setAttributes() {
            let contentController = WKUserContentController()
            contentController.add(self, name: "callBackHandler")

            let configuration = WKWebViewConfiguration()
            configuration.userContentController = contentController

        webView = WKWebView(frame: view.bounds, configuration: configuration)
            self.webView?.navigationDelegate = self

            guard let url = URL(string: "https://dduddupark.github.io/Kakao-Postcode/"),
                let webView = webView
                else { return }
            let request = URLRequest(url: url)
            webView.load(request)
            indicator.startAnimating()
        }

        private func setContraints() {
            guard let webView = webView else { return }
            view.addSubview(webView)
            webView.translatesAutoresizingMaskIntoConstraints = false

            webView.addSubview(indicator)
            indicator.translatesAutoresizingMaskIntoConstraints = false

            NSLayoutConstraint.activate([
                webView.topAnchor.constraint(equalTo: view.topAnchor),
                webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

                indicator.centerXAnchor.constraint(equalTo: webView.centerXAnchor),
                indicator.centerYAnchor.constraint(equalTo: webView.centerYAnchor),
            ])
        }
}


extension AddressViewController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
      
        if let data = message.body as? [String: Any] {
            print(data)
            address = data["roadAddress"] as? String ?? ""
        }
        guard let previousVC = presentingViewController as? MainViewController else { return }
        previousVC.address = address
        self.dismiss(animated: true, completion: nil)
    }
}

extension AddressViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        indicator.startAnimating()
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        indicator.stopAnimating()
    }
}
