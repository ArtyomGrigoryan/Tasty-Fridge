//
//  TransitionManager.swift
//  Tasty Fridge!
//
//  Created by Артем Григорян on 21/04/2019.
//  Copyright © 2019 Artyom Grigoryan. All rights reserved.
//

import UIKit

class TransitionManager: NSObject, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.8
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        var transform = CATransform3DIdentity

        let container = transitionContext.containerView
        
        guard let fromView = transitionContext.view(forKey: .from) else { return }
        guard let toView = transitionContext.view(forKey: .to) else { return }
        
        transform.m34 = -0.0019
        container.layer.sublayerTransform = transform
        container.insertSubview(toView, belowSubview: fromView)
        fromView.layer.anchorPoint = CGPoint(x: 0.0, y: 0.5)
        fromView.layer.position    = CGPoint(x: 0, y: UIScreen.main.bounds.midY)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0.0, options: .curveEaseInOut, animations: {
            fromView.layer.transform = CATransform3DMakeRotation(-.pi/2, 0, 1.0, 0)
        }) { (_) in
            transitionContext.completeTransition(true)
        }
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
}
