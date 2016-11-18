//
//  ProjectsTests.swift
//  ProjectsTests
//
//  Created by Marc Dermejian on 14/11/2016.
//  Copyright © 2016 Marc Dermejian. All rights reserved.
//

import XCTest
import Commons
@testable import Projects

class ProjectsTests: XCTestCase {
	
	var emptyProject: [String: AnyObject] = [:]
	let dummyResponse = HTTPURLResponse()
	
    override func tearDown() {
        super.tearDown()
		emptyProject = [:]
    }
	
	func testConstructorReturnsNonNil() {
		
		let project = Project(response: dummyResponse, representation: emptyProject)
		XCTAssertNotNil(project, "project should not be nil")
		
	}
	
	func testDefaults() {
		
		guard let project = Project(response: dummyResponse, representation: emptyProject) else {
			XCTFail("guard statement failed")
			return
		}
		
		XCTAssert(project.starred == false, "project.starred should be false")
		XCTAssert(project.status == .undefined, "project.status should be .undefined")
		XCTAssert(project.substatus == .undefined, "project.substatus should be .undefined")
	}
	
	func testPropertiesAreNil() {
		
		let project = Project(response: dummyResponse, representation: emptyProject)
		
		XCTAssertNil(project!.id, "uninitialized optional property should be nil")
		XCTAssertNil(project!.name, "uninitialized optional property should be nil")
		XCTAssertNil(project!.companyName, "uninitialized optional property should be nil")
		XCTAssertNil(project!.projectDescription, "uninitialized optional property should be nil")
		XCTAssertNil(project!.logo, "uninitialized optional property should be nil")
		XCTAssertNil(project!.creationDate, "uninitialized optional property should be nil")
		XCTAssertNil(project!.startDate, "uninitialized optional property should be nil")
		XCTAssertNil(project!.endDate, "uninitialized optional property should be nil")
	}

	func testInvalidRepresentation() {
		
		let invalidRepresentation: [Int: String] = [1:"xxx"]
		let project = Project(response: dummyResponse, representation: invalidRepresentation)
		XCTAssertNil(project, "project should be nil")
	}
	
	func testValidRepresentation() {
		
		let validProjectRepresentation =
			[
				"id":"300418",
				"name":"some cool project",
				"company":["name":"yadayada"],
				"description":"my cool project description",
				"starred":NSNumber(value: 1),
				"logo":"https://tw-webserver2.teamworkpm.net/sites/yat/images/companies/113332/projects/28966C79B7FB66B04201B210AE4301D3%2Ejpeg",
				"created-on":"2016-08-18T12:38:36Z",
				"startDate":"20160501",
				"endDate":"20160904",
				"status":"archived",
				"subStatus":"late"
		] as [String : Any]
		
		let project = Project(response: dummyResponse, representation: validProjectRepresentation)
		XCTAssertNotNil(project, "project should not be nil")
		
		XCTAssertTrue(project!.id == "300418")
		XCTAssertTrue(project!.name == "some cool project")
		XCTAssertTrue(project!.companyName == "yadayada")
		XCTAssertTrue(project!.projectDescription == "my cool project description")
		XCTAssertTrue(project!.starred == true)
		XCTAssertTrue(project!.logo == "https://tw-webserver2.teamworkpm.net/sites/yat/images/companies/113332/projects/28966C79B7FB66B04201B210AE4301D3%2Ejpeg")
		
		let creationDateComponents = DateComponents(calendar: Calendar(identifier: .gregorian), timeZone: TimeZone(abbreviation: "UTC") , year: 2016, month: 8, day: 18, hour: 12, minute: 38, second: 36)
		XCTAssertTrue(project!.creationDate!.compare(creationDateComponents.date!) == .orderedSame)
		
		let startDateComponents = DateComponents(calendar: Calendar(identifier: .gregorian), timeZone: TimeZone(abbreviation: "UTC"), year: 2016, month: 5, day: 1)
		XCTAssertTrue(project!.startDate!.compare(startDateComponents.date!) == .orderedSame)

		let endDateComponents = DateComponents(calendar: Calendar(identifier: .gregorian), timeZone: TimeZone(abbreviation: "UTC"), year: 2016, month: 9, day: 4)
		XCTAssertTrue(project!.endDate!.compare(endDateComponents.date!) == .orderedSame)
		
		XCTAssertTrue(project!.status == .archived)
		XCTAssertTrue(project!.substatus == .late)
		
	}
	
	func testEquatable() {
		let project1 = Project(response: dummyResponse, representation: emptyProject)
		let project2 = Project(response: dummyResponse, representation: emptyProject)

		project1?.id = "1"
		project2?.id = "1"
		XCTAssertTrue(project1 == project2, "projects should be equal")
		
		project1?.id = "1"
		project2?.id = "2"
		XCTAssertFalse(project1 == project2, "projects should NOT be equal")
		
		project1?.id = nil
		project2?.id = "2"
		XCTAssertFalse(project1 == project2, "projects should NOT be equal")

		project1?.id = "1"
		project2?.id = nil
		XCTAssertFalse(project1 == project2, "projects should NOT be equal")
		
		project1?.id = nil
		project2?.id = nil
		XCTAssertFalse(project1 == project2, "projects should NOT be equal")

	}

	func testComparable() {
		let project1 = Project(response: dummyResponse, representation: emptyProject)
		let project2 = Project(response: dummyResponse, representation: emptyProject)

		XCTAssertFalse(project1! < project2!, "If one or both creation dates are nil, project1 < project2 should return false!")
		
		project1?.creationDate = Date(timeIntervalSinceNow: 100)
		project2?.creationDate = Date(timeIntervalSinceNow: 100)
		XCTAssertFalse(project1! < project2!, "For the same creation date project1 < project2 should return false!")

		project1?.creationDate = Date(timeIntervalSinceNow: 100)
		project2?.creationDate = Date(timeIntervalSinceNow: 200)
		XCTAssertTrue(project1! < project2!, "A project that was created before another should be <")

		project1?.creationDate = Date(timeIntervalSinceNow: 200)
		project2?.creationDate = Date(timeIntervalSinceNow: 100)
		XCTAssertFalse(project1! < project2!, "A project that was created after another should NOT be <")

	}
	
}
