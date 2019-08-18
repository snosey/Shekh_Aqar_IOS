//
//  FontUtils.swift
//  SheekhAqaar
//
//  Created by Hesham Donia on 8/17/19.
//  Copyright © 2019 Hesham Donia. All rights reserved.
//

import Foundation
import UIKit

enum AppFontType : String {
    case Bold = "TheSans-Bold"
    case Regular = "TheSans-Plain"
}

class AppFontSize  {
    static let large  : CGFloat = 18
    static let medium : CGFloat = 16
    static let small :  CGFloat  = 13
    
}


class AppFont {
    
    static func printFonts() {
        let fontFamilyNames = UIFont.familyNames.sorted()
        for familyName in fontFamilyNames {
            print("------------------------------")
            print("Font Family Name = [\(familyName)]")
            let names = UIFont.fontNames(forFamilyName: familyName)
            print("Font Names = [\(names)]")
        }
    }
    
    static func font(type: AppFontType, size: CGFloat) -> UIFont {
        return UIFont(name: type.rawValue, size: size)!
    }
}
