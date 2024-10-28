//
//  Constants.swift
//  ImageFeed
//
//  Created by Islam Tagirov on 22.09.2024.
//

import Foundation

enum Constants {
    static let accessKey = "rAYAtijGDAcztdPxV1Tk9mVYKGDRgOAJzD2yyKsqUO0"
    static let secretKey = "3BgTyjcdo0tS5NZZYf4JVdDtW18ACwRuVDFam0ZJ2ms"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"
    static let defaultBaseURL = URL(string: "https://api.unsplash.com") ?? URL(string: "")
}

//enum Constants {
//    static let accessKey = "<ваш Access Key>"
//    static let secretKey = "<ваш Secret Key>"
//    static let redirectURI = "<ваш Redirect URI>"
//    static let accessScope = "public+read_user+write_likes"
//    static let defaultBaseURL = URL(string: "https://api.unsplash.com")!
//}
