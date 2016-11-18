//
//  Project.swift
//  Projects
//
//  Created by Marc Dermejian on 14/11/2016.
//  Copyright © 2016 Marc Dermejian. All rights reserved.
//

import Foundation
import SwiftCommons
import Commons

final class Project: CustomStringConvertible {
	
	// MARK: stored properties

	var id: String?
	var name: String?
	var companyName: String?
	var projectDescription: String?
	var starred: Bool = false
	var logo: String?
	var creationDate: Date?
	var startDate: Date?
	var endDate: Date?
	var status: ProjectStatus = .undefined
	var substatus: ProjectSubStatus = .undefined
	
	
	// MARK: computed properties
	
	var logoURL: URL? {
		//Returns nil if a URL cannot be formed with the string (for example, if the string contains characters that are illegal in a URL, or is an empty string)
		//or if the logo string is empty
		if logo != nil {
			return URL(string: logo!)
		}
		return nil
	}
	
	var defaultProjectImage: UIImage {
		return UIImage(named: "teamwork")!
	}

	// MARK: - ResponseObjectSerializable protocol implementation

	fileprivate typealias Fields = ProjectKey
	fileprivate typealias Value = AnyObject

	public init?(response: HTTPURLResponse, representation: Any) {
		
		guard let representation = representation as? [String: AnyObject] else { return nil }
		
		if let id = representation[Fields.ID.rawValue] as? String { self.id = id }
		if let name = representation[Fields.Name.rawValue] as? String { self.name = name }
		if let companyObject = representation[Fields.Company.rawValue] as? [String: AnyObject] {
			if let companyName = companyObject[Fields.Name.rawValue] as? String { self.companyName = companyName }
		}
		if let projectDescription = representation[Fields.Description.rawValue] as? String { self.projectDescription = projectDescription }
		if let starred = representation[Fields.Starred.rawValue] as? Bool { self.starred = starred }
		if let logo = representation[Fields.Logo.rawValue] as? String { self.logo = logo }
		
		if let creationDate = representation[Fields.CreatedOn.rawValue] as? String { self.creationDate = NSDate(fromRFC3339String: creationDate) as Date }
		
		let formatter = DateFormatter.internetDateTime()
		formatter?.dateFormat = "yyyyMMdd"
		if let startDate = representation[Fields.StartDate.rawValue] as? String { self.startDate = formatter?.date(from: startDate) }
		if let endDate = representation[Fields.EndDate.rawValue] as? String { self.endDate = formatter?.date(from: endDate) }
		if let status = representation[Fields.Status.rawValue] as? String { self.status = ProjectStatus(rawValue: status)! }
		if let substatus = representation[Fields.Substatus.rawValue] as? String { self.substatus = ProjectSubStatus(rawValue: substatus)! }

	}
}

/*
// MARK: - ResponseCollectionSerializable protocol implementation

extension Project: ResponseCollectionSerializable {
	
	static func collection(from response: HTTPURLResponse, withRepresentation representation: Any) -> [Project] {
		var projects: [Project] = []
		
		if let representation = representation as? [[String: AnyObject]] {
			for projectRepresentation in representation {
				if let project = Project(response: response, representation: projectRepresentation as [String: AnyObject]) {
					projects.append(project)
				}
			}
		}
		
		return projects
	}

}
*/

// MARK: - Comparable protocol implementation

extension Project: Comparable {}

func == (lhs: Project, rhs: Project) -> Bool {
	guard let lhs_id = lhs.id, let rhs_id = rhs.id else {
		return false
	}
	return lhs_id == rhs_id
}

func < (lhs: Project, rhs: Project) -> Bool {
	
	guard lhs.creationDate != nil && rhs.creationDate != nil else {
		return false
	}
	
	if lhs.creationDate!.compare(rhs.creationDate!) == .orderedAscending {
		return true
	}
	return false
}

// MARK: - API Keys
public enum ProjectKey: String {
	case ID				= "id"
	case Starred		= "starred"
	case Status			= "status"
	case Substatus		= "subStatus"
	case CreatedOn		= "created-on"
	case StartDate		= "startDate"
	case EndDate		= "endDate"
	case Logo			= "logo"
	case Name			= "name"
	case Company		= "company"
	case Description	= "description"
}
