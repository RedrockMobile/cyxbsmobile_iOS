//
//  PopAnimation.swift
//  CyxbsMobile2019_iOS
//
//  Created by Max Xu on 2024/4/9.
//  Copyright © 2024 Redrock. All rights reserved.
//

import UIKit

class PopAnimation: NSObject, UIViewControllerAnimatedTransitioning {
    
    // 设置动画执行的时长
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.2
    }
    
    // 处理具体的动画
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from),
              let toVC = transitionContext.viewController(forKey: .to) else {
            return
        }
        
        let containerView = transitionContext.containerView
        containerView.insertSubview(toVC.view, belowSubview: fromVC.view)
        
        let duration = transitionDuration(using: transitionContext)
        let screenWidth = fromVC.view.width
        
        UIView.animate(withDuration: duration, delay: 0, options: .curveLinear, animations: {
            fromVC.view.frame = CGRectMake(screenWidth, fromVC.view.frame.minY, fromVC.view.bounds.width, fromVC.view.bounds.height)
        }) { (finished) in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}

