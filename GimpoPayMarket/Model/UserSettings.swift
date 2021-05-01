//
//  UserSettings.swift
//  GimpoPayMarket
//
//  Created by rae on 2021/04/27.
//

import Foundation

class UserSettings {
    static let shared: UserSettings = UserSettings()
    private init() { }
    
    var data: [Row]?
    var sigunName: String?
}
