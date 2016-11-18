//
//  RestCommandBuilder.swift
//  Projects
//
//  Created by Marc Dermejian on 14/11/2016.
//  Copyright © 2016 Marc Dermejian. All rights reserved.
//

import Foundation
import Alamofire

enum RestCommandBuilder: URLRequestConvertible {
	
	case GetAllProjects
	case GetImage(String) //image ID

	private struct Constants {
		static let baseURLPath = "https://yat.teamwork.com"
		static let timeoutInterval = TimeInterval(60 * 0.5) //30 seconds
		static let username = "april294unreal"
		static let password = "xxx"
	}
	
	var method: HTTPMethod {
		switch self {
		case .GetAllProjects: return .get
		case .GetImage: return .get
		}
	}
	
	var path: String {
		switch self {
		case .GetAllProjects:
			return ("/projects.json")
		case .GetImage(let imageID):
			return "assets/\(imageID)"
		}
	}
	
	var port: NSNumber {
		return 8443
	}
	
	var defaultHeaders: [String : AnyObject]? {
		return nil
	}
	
	// MARK: URLRequestConvertible
	
	func asURLRequest() throws -> URLRequest {
		let baseURL = try Constants.baseURLPath.asURL()
		var urlRequest = URLRequest(url: baseURL.appendingPathComponent(path))
		urlRequest.httpMethod = method.rawValue
		urlRequest.timeoutInterval = Constants.timeoutInterval
		
		urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
		
		if let data = "\(Constants.username):\(Constants.password)".data(using: .utf8) {
			let credential = data.base64EncodedString(options: [])
			urlRequest.setValue("Basic \(credential)", forHTTPHeaderField: "Authorization")
		}
		
		switch self {
			
		case .GetAllProjects:
//			return urlRequest
			return try URLEncoding.default.encode(urlRequest, with: ["status" : "ALL"])
		case .GetImage(_):
			return urlRequest
		}
	}
}
