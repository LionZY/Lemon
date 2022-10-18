//
//  Theme.swift
//  XMetro
//
//  Created by Yue Zhang on 2022/10/11.
//

import SwiftUI

class Theme {
    static let mainColor = Color.black
    static let lightColor = Color.red
    static let middleLightColor = Color.yellow
    static let specialLightColor = Color.green
    static let whiteColor = Color.white
    static let grayColor = Color(hex: 0xAAAAAA, alpha: 1.0)
    static let lightGrayColor = Color(hex: 0xBBBBBB, alpha: 1.0)
    static let shadowColor = Color(hex: 0xAAAAAA, alpha: 1.0)
    
    static func navigationBarColors(background : UIColor?, titleColor : UIColor? = nil, tintColor : UIColor? = nil ){
        let navBar = UINavigationBarAppearance()
        navBar.configureWithOpaqueBackground()
        navBar.backgroundColor = background ?? .clear
        navBar.titleTextAttributes = [.foregroundColor: titleColor ?? Theme.mainColor]
        navBar.largeTitleTextAttributes = [.foregroundColor: titleColor ?? Theme.mainColor]
       
        UINavigationBar.appearance().standardAppearance = navBar
        UINavigationBar.appearance().compactAppearance = navBar
        UINavigationBar.appearance().scrollEdgeAppearance = navBar
        UINavigationBar.appearance().tintColor = tintColor ?? titleColor ?? UIColor(Theme.mainColor)
    }
    
    static func barButtonItemColors(tintColor : UIColor? = .black){
        let barButtonItem = UIBarButtonItem.appearance()
        barButtonItem.tintColor = tintColor
    }
}
