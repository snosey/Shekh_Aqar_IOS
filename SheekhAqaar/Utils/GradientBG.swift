//
//  GradientBG.swift
//  SheekhAqaar
//
//  Created by Hesham Donia on 8/18/19.
//  Copyright © 2019 Hesham Donia. All rights reserved.
//

import Foundation
import UIKit

class GradientBG {
    
    public class func createGradientLayer(view: UIView, cornerRaduis: CGFloat, maskToBounds: Bool) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [UIColor.AppColors.start.cgColor, UIColor.AppColors.center.cgColor, UIColor.AppColors.end.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        view.layer.addSublayer(gradientLayer)
        view.layer.masksToBounds = maskToBounds
        view.layer.cornerRadius = cornerRaduis
    }
}
