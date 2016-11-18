//
//  ProjectSubStatus.swift
//  Projects
//
//  Created by Marc Dermejian on 14/11/2016.
//  Copyright © 2016 Marc Dermejian. All rights reserved.
//

import UIKit

enum ProjectSubStatus: String, CustomStringConvertible {
	
	case late = "late"
	case current = "current"
	case undefined = "undefined"
	
	var description: String {
		switch self {
		case .late: return "Project is Late!"
		case .current: return "Project is Current"
		case .undefined: return "Project status is Undefined"
		}
	}
	
	var image: UIImage? {
		switch self {
		case .late: return UIImage(named: "late")
		case .current: return UIImage(named: "current")
		default: return nil
		}
	}
}
