//
//  DetailWebViewViewController.swift
//  WSShopping
//
//  Created by Lee Wonsun on 2/26/25.
//

import UIKit
import SnapKit
import WebKit

final class DetailWebViewViewController: UIViewController, WKNavigationDelegate {
    
    private var webView = WKWebView()
    private let url: String

    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView = WKWebView(frame: view.bounds)
        webView.navigationDelegate = self // 네비게이션 델리게이트 설정
        configure()
        
        loadUrl(url)
    }
    
    init(url: String) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        decisionHandler(.allow)
    }
    
    private func loadUrl(_ url: String) {
        guard let detailUrl = URL(string: url) else { return }
        
        let request = URLRequest(url: detailUrl)
        webView.load(request)
    }
    
    private func configure() {
        view.addSubview(webView)
        webView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
