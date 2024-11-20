//
//  UIBlockingProgressHUD.swift
//  ImageFeed
//
//  Created by Islam Tagirov on 08.11.2024.
//

import UIKit
import ProgressHUD

final class UIBlockingProgressHUD {
    private static var window: UIWindow? {
        return UIApplication.shared.windows.first
    }
    
    static var isShowing: Bool = false

    static func show() {
        guard !isShowing else { return }
        isShowing = true
        window?.isUserInteractionEnabled = false
        ProgressHUD.animate() 
    }

    static func dismiss() {
        isShowing = false
        window?.isUserInteractionEnabled = true
        ProgressHUD.dismiss()
    }
}


