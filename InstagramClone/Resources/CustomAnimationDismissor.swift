//
//  CustomAnimationDismisser.swift
//  InstagramClone
//
//  Created by Wesley Osborne on 6/17/21.
//

import UIKit

class CustomAnimationDissmisor: NSObject, UIViewControllerAnimatedTransitioning {
  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return 0.5
  }
  
  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    
    let containerView = transitionContext.containerView
    guard let fromView = transitionContext.view(forKey: .from) else { return }
    guard let toView = transitionContext.view(forKey: .to) else { return }
    containerView.addSubview(toView)
    
    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut) {
      
      fromView.frame = CGRect(x: -fromView.frame.width, y: 0, width: fromView.frame.width, height: fromView.frame.height)
      
      toView.frame = CGRect(x: 0, y: 0, width: toView.frame.width, height: toView.frame.height)
      
    } completion: { _ in
      transitionContext.completeTransition(true)
    }
  }
}
