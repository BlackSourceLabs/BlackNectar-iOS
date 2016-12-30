//
//  AromaRequestTests.swift
//  AromaSwiftClient
//
//  Created by Wellington Moreno on 4/6/16.
//  Copyright © 2016 RedRoma, Inc. All rights reserved.
//

import XCTest
@testable import AromaSwiftClient

class AromaRequestTests: XCTestCase
{

    fileprivate var instance: AromaRequest!

    override func setUp()
    {
        super.setUp()

        instance = AromaRequest()

        instance.title = "message title"
        instance.body = "some body"
        instance.priority = .low
    }

    override func tearDown()
    {
        super.tearDown()
    }
    
    fileprivate func clearBody()
    {
        instance.body = nil
    }

    func testWithTitle()
    {
        guard let instance = instance else { return }

        let newTitle = "new title"
        let result = instance.withTitle(newTitle)

        XCTAssert(result.title == newTitle)
        XCTAssert(result.body == instance.body)
        XCTAssert(result.priority == instance.priority)
        XCTAssert(result.deviceName == instance.deviceName)
        XCTAssert(result != instance)

    }

    func testAddBody()
    {
        clearBody()
        
        let newBody = "new Body"
        let result = instance.addBody(newBody)

        XCTAssert(result.body == newBody)
        XCTAssert(result.title == instance.title)
        XCTAssert(result.deviceName == instance.deviceName)
        XCTAssert(result.priority == instance.priority)
        XCTAssert(result != instance)
    }

    func testMultipleAddBody()
    {
        clearBody()
        
        let first = "first body"
        let second = "second body"
        
        let result = instance.addBody(first)
                             .addBody(second)

        XCTAssert(result.body == first + second)
        XCTAssert(result.title == instance.title)
        XCTAssert(result.deviceName == instance.deviceName)
        XCTAssert(result.priority == instance.priority)
    }
    
    func testAddBodyWithLine()
    {
        clearBody()
        
        let first = "jkflkasj3filjfleas"
        let second = "seifj3lj90fjsdl fjo3 jrdlfj"
        let expected = "\(first)\n\n\(second)"
        
        let result = instance.addBody(first)
            .addLine(2)
            .addBody(second)
        
        XCTAssert(result.body == expected)
    }

    func testWithDeviceName()
    {

        let newDevice = "new Device"
        let result = instance.withDeviceName(newDevice)

        XCTAssert(result.deviceName == newDevice)
        XCTAssert(result.body == instance.body)
        XCTAssert(result.title == instance.title)
        XCTAssert(result.priority == instance.priority)
        XCTAssert(result != instance)
    }

    func testWithUrgency()
    {

        let newUrgecy: AromaRequest.Priority = .high
        let result = instance.withPriority(newUrgecy)

        XCTAssert(result.priority == newUrgecy)
        XCTAssert(result.title == instance.title)
        XCTAssert(result.body == instance.body)
        XCTAssert(result.deviceName == instance.deviceName)
        XCTAssert(result != instance)
    }
}
