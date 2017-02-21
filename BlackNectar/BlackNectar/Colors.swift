//
//  Colors.swift
//  BlackNectar
//
//  Created by Cordero Hernandez on 2/8/17.
//  Copyright © 2017 BlackSource. All rights reserved.
//

import Foundation
import UIKit

//TODO: Replace this class with RedRomaColors to minimize Code Duplication
public class Colors {
    
    static func fromRGB(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        
        return fromRGBA(red: red, green: green, blue: blue, alpha: 100)
        
    }
    
    static func fromRGBA(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) -> UIColor {
        
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: alpha/100)
        
    }
    
    /**
     Create a color value using a Hexadecimal String. Color values are expect in the `"000000"..."FFFFFF"` range.
     
     - parameter hexString: The hex color string, for example, "`#740F91"`.
     
     - returns: The corresponding `UIColor`
     */
    public static func from(hexString: String) -> UIColor? {
        guard !hexString.isEmpty else {
            print("Hex String cannot be empty")
            return nil
        }
        
        //Remove the Hash symbol
        let hex = hexString.replacingOccurrences(of: "#", with: "")
        
        guard hex.characters.count == 6 else {
            print("Hex must have 6 characters exactly")
            return nil
        }
        
        let parts = splitEveryTwoChracters(string: hex)
        
        guard parts.count == 3 else { return nil }
        
        let redComponent = parts[0]
        let greenComponent = parts[1]
        let blueComponent = parts[2]
        
        let redValue = toDecimal(hexString: redComponent)
        let greenValue = toDecimal(hexString: greenComponent)
        let blueValue = toDecimal(hexString: blueComponent)
        
        return fromRGB(red: CGFloat(redValue), green: CGFloat(greenValue), blue: CGFloat(blueValue))
        
    }
    
    private static func splitEveryTwoChracters(string: String) -> [String] {
        var startIndex = string.startIndex
        var endIndex = string.index(startIndex, offsetBy: 1)
        
        var parts: [String] = []
        
        while (startIndex < string.endIndex && endIndex < string.endIndex) {
            let subString = string[startIndex...endIndex]
            parts.append(subString)
            
            startIndex = string.index(endIndex, offsetBy: 1)
            
            if startIndex < string.endIndex {
                endIndex = string.index(startIndex, offsetBy: 1)
            }
        }
        
        return parts
    }
    
    private static func toDecimal(hexString: String) -> Int {
        var exponent = 0
        var value: Int = 0
        
        for hexCharacter in hexString.characters.reversed() {
            let hexValue = toDecimal(hexLetter: hexCharacter)
            
            let additionalValue = Double(hexValue) * pow(Double(16), Double(exponent))
            value += Int(additionalValue)
            exponent += 1
        }
        
        return value
    }
    
    private static func toDecimal(hexLetter: Character) -> Int {
        let hexLetterString = String(hexLetter).uppercased()
        
        let hexLettersMap = [
            "A" : 10,
            "B" : 11,
            "C" : 12,
            "D" : 13,
            "E" : 14,
            "F" : 15
        ]
        
        switch hexLetterString {
            case "1"..."9" : return Int(hexLetterString) ?? 0
            default: return hexLettersMap[hexLetterString] ?? 0
        }
    }
    
}
