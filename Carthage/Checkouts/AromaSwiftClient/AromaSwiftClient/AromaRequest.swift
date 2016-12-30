//
//  AromaRequest.swift
//  AromaSwiftClient
//
//  Created by Wellington Moreno on 4/6/16.
//  Copyright © 2016 RedRoma, Inc. All rights reserved.
//

import AromaThrift
import Foundation
import SwiftExceptionCatcher

public struct AromaRequest : Equatable
{

    public enum Priority: UInt32
    {
        case low
        case medium
        case high

        func toThrift() -> UInt32
        {
            switch self
            {
                case .low : return Urgency_LOW.rawValue
                case .medium : return Urgency_MEDIUM.rawValue
                case .high : return Urgency_HIGH.rawValue
            }
        }
    }


    //MARK: Public properties
    public var title: String = ""
    public var body: String? = ""
    public var priority: AromaRequest.Priority = .low
    public var deviceName: String = AromaClient.deviceName

}


public func == (lhs: AromaRequest, rhs: AromaRequest) -> Bool
{

    if !equals(lhs.title, right: rhs.title)
    {
        return false
    }

    if !equals(lhs.body, right: rhs.body)
    {
        return false
    }

    if !equals(lhs.priority, right: rhs.priority)
    {
        return false
    }

    if !equals(lhs.deviceName, right: rhs.deviceName)
    {
        return false
    }

    return true
}

func equals<T:Equatable> (_ left: T?, right: T?) -> Bool
{

    if let left = left, let right = right
    {
        return left == right
    }

    return left == nil && right == nil

}

//MARK: Public APIs
extension AromaRequest
{

    public func addBody(_ body: String) -> AromaRequest
    {
        let newBody = (self.body ?? "") + body
        return AromaRequest(title: title, body: newBody, priority: priority, deviceName: deviceName)
    }

    public func addLine(_ number: Int = 1) -> AromaRequest
    {
        
        guard number > 0 else { return self }
        
        let newLineCharacter = Character("\n")
        let newBody = (self.body ?? "") + String(repeating: String(newLineCharacter), count: number)
        
        return AromaRequest(title: title, body: newBody, priority: priority, deviceName: deviceName)
    }

    public func withDeviceName(_ deviceName: String) -> AromaRequest
    {
        return AromaRequest(title: title, body: body, priority: priority, deviceName: deviceName)
    }

    public func withTitle(_ title: String) -> AromaRequest
    {
        return AromaRequest(title: title, body: body, priority: priority, deviceName: deviceName)
    }

    public func withPriority(_ priority: AromaRequest.Priority) -> AromaRequest
    {
        return AromaRequest(title: title, body: body, priority: priority, deviceName: deviceName)
    }

    public func send(onError: AromaClient.OnError? = nil, onDone: AromaClient.OnDone? = nil)
    {
        AromaClient.send(message: self, onError: onError, onDone: onDone)
    }
}
