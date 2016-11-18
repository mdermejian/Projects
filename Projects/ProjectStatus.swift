//
//  ProjectStatus.swift
//  Projects
//
//  Created by Marc Dermejian on 14/11/2016.
//  Copyright © 2016 Marc Dermejian. All rights reserved.
//

import UIKit

enum ProjectStatus: String, CustomStringConvertible {

	case active = "active"
	case archived = "archived"
	case current = "current"
	case late = "late"
	case completed = "completed"
	case undefined = "undefined"
	
	var description: String {
		switch self {
		case .active: return "Project is Active"
		case .archived: return "Project has been Archived"
		case .current: return "Project is Current"
		case .late: return "Project is Late!"
		case .completed: return "Project is Completed"
		case .undefined: return "Project status is Undefined"
		}
	}
	
	var image: UIImage? {
		switch self {
		case .active: return UIImage(named: "active")
		case .completed: return UIImage(named: "completed")
		case .archived: return UIImage(named: "archived")
		case .late: return UIImage(named: "late")
		case .current: return UIImage(named: "current")
		default: return nil
		}
	}

}
