//
//  DimmingPresentationController.swift
//  StoreSearch
//
//  Created by Nguyen Minh Tam on 04/03/2022.
//

import UIKit

class DimmingPresentationController: UIPresentationController {
    //MARK: Properties
    lazy var dimingView = GradientView(frame: .zero)
    
    
    //MARK: View cycle
    override var shouldRemovePresentersView: Bool {
        
    return false
        
    }
    
    override func presentationTransitionWillBegin() {
        
        dimingView.frame = containerView!.bounds
        containerView!.insertSubview(dimingView, at: 0)
        
        dimingView.alpha = 0
        
        if let coordinator = presentedViewController.transitionCoordinator {
            
            coordinator.animate(alongsideTransition: { _ in
                
                self.dimingView.alpha = 1
                
            }, completion: nil)
            
        }
        
    }
    
    override func dismissalTransitionWillBegin() {
        
        if let coordinator = presentedViewController.transitionCoordinator {
            
            coordinator.animate(alongsideTransition: { _ in
                
                self.dimingView.alpha = 0
                
            }, completion: nil)
            
        }
        
    }

}
