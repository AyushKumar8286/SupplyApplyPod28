//
//  AppTheme.swift
//  onsaLive
//
//  Created by Shashi on 10/07/19.
//  Copyright © 2019 Mac6. All rights reserved.
//

import UIKit

struct Colors {
    
    static let background = UIColor(named: "background")
    static let secondaryBackground =   UIColor(named: "secondaryBackground")
    static let label =  UIColor(named: "label")
    static let secondaryLabel =  UIColor(named: "secondaryLabel")
    static let shadow = UIColor(named: "shadow")
    static let lightTint = UIColor(named: "lightTint")
    static let tint = UIColor(named: "tint")
    static let darkTint = UIColor(named: "darkTint")
    static let secondaryDarkTint = UIColor(named: "secondaryDarkTint")
    
    static func hexColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) != 6) {
            return UIColor.gray
        }

        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
