//
//  UIExtensions.swift
//  SheekhAqaar
//
//  Created by Hesham Donia on 8/17/19.
//  Copyright © 2019 Hesham Donia. All rights reserved.
//

import Foundation
import UIKit
import Localize_Swift
import Material

class LocalizedLabel: UILabel{
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        if Localize.currentLanguage() == "en" {
            textAlignment = .left
        } else {
            textAlignment = .right
        }
    }
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @IBInspectable
    public var localizeKey: String = "" {
        willSet {
            self.text = newValue.localized()
        }
    }
}

class LocalizedButton: UIButton{
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @IBInspectable
    public var localizeKey: String = "" {
        willSet {
            self.setTitle(newValue.localized(), for: .normal)
        }
    }
}

class LocalizedRaisedButton: RaisedButton{
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @IBInspectable
    public var localizeKey: String = "" {
        willSet {
            self.titleLabel?.text = newValue.localized()
            //            self.setTitle(, for: .normal)
        }
    }
}

class LocalizedTextField: UITextField {
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @IBInspectable
    public var placeholderLocalizeKey: String = "" {
        willSet {
            self.placeholder = newValue.localized()
            //            self.setTitle(, for: .normal)
        }
    }
}

class LocalizedTextView: UITextView {
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @IBInspectable
    public var placeholderLocalizeKey: String = "" {
        willSet {
            self.text = newValue.localized()
        }
    }
}


extension NSMutableAttributedString {
    @discardableResult func bold(_ text:String, _ size:CGFloat) -> NSMutableAttributedString {
        let attrs: [NSAttributedString.Key: Any] = [.font: UIFont.boldSystemFont(ofSize: size), .foregroundColor: UIColor.white]
        let boldString = NSMutableAttributedString(string:text, attributes: attrs)
        append(boldString)
        return self
    }
    
    @discardableResult func normal(_ text: String) -> NSMutableAttributedString {
        let normal = NSAttributedString(string: text)
        append(normal)
        
        return self
    }
}



@IBDesignable
class CardView: UIView {
    
    @IBInspectable var cornerRadius: CGFloat = 12
    @IBInspectable var shadowOffsetWidth: Int = 1
    @IBInspectable var shadowOffsetHeight: Int = 1
    @IBInspectable var shadowOffsetColor: UIColor? = UIColor.black
    @IBInspectable var shadowOpacity: Float = 0.5
    
    
    override func layoutSubviews() {
        layer.cornerRadius = cornerRadius
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        
        layer.masksToBounds = true
        layer.shadowColor = shadowOffsetColor?.cgColor
        layer.shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight);
        layer.shadowOpacity = shadowOpacity
        layer.shadowPath = shadowPath.cgPath
    }
    
}

@IBDesignable
class CircleImageView: UIImageView{
    
    @IBInspectable var cornerRadius: CGFloat = 3.5
    @IBInspectable var shadowOffsetWidth: Int = 0
    @IBInspectable var shadowOffsetHeight: Int = 1//3
    @IBInspectable var shadowOffsetColor: UIColor? = UIColor.black
    @IBInspectable var shadowOpacity: Float = 0.5
    
    override func layoutSubviews() {
        
        layer.cornerRadius = layer.width / 2
        
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: layer.width / 2)
        
        layer.masksToBounds = false
        layer.shadowColor = shadowOffsetColor?.cgColor
        layer.shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight);
        layer.shadowOpacity = shadowOpacity
        layer.shadowPath = shadowPath.cgPath
        self.clipsToBounds = true
    }
}

@IBDesignable
class RoundButton: RaisedButton {
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @IBInspectable
    public var isRounded: Int = 0{
        willSet {
            if newValue == 1{
                self.layer.cornerRadius = self.size.width / 2
                layer.masksToBounds = true
                self.clipsToBounds = true
            }
        }
    }
    
}

extension NSLayoutConstraint {
    func constraintWithMultiplier(_ multiplier: CGFloat) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: self.firstItem, attribute: self.firstAttribute, relatedBy: self.relation, toItem: self.secondItem, attribute: self.secondAttribute, multiplier: multiplier, constant: self.constant)
    }
}
