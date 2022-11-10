//
//  Theme.swift
//  XMetro
//
//  Created by Yue Zhang on 2022/10/11.
//

import SwiftUI

class Theme {
    static let blackColor = Color.black
    static let redColor = Color.red
    static let yellowColor = Color(hex: 0xFCE852)
    static let greenColor = Color.green
    static let whiteColor = Color.white
    static let grayColor8 = Color(hex: 0x888888, alpha: 1.0)
    static let grayColorA = Color(hex: 0xAAAAAA, alpha: 1.0)
    static let grayColorB = Color(hex: 0xBBBBBB, alpha: 1.0)
    static let grayColorC = Color(hex: 0xCCCCCC, alpha: 1.0)
    static let grayColorCD = Color(hex: 0xCDCDCD, alpha: 1.0)
    static let grayColorE = Color(hex: 0xEEEEEE, alpha: 1.0)
    static let grayColorF1 = Color(hex: 0xF1F1F1, alpha: 1.0)
    static let grayColorF5 = Color(hex: 0xF5F5F5, alpha: 1.0)
    static let whiteColorA2 = Color(hex: 0xFFFFFF, alpha: 0.2)
    static let whiteColorA9 = Color(hex: 0xFFFFFF, alpha: 0.9)
    static let whiteColorA95 = Color(hex: 0xFFFFFF, alpha: 0.95)
    static let blackColorA2 = Color(hex: 0x000000, alpha: 0.2)
    static let shadowColor = Color(hex: 0xAAAAAA, alpha: 1.0)
    
    static let miniButtonHeight = UIDevice.isPhone() ? 38 : 68.0
    static let miniButtonWidth = UIDevice.isPhone() ? 38 : 48.0
    static let normalButtonHeight = UIDevice.isPhone() ? 44.0 : 68.0
    static let largeButtonHeight = UIDevice.isPhone() ? 68 : 100.0
    static let largeButtonHeight2 = UIDevice.isPhone() ? 60 : 100.0
    static let pickerHeight = UIDevice.isPhone() ? 120 : 200.0
    
    static func navigationBarColors(background : UIColor?, titleColor : UIColor? = nil, tintColor : UIColor? = nil ){
        let navBar = UINavigationBarAppearance()
        navBar.configureWithOpaqueBackground()
        navBar.backgroundColor = background ?? .clear
        navBar.titleTextAttributes = [.foregroundColor: titleColor ?? Theme.blackColor]
        navBar.largeTitleTextAttributes = [.foregroundColor: titleColor ?? Theme.blackColor]
       
        UINavigationBar.appearance().standardAppearance = navBar
        UINavigationBar.appearance().compactAppearance = navBar
        UINavigationBar.appearance().scrollEdgeAppearance = navBar
        UINavigationBar.appearance().tintColor = tintColor ?? titleColor ?? UIColor(Theme.blackColor)
    }
    
    static func barButtonItemColors(tintColor : UIColor? = .black){
        let barButtonItem = UIBarButtonItem.appearance()
        barButtonItem.tintColor = tintColor
    }
}
