//
//  UseCaseTests.swift
//  AromaSwiftClient
//
//  Created by Wellington Moreno on 4/6/16.
//  Copyright © 2016 RedRoma, Inc. All rights reserved.
//

import XCTest
import AromaSwiftClient

class UseCaseTests: XCTestCase
{

    fileprivate let tokenId = TEST_TOKEN_ID

    fileprivate let title = "Unit Test Ran"

    override func setUp()
    {
        super.setUp()

        AromaClient.TOKEN_ID = tokenId
        AromaClient.maxConcurrency = 1
    }

    func testAroma()
    {

        print("Sending Message")

        let onError: AromaClient.OnError =
        { ex in
            print("Failed to send Message: \(ex)")
            XCTFail("Could not send message: \(ex)")
        }
        
        let onDone: AromaClient.OnDone =
        {
            print("Successfully sent message")
        }

        let date = Date()

        AromaClient.beginMessage(withTitle: title)
            .addBody("Sending a test message as part of the unit test")
            .addLine().addLine()
            .addBody("Todays Date is \(date)")
            .withPriority(.low)
            .send(onError: onError, onDone: onDone)

    }

}
