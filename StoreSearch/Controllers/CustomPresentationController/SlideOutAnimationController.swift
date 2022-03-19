//
//  BounceAnimationController.swift
//  StoreSearch
//
//  Created by Nguyen Minh Tam on 05/03/2022.
//

import UIKit

class SlideOutAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        
        return 0.4
        
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
//        if let fromView = transitionContext.view(
//          forKey: UITransitionContextViewKey.from) {
//          let containerView = transitionContext.containerView
//          let time = transitionDuration(using: transitionContext)
//          UIView.animate(
//            withDuration: time,
//            animations: {
//              fromView.center.y -= containerView.bounds.size.height
//              fromView.transform = CGAffineTransform(
//                scaleX: 0.5, y: 0.5)
//            }, completion: { finished in
//              transitionContext.completeTransition(finished)
//            }
//          )
//        }
        
        if let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to),
           let toView = transitionContext.view(forKey: UITransitionContextViewKey.to) {
            
            let containerView = transitionContext.containerView
            
            toView.frame = transitionContext.finalFrame(for:toViewController)
            containerView.addSubview(toView)
            toView.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
            
            UIView.animateKeyframes(
                withDuration: transitionDuration(using: transitionContext),
                delay: 0, animations: {
                
                UIView.addKeyframe(withRelativeStartTime: 0.0,
                                   relativeDuration: 0.3, animations: {
                    
                    toView.transform = CGAffineTransform(scaleX: 1.2,
                                                         y: 1.2)
                })
                
                UIView.addKeyframe(withRelativeStartTime: 0.3,
                                   relativeDuration: 0.3, animations: {
                    
                    toView.transform = CGAffineTransform(scaleX: 0.9,
                                                         y: 0.9)
                })
                
                UIView.addKeyframe(withRelativeStartTime: 0.6,
                                   relativeDuration: 0.3, animations: {
                    
                    toView.transform = CGAffineTransform(scaleX: 1.0,
                                                         y: 1.0)
                })
                
            }, completion: { (finished) in
                
                transitionContext.completeTransition(finished)
                
            })
        }
    }
    
    
}
