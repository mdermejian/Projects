//
//  ProjectCell.swift
//  Projects
//
//  Created by Marc Dermejian on 16/11/2016.
//  Copyright © 2016 Marc Dermejian. All rights reserved.
//

import UIKit
import DateTools
import AlamofireImage

class ProjectCell: UITableViewCell {

	var project: Project? {
		didSet {
			updateUI()
		}
	}
	
	@IBOutlet weak var logoImageView: UIImageView!{
		didSet {
			
			logoImageView.layer.cornerRadius = 15.0
			logoImageView.layer.borderWidth = 0.6
			logoImageView.layer.borderColor = Utility.lightGray.cgColor
			logoImageView.layer.masksToBounds = true
			
		}
	}
	
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var creationDateLabel: UILabel!
	@IBOutlet weak var starredView: StarShapeView!
	@IBOutlet weak var statusImageView: UIImageView!
	@IBOutlet weak var subStatusImageView: UIImageView!
	
	private func updateUI () {
		
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
		creationDateLabel.text = project.creationDate != nil ? "\((project.creationDate! as NSDate).timeAgoSinceNow()!)" : ""
		statusImageView.image = project.status.image
		subStatusImageView.image = project.substatus.image

		starredView.isEnabled = project.starred

	}
	
	
}
