//
//  ExpandAnimator.swift
//  Projects
//
//  Created by Marc Dermejian on 17/11/2016.
//  Copyright © 2016 Marc Dermejian. All rights reserved.
//

import UIKit


class ExpandAnimator: NSObject, UIViewControllerAnimatedTransitioning {
	
	static var animator = ExpandAnimator()
	
	enum ExpandTransitionMode: Int {
		case present
		case dismiss
	}
	
	let presentDuration = 2.4
	let dismissDuration = 2.15
	
	var openingFrame: CGRect?
	var transitionMode: ExpandTransitionMode = .present
	
	var topView: UIView!
	var bottomView: UIView!
	
	func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
		switch transitionMode {
		case .present: return presentDuration
		case .dismiss: return dismissDuration
		}
	}
	
	func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
		// From VC
		guard let fromViewController = transitionContext.viewController(forKey: .from),
		let fromViewFrame = transitionContext.viewController(forKey: .from)?.view.frame,
		let openingFrame = openingFrame else {
			returngith
		}
		
		// To VC
		guard let toViewController = transitionContext.viewController(forKey: .to) else {
			return
		}

		// Container view
		let containerView = transitionContext.containerView
		
		switch transitionMode {
		case .present:
			
			// Top view
			topView = fromViewController.view.resizableSnapshotView(from: fromViewFrame, afterScreenUpdates: true, withCapInsets: UIEdgeInsets(top: openingFrame.origin.y, left: 0, bottom: 0, right: 0))
			topView.frame = CGRect(x: 0, y: 0, width: fromViewFrame.width, height: openingFrame.origin.y)
			
			// Add top view to container
			containerView.addSubview(topView)
			
			// Bottom view
			bottomView = fromViewController.view.resizableSnapshotView(from: fromViewFrame, afterScreenUpdates: true, withCapInsets: UIEdgeInsets(top: 0, left: 0, bottom: fromViewFrame.height - openingFrame.origin.y - openingFrame.height, right: 0))
			bottomView.frame = CGRect(x: 0, y: openingFrame.origin.y + openingFrame.height, width: fromViewFrame.width, height: fromViewFrame.height - openingFrame.origin.y - openingFrame.height)
			
			// add bottom view to container
			containerView.addSubview(bottomView)
			
			// Take a snapshot of the toViewController and change its frame to opening frame
			let snapshotView = toViewController.view.resizableSnapshotView(from: fromViewFrame, afterScreenUpdates: true, withCapInsets: UIEdgeInsets.zero)
			snapshotView!.frame = openingFrame
			containerView.addSubview(snapshotView!)
			
			toViewController.view.alpha = 0.0
			containerView.addSubview(toViewController.view)
			
			UIView.animate(withDuration: presentDuration, animations: {
				// move top & bottom views out of the screen
				self.topView.frame = CGRect(x: 0, y: -self.topView.frame.height, width: self.topView.frame.width, height: self.topView.frame.height)
				self.bottomView.frame = CGRect(x: 0, y: fromViewFrame.height, width: self.bottomView.frame.width, height: self.bottomView.frame.height)
				
				// expand snapshot view to fill entire frame
				snapshotView!.frame = toViewController.view.frame
			}, completion: { finished in
				
				// remove snapshot
				snapshotView!.removeFromSuperview()
				
				toViewController.view.alpha = 1.0
				
				// complete the transition
				transitionContext.completeTransition(finished)
				
			})
			
			
			
			
			
			
			
			
			
			
			
		case .dismiss: break
		}
	}
	
	
}
