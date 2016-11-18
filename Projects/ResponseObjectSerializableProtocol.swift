//
//  ResponseObjectSerializableProtocol.swift
//  Projects
//
//  Created by Marc Dermejian on 14/11/2016.
//  Copyright © 2016 Marc Dermejian. All rights reserved.
//

import Foundation

import Alamofire

protocol ResponseObjectSerializable {
	init?(response: HTTPURLResponse, representation: Any)
}

extension DataRequest {
	
	@discardableResult
	func responseObject<T: ResponseObjectSerializable>(
		queue: DispatchQueue? = nil,
		completionHandler: @escaping (DataResponse<T>) -> Void)
		-> Self
	{
		let responseSerializer = DataResponseSerializer<T> { request, response, data, error in
			guard error == nil else { return .failure(TWError.network(error: error!)) }
			
			let jsonResponseSerializer = DataRequest.jsonResponseSerializer(options: .allowFragments)
			let result = jsonResponseSerializer.serializeResponse(request, response, data, nil)
			
			guard case let .success(jsonObject) = result
			else {
				return .failure(TWError.jsonSerialization(error: result.error!))
			}
			
			guard let response = response, let responseObject = T(response: response, representation: jsonObject) else {
				return .failure(TWError.objectSerialization(reason: "JSON could not be serialized: \(jsonObject)"))
			}
			
			return .success(responseObject)
		}
		
		return response(queue: queue, responseSerializer: responseSerializer, completionHandler: completionHandler)
	}
}
