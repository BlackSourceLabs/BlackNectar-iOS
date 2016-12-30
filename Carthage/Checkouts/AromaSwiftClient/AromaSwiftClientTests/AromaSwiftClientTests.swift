//
//  AromaSwiftClientTests.swift
//  AromaSwiftClientTests
//
//  Created by Wellington Moreno on 4/4/16.
//  Copyright © 2016 RedRoma, Inc. All rights reserved.
//

import XCTest
@testable import AromaSwiftClient

let TEST_TOKEN_ID = "f8da3ef6-79f1-44fe-bb93-20e1bf111bee"

class AromaSwiftClientTests: XCTestCase
{
    
    fileprivate var message: AromaRequest!
    
    fileprivate dynamic var isDone = false
   

    override func setUp()
    {
        super.setUp()
        
        message = AromaRequest()
        message.title = "some title"
        message.body = "some body"
        message.priority = .low
        
        isDone = false
        
        testDefaultValues()
        AromaClient.TOKEN_ID = TEST_TOKEN_ID
    }

    override func tearDown()
    {
        super.tearDown()
        
        AromaClient.TOKEN_ID = ""
    }

    fileprivate func testDefaultValues()
    {
        XCTAssertNotNil(AromaClient.hostname)
        XCTAssertNotNil(AromaClient.port)
        XCTAssert(AromaClient.port > 0)

        XCTAssert(AromaClient.TOKEN_ID.isEmpty)
    }

    func testThriftClient()
    {
        let client = AromaClient.createThriftClient()
        XCTAssertNotNil(client)
    }

    func testMessageSend()
    {

        AromaClient.send(message: message, onError: onError, onDone: onDone)

        while !isDone { }
    }

    func testBeginWithTitle()
    {
        let result = AromaClient.beginMessage(withTitle: message.title)
        XCTAssertNotNil(result)
    }
    
    func testSendHighPriorityMessage()
    {
        
        AromaClient.sendHighPriorityMessage(withTitle: "High Priority Test", withBody: message.body, onError: onError, onDone: onDone)
        
        while !isDone { }
    }
    
    func testSendMediumPriorityMessage()
    {
        
        AromaClient.sendMediumPriorityMessage(withTitle: "Medium Priority Test", onError: onError, onDone: onDone)
        
        while !isDone { }
    }
    
    func testSendLowPriorityMessage()
    {
        
        AromaClient.sendLowPriorityMessage(withTitle: "Low Priority Test", onError: onError, onDone: onDone)
        
        while !isDone { }
    }
    
    fileprivate func onError(_ ex: Error)
    {
        XCTFail("Failed to send message: \(ex)")
    }
    
    fileprivate func onDone()
    {
        print("Message sent!")
        
        self.isDone = true
    }
}
