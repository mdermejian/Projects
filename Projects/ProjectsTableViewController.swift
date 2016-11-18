//
//  ProjectsTableViewController.swift
//  Projects
//
//  Created by Marc Dermejian on 16/11/2016.
//  Copyright © 2016 Marc Dermejian. All rights reserved.
//

import UIKit

class ProjectsTableViewController: UIViewController {

	@IBOutlet weak var tableView: UITableView! {
		didSet {
			tableView.tableFooterView = UIView()
		}
	}
	
	fileprivate var overlay: UIView!
	fileprivate var imageLayer: CALayer!
	fileprivate var animation: CABasicAnimation!
	fileprivate var selectedCellFrame: CGRect?
	fileprivate var selectedProject: Project?
	fileprivate var projects = [Project]() {
		didSet {
			DispatchQueue.main.async {
				self.tableView.reloadData()
			}
		}
	}

	fileprivate struct Keys {
		static let CellReuseIdentifier: String = "ProjectCell"
		static let DecreaseAnimationDuration: CFTimeInterval = 0.35
		static let IncreaseAnimationDuration: CFTimeInterval = 0.45
		static let ProjectViewSegueIdentifier: String = "showProject"
	}

    override func viewDidLoad() {
        super.viewDidLoad()
		
		setupOverlay()
		
		ProjectsController.getAllProjects { (success, projects) in
			if let projects = projects { self.projects = projects }
			DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
				self.animateDecreaseSize()
			}
		}
    }
	
	private func setupOverlay() {
		overlay = UIView()
		overlay.frame = view.frame
		overlay.alpha = 1
		overlay.backgroundColor = UIColor(red: 56/255, green: 83/255, blue: 93/255, alpha: 1.0)
		UIApplication.shared.keyWindow?.addSubview(overlay)
		
		let image = UIImage(named: "teamwork_large")!
		
		imageLayer = CALayer()
		imageLayer.contents = image.cgImage
		imageLayer.bounds = CGRect(x: 0, y: 0, width: 100, height: 100)
		imageLayer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
		imageLayer.position = CGPoint(x: view.frame.width / 2, y: view.frame.height / 2)
		
		overlay.layer.addSublayer(imageLayer)
	}

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == Keys.ProjectViewSegueIdentifier {
			if let destinationVC = segue.destination as? ProjectViewController {
				destinationVC.project = selectedProject
			}
		}
	}
}

extension ProjectsTableViewController: UITableViewDelegate, UITableViewDataSource {

	// MARK: - Table view data source
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return projects.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cell = tableView.dequeueReusableCell(withIdentifier: Keys.CellReuseIdentifier, for: indexPath) as! ProjectCell
		cell.project = projects[indexPath.row]
		return cell
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		selectedProject = projects[indexPath.row]
		performSegue(withIdentifier: "showProject", sender: nil)
		
		/*
		// get the frame of the cell
		selectedCellFrame = tableView.convert(tableView.rectForRow(at: indexPath), to: view)
		
		// present the project detail view controller
		let detailVC = ProjectViewController()
		detailVC.transitioningDelegate = self
		detailVC.modalPresentationStyle = .custom
		detailVC.view.backgroundColor = UIColor.purple
		present(detailVC, animated: true, completion: nil)
		*/
	}
	
}

extension ProjectsTableViewController: CAAnimationDelegate {
	
	func animateDecreaseSize () {
		
		//Start by decreasing size
		let decreaseSizeAnimation = CABasicAnimation(keyPath: "bounds")
		decreaseSizeAnimation.delegate = self
		decreaseSizeAnimation.duration = Keys.DecreaseAnimationDuration
		decreaseSizeAnimation.fromValue = NSValue(cgRect: imageLayer!.bounds)
		decreaseSizeAnimation.toValue = NSValue(cgRect: CGRect(x: 0, y: 0, width: 80, height: 80))
		
		decreaseSizeAnimation.fillMode = kCAFillModeForwards
		decreaseSizeAnimation.isRemovedOnCompletion = false
		
		imageLayer.add(decreaseSizeAnimation, forKey: "bounds")
		
	}
	
	func animateIncreaseSize() {
		
		animation = CABasicAnimation(keyPath: "bounds")
		animation.duration = Keys.IncreaseAnimationDuration
		animation.fromValue = NSValue(cgRect: imageLayer!.bounds)
		animation.toValue = NSValue(cgRect: CGRect(x: 0, y: 0, width: 1000, height: 1000))
		
		animation.fillMode = kCAFillModeForwards
		animation.isRemovedOnCompletion = false
		
		imageLayer.add(animation, forKey: "bounds")
		
		UIView.animate(withDuration: Keys.IncreaseAnimationDuration, animations: {
			self.overlay.alpha = 0
		}) { _ in
			self.imageLayer.removeFromSuperlayer()
			self.overlay.removeFromSuperview()
			self.imageLayer = nil
			self.overlay = nil
		}
	}

	func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
		animateIncreaseSize()
	}
}


extension ProjectsTableViewController: UIViewControllerTransitioningDelegate {
	
	func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		
		guard let selectedCellFrame = selectedCellFrame else { return nil }
		
		let presentationAnimator = ExpandAnimator.animator
		presentationAnimator.openingFrame = selectedCellFrame
		presentationAnimator.transitionMode = .present
		return presentationAnimator
	}
	
	func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		
		return nil
		
		guard let selectedCellFrame = selectedCellFrame else { return nil }
		
		let presentationAnimator = ExpandAnimator.animator
		presentationAnimator.openingFrame = selectedCellFrame
		presentationAnimator.transitionMode = .dismiss
		return presentationAnimator

	}
	
}






