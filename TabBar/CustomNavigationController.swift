//
//  CustomNavigationController.swift
//  CyxbsMobile2019_iOS
//
//  Created by Max Xu on 2024/4/8.
//  Copyright © 2024 Redrock. All rights reserved.
//

import UIKit

class CustomNavigationController: UINavigationController, UINavigationControllerDelegate, UIGestureRecognizerDelegate {

    var popDelegate: UIGestureRecognizerDelegate?
    var edgePan: UIScreenEdgePanGestureRecognizer?
    var interactiveTransition:UIPercentDrivenInteractiveTransition?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.isNavigationBarHidden = true
        self.interactivePopGestureRecognizer?.isEnabled = false
        self.delegate = self
        edgePan = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handlePan(_: )))
        edgePan?.edges = .left
        if let pan = edgePan {
            view.addGestureRecognizer(pan)
        }
    }
    
    @objc func handlePan(_ pan: UIPanGestureRecognizer) {
        switch pan.state {
        case .began:
            // 检查是否已经回到根视图控制器
            if topViewController == viewControllers.first {
                // 已经是根视图控制器，不执行返回操作，直接结束交互式转场
                interactiveTransition?.cancel()
                interactiveTransition = nil
            } else {
                // 开始新的交互式转场
                interactiveTransition = UIPercentDrivenInteractiveTransition()
                popViewController(animated: true)
            }
        case .changed:
            if let interactiveTransition = interactiveTransition {
                interactiveTransition.update(pan.translation(in: view).x / view.width)
            }
        case .ended, .cancelled:
            if let interactiveTransition = interactiveTransition {
                if pan.translation(in: view).x / view.width > 0.4 || pan.velocity(in: view).x > 300 {
                    interactiveTransition.finish()
                } else {
                    interactiveTransition.cancel()
                }
                self.interactiveTransition = nil
            }
        default:
            break
        }
    }

    
    // MARK: - UINavigationControllerDelegate
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> (any UIViewControllerAnimatedTransitioning)? {
        if operation == .pop {
            return PopAnimation()
        }
        return nil
    }
    
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: any UIViewControllerAnimatedTransitioning) -> (any UIViewControllerInteractiveTransitioning)? {
        if animationController is PopAnimation {
            return interactiveTransition
        }
        return nil
    }
    
}

