//
//  SearchingAddress.swift
//  Refriger
//
//  Created by 조종운 on 2020/03/17.
//  Copyright © 2020 조종운. All rights reserved.
//

import SwiftUI
import WebKit

struct SearchingAddress: View {
    var body: some View {
        VStack {
            Text("Hello")
        }
    }
}

struct WebView: UIViewRepresentable {
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.scrollView.isScrollEnabled = false
        return webView
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        let liveView = "http://localhost:5000/addrSearch.html"
        if let url = URL(string: liveView) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
}
