//
//  Traceable.swift
//  Vettr
//
//  Created by Steven Schwab on 11/2/22.
//

import UIKit

protocol Traceable {
    var cornerRadius: CGFloat { get set }
    var borderColor: UIColor? { get set }
    var borderWidth: CGFloat { get set }
}

extension UIView: Traceable {

    @IBInspectable var cornerRadius: CGFloat {
        get { return layer.cornerRadius }
        set {
            layer.masksToBounds = true
            layer.cornerRadius = newValue
        }
    }

    @IBInspectable var borderColor: UIColor? {
        get {
            guard let cgColor = layer.borderColor else { return nil }
            return  UIColor(cgColor: cgColor)
        }
        set { layer.borderColor = newValue?.cgColor }
    }

    @IBInspectable var borderWidth: CGFloat {
        get { return layer.borderWidth }
        set { layer.borderWidth = newValue }
    }
}
