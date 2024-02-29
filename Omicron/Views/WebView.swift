//
//  WebView.swift
//  Omicron
//
//  Created by Beni Kis on 24/02/2024.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    let url: String
    @Binding var isPresented: Bool
    @Binding var lastURL: String
    @Binding var page: Any?
    
    func makeUIView(context: Context) -> WKWebView  {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        if let url = URL(string: url) {
            webView.load(URLRequest(url: url))
        }
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: WebView
        
        init(parent: WebView) {
            self.parent = parent
        }
        
        func webView(_ webView: WKWebView, didRecieveData navigation: WKNavigation!) {
            parent.lastURL = webView.url?.absoluteString ?? ""
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            parent.lastURL = webView.url?.absoluteString ?? ""
            
            webView.evaluateJavaScript("document.documentElement.outerHTML.toString()") {html, _ in
                self.parent.page = html
            }
        }
    }
}
