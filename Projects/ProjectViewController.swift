//
//  ProjectViewController.swift
//  Projects
//
//  Created by Marc Dermejian on 17/11/2016.
//  Copyright © 2016 Marc Dermejian. All rights reserved.
//

import UIKit

class ProjectViewController: UIViewController {

	var project: Project?
	
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var descriptionLabel: UILabel!
	@IBOutlet weak var companyNameLabel: UILabel!
	@IBOutlet weak var creationDateLabel: UILabel!
	@IBOutlet weak var starredView: StarShapeView!
	@IBOutlet weak var statusImageView: UIImageView!
	@IBOutlet weak var statusLabel: UILabel!
	@IBOutlet weak var subStatusImageView: UIImageView!
	@IBOutlet weak var subStatusLabel: UILabel!
	@IBOutlet weak var logoImageView: UIImageView!{
		didSet {
			
			logoImageView.layer.cornerRadius = 15.0
			logoImageView.layer.borderWidth = 0.6
			logoImageView.layer.borderColor = Utility.lightGray.cgColor
			logoImageView.layer.masksToBounds = true
			
		}
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		updateUI()
    }
	
	private func updateUI() {
		guard let project = project else { return }
		
		let placeholderImage = project.defaultProjectImage
		if let url = project.logoURL {
			logoImageView.af_setImage(withURL: url,
			                          placeholderImage: placeholderImage,
			                          filter: nil,
			                          progress: nil,
			                          progressQueue: DispatchQueue.global(qos: DispatchQoS.QoSClass.background),
			                          imageTransition: .crossDissolve(0.1),
			                          runImageTransitionIfCached: false,
			                          completion: nil)
		}else {
			logoImageView.image = placeholderImage
		}
		
		nameLabel.text = project.name
		descriptionLabel.text = project.projectDescription
		companyNameLabel.text = project.companyName
		
		creationDateLabel.text = project.creationDate != nil ? "created \((project.creationDate! as NSDate).timeAgoSinceNow()!)" : ""
		
		statusImageView.image = project.status.image
		statusLabel.text = project.status.description
		subStatusImageView.image = project.substatus.image
		subStatusLabel.text = project.substatus.description
		starredView.isEnabled = project.starred

	}
	
}
