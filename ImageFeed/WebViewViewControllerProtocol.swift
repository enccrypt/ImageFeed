//
//  WebViewViewController.swift
//  ImageFeed
//
//  Created by Islam Tagirov on 30.09.2024.
//

import Foundation

protocol WebViewViewControllerProtocol {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) 
}
