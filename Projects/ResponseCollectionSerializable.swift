//
//  ResponseCollectionSerializable.swift
//  Projects
//
//  Created by Marc Dermejian on 14/11/2016.
//  Copyright © 2016 Marc Dermejian. All rights reserved.
//

import Foundation
import Alamofire

protocol ResponseCollectionSerializable {
	static func collection(from response: HTTPURLResponse, withRepresentation representation: Any) -> [Self]
}

extension ResponseCollectionSerializable where Self: ResponseObjectSerializable {
	static func collection(from response: HTTPURLResponse, withRepresentation representation: Any) -> [Self] {
		var collection: [Self] = []
		
		if let representation = representation as? [[String: Any]] {
			for itemRepresentation in representation {
				if let item = Self(response: response, representation: itemRepresentation) {
					collection.append(item)
				}
			}
		}
		
		return collection
	}
}

extension DataRequest {
	@discardableResult
	func responseCollection<T: ResponseCollectionSerializable>(
		queue: DispatchQueue? = nil,
		completionHandler: @escaping (DataResponse<[T]>) -> Void) -> Self
	{
		let responseSerializer = DataResponseSerializer<[T]> { request, response, data, error in
			guard error == nil else { return .failure(TWError.network(error: error!)) }
			
			let jsonSerializer = DataRequest.jsonResponseSerializer(options: .allowFragments)
			let result = jsonSerializer.serializeResponse(request, response, data, nil)
			
			guard case let .success(jsonObject) = result else {
				return .failure(TWError.jsonSerialization(error: result.error!))
			}
			
			guard let response = response else {
				let reason = "Response collection could not be serialized due to nil response."
				return .failure(TWError.objectSerialization(reason: reason))
			}
			
			return .success(T.collection(from: response, withRepresentation: jsonObject))
		}
		
		return response(responseSerializer: responseSerializer, completionHandler: completionHandler)
	}
}
