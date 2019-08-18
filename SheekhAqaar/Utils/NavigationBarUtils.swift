//
//  NavigationBarUtils.swift
//  SheekhAqaar
//
//  Created by Hesham Donia on 8/17/19.
//  Copyright © 2019 Hesham Donia. All rights reserved.
//

import Foundation
import UIKit
import Localize_Swift

extension UINavigationBar {
    
    enum NavigationBarStyle {
        case transparent
        case transparentWithShadowLine
        case solid
        case solidNoShadow
        case translucent
    }
    
    // NOTE: color will only be applied to solid and translucent styles
    func setStyle(style : NavigationBarStyle,
                  tintColor : UIColor = .white,
                  forgroundColor: UIColor = .white,
                  backgroundColor : UIColor = .white) {
        
        switch style {
        case .transparent:
            self.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
            self.shadowImage = UIImage()
            self.isTranslucent = true
            self.backgroundColor = .clear
            self.tintColor = tintColor
        case .transparentWithShadowLine:
            self.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
            self.shadowImage = nil
            self.isTranslucent = true
            self.tintColor = tintColor
            self.backgroundColor = .clear
        case .solid:
            self.setBackgroundImage(nil, for: UIBarMetrics.default)
            self.shadowImage = nil
            self.isTranslucent = false
            self.tintColor = tintColor
            self.barTintColor = forgroundColor
        case .solidNoShadow:
            self.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
            self.shadowImage = UIImage()
            self.isTranslucent = false
            self.tintColor = tintColor
            self.barTintColor = forgroundColor
        case .translucent:
            self.setBackgroundImage(nil, for: UIBarMetrics.default)
            self.shadowImage = nil
            self.isTranslucent = true
            self.tintColor = tintColor
            self.backgroundColor = backgroundColor
            self.barTintColor = forgroundColor
        }
    }
    
    func setTitleColor(color: UIColor) {
        self.titleTextAttributes = [NSAttributedString.Key.font : AppFont.font(type: .Regular, size: 17), NSAttributedString.Key.foregroundColor : color]
    }
}
