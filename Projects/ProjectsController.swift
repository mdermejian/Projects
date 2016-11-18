//
//  ProjectsController.swift
//  Projects
//
//  Created by Marc Dermejian on 14/11/2016.
//  Copyright © 2016 Marc Dermejian. All rights reserved.
//

import Foundation
import Alamofire

class ProjectsController {
	
	static func getAllProjects(completion: @escaping ((_ success: Bool, _ projects: [Project]?) -> Void)) {
		let request = RestCommandBuilder.GetAllProjects
		Alamofire.request(request)
			.validate()
			.responseObject(completionHandler: { (response: DataResponse<GetAllProjectsResponse>) in
				debugPrint(response)
				completion(response.result.isSuccess, response.result.value?.projects)
			})
	}
}
