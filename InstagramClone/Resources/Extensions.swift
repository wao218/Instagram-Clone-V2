//
//  Extensions.swift
//  InstagramClone
//
//  Created by Wesley Osborne on 5/18/21.
//

import UIKit

extension UIColor {
  
  static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
    return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
  }
  
}

extension UIView {
  
  func fillSuperview() {
    anchor(top: superview?.topAnchor, leading: superview?.leadingAnchor, bottom: superview?.bottomAnchor, trailing: superview?.trailingAnchor, centerX: nil, centerY: nil)
  }
  
  func anchorSize(to view: UIView) {
    widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
    heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
  }
  
  func anchor(top: NSLayoutYAxisAnchor?, leading: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, trailing: NSLayoutXAxisAnchor?, centerX: NSLayoutXAxisAnchor? = nil, centerY: NSLayoutYAxisAnchor? = nil, padding: UIEdgeInsets = .zero, size: CGSize = .zero) {
    
    translatesAutoresizingMaskIntoConstraints = false
    
    if let top = top {
      topAnchor.constraint(equalTo: top, constant: padding.top).isActive = true
    }
    
    if let leading = leading {
      leadingAnchor.constraint(equalTo: leading, constant: padding.left).isActive = true
    }
    
    if let bottom = bottom {
      bottomAnchor.constraint(equalTo: bottom, constant: -padding.bottom).isActive = true
    }
    
    if let trailing = trailing {
      trailingAnchor.constraint(equalTo: trailing, constant: -padding.right).isActive = true
    }
    
    if let centerX = centerX {
      centerXAnchor.constraint(equalTo: centerX).isActive = true
    }
    
    if let centerY = centerY {
      centerYAnchor.constraint(equalTo: centerY).isActive = true
    }
    
    
    if size.width != 0 {
      widthAnchor.constraint(equalToConstant: size.width).isActive = true
    }
    
    if size.height != 0 {
      heightAnchor.constraint(equalToConstant: size.height).isActive = true
    }
    
  }
}

