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
    
    var gradientLayer:CAGradientLayer!
    var view: UIView!
    
    func createGradientLayer() {
        
        let colorTop = UIColor.AppColors.start
        let colorBottom = UIColor.AppColors.end
        
        gradientLayer = CAGradientLayer()
        
        gradientLayer.frame = self.view.bounds
        
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        self.view.layer.addSublayer(gradientLayer)
    }
    
//    init() {
//        let colorTop = UIColor.AppColors.start
//        let colorBottom = UIColor.AppColors.end
//
//        self.gl = CAGradientLayer()
//        self.gl.colors = [colorTop, colorBottom]
//        self.gl.locations = [0.0, 1.0]
//        self.gl.startPoint = CGPoint(x: 0.0, y: 1.0)
//        self.gl.endPoint = CGPoint(x: 1.0, y: 1.0)
//    }
}
