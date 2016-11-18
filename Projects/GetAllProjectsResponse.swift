//
//  GetAllProjectsResponse.swift
//  Projects
//
//  Created by Marc Dermejian on 15/11/2016.
//  Copyright © 2016 Marc Dermejian. All rights reserved.
//

import Foundation
import SwiftCommons

final class GetAllProjectsResponse: ResponseObjectSerializable, CustomStringConvertible {
	
	var projects: [Project] = []
	
	fileprivate typealias Fields = GetAllProjectsResponseFields

	// MARK: ResponseObjectSerializable
	public init?(response: HTTPURLResponse, representation: Any) {
		
		guard let representation = representation as? [String: AnyObject]
			else { return nil }
		
		guard let status = representation[Fields.Status.rawValue] as? String, status == "OK"
			else { return nil }
		
		projects.removeAll()
		
		if let allProjectsRepresentation = representation[Fields.Projects.rawValue] as? [[String:AnyObject]] {
			for projectRepresentation in allProjectsRepresentation {
				if let project = Project(response: response, representation: projectRepresentation as AnyObject) {
					projects.append(project)
				}
			}
		}
	}
}

fileprivate enum GetAllProjectsResponseFields: String {
	case Status = "STATUS"
	case Projects = "projects"
}
