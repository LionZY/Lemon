//
//  DeviceExtension.swift
//  XMetro
//
//  Created by Yue Zhang on 2022/11/5.
//

import Foundation
import UIKit

extension UIDevice {
    public class func isPad() -> Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }
    public class func isPhone() -> Bool {
        UIDevice.current.userInterfaceIdiom == .phone
    }
}
