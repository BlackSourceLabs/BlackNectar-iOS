//
//  EBT+SignInAndSignUpRequirementsTests.swift
//  BlackNectar
//
//  Created by Cordero Hernandez on 4/14/17.
//  Copyright © 2017 BlackSource. All rights reserved.
//

@testable import BlackNectar

import XCTest

class EBT_SignInAndSignUpRequirementsTests: XCTestCase {
    
    var signInRequirementsInstance: SignInRequirements!
    var signUpRequirementsInstance: SignUpRequirements!
    
    var featuresInstance: Features!
    
    override func setUp() {
        super.setUp()
        
        signInRequirementsInstance = SignInRequirements(name: "user-id", type: "username", description: "MrDero123", isRequired: true,
                                                        requirements: RequirementsForSignIn(minLength: 4, maxLength: 35,
                                                                                            characterRequirementsForSignIn: CharacterRequirementsForSignIn(requiresLowerCase: true, requiresUpperCase: false, requiresNumber: true, requiresSpecialCharacter: false)))
        
        signUpRequirementsInstance = SignUpRequirements(name: "user-id", type: "username", description: "MrDero123", isRequired: true,
                                                        requirementsForSignUp: RequirementsForSignUp(minLength: 4, maxLength: 35,
                                                                                                     characterRequirementsForSignUp: CharacterRequirementsForSignUp(requiresLowerCase: true, requiresUpperCase: false, requiresNumber: true, requiresSpecialCharacter: false)))
        
        featuresInstance = Features(accountCreation: "Account Creation Successful", balance: "Account Balance Succesful", transaction: "Account Transaction History Successful")
    }
    
    //MARK: StateFeaturesAndRequirements Tests
    func testGetSignInRequirementsJson() {
        XCTAssertNotNil(signInRequirementsInstance)
    }
    
    func testGetSignUpRequirementsJson() {
        XCTAssertNotNil(signUpRequirementsInstance)
    }
    
    func testGetFeaturesJson() {
        XCTAssertNotNil(featuresInstance)
    }
    
    //MARK: SignInRequirements Tests
    func testGetSignInRequirementsNameJson() {
        let expected = "user-id"
        let result = signInRequirementsInstance.name
        XCTAssertTrue(result == expected)
    }
    
    func testGetSignInRequirementsTypeJson() {
        let expected = "username"
        let result = signInRequirementsInstance.type
        XCTAssertTrue(result == expected)
    }
    
    func testGetSignInRequirementsDescriptionJson() {
        let expected = "MrDero123"
        let result = signInRequirementsInstance.description
        XCTAssertTrue(result == expected)
    }
    
    //MARK: RequirementsForSignIn Tests
    func testGetMinLengthForSignInJson() {
        let expected = 4
        let result = signInRequirementsInstance.requirements.minLength
        XCTAssertTrue(result == expected)
    }
    
    func testGetMaxLengthForSignInJson() {
        let expected = 35
        let result = signInRequirementsInstance.requirements.maxLength
        XCTAssertTrue(result == expected)
    }
    
    //MARK: CharacterRequirementsForSignIn Tests
    func testGetRequiresLowerCaseForSignInJson() {
        let expected = true
        let result = signInRequirementsInstance.requirements.characterRequirementsForSignIn.requiresLowerCase
        XCTAssertTrue(result == expected)
    }
    
    func testGetRequiresUpperCaseForSignInJson() {
        let expected = false
        let result = signInRequirementsInstance.requirements.characterRequirementsForSignIn.requiresUpperCase
        XCTAssertTrue(result == expected)
    }
    
    func testGetRequiresNumberForSignJson() {
        let expected = true
        let result = signInRequirementsInstance.requirements.characterRequirementsForSignIn.requiresNumber
        XCTAssertTrue(result == expected)
    }
    
    func testGetRequiresSpecialCharacterForSignInJson() {
        let expected = false
        let result = signInRequirementsInstance.requirements.characterRequirementsForSignIn.requiresSpecialCharacter
        XCTAssertTrue(result == expected)
    }
    
    
    //MARK: SignUpRequirements Tests
    func testGetSignUpRequirementsNameJson() {
        let expected = "user-id"
        let result = signUpRequirementsInstance.name
        XCTAssertTrue(result == expected)
    }
    
    func testGetSignUpRequirementsTypeJson() {
        let expected = "username"
        let result = signUpRequirementsInstance.type
        XCTAssertTrue(result == expected)
    }
    
    func testGetSignUpRequirementsDescriptionJson() {
        let expected = "MrDero123"
        let result = signUpRequirementsInstance.description
        XCTAssertTrue(result == expected)
    }
    
    //MARK: RequirementsForSignUp Tests
    func testGetMinLengthForSignUpJson() {
        let expected = 4
        let result = signUpRequirementsInstance.requirementsForSignUp.minLength
        XCTAssertTrue(result == expected)
    }
    
    func testGetMaxLengthForSignUpJson() {
        let expected = 35
        let result = signUpRequirementsInstance.requirementsForSignUp.maxLength
        XCTAssertTrue(result == expected)
    }
    
    //MARK: CharacterRequirementsForSignUp Tests
    func testGetRequiresLowerCaseForSignUpJson() {
        let expected = true
        let result = signUpRequirementsInstance.requirementsForSignUp.characterRequirementsForSignUp.requiresLowerCase
        XCTAssertTrue(result == expected)
    }
    
    func testGetRequiresUpperCaseForSignUpJson() {
        let expected = false
        let result = signUpRequirementsInstance.requirementsForSignUp.characterRequirementsForSignUp.requiresUpperCase
        XCTAssertTrue(result == expected)
    }
    
    func testGetRequiresNumberForSignUpJson() {
        let expected = true
        let result = signUpRequirementsInstance.requirementsForSignUp.characterRequirementsForSignUp.requiresNumber
        XCTAssertTrue(result == expected)
    }
    
    func testGetRequiresSpecialCharacterForSignUpJson() {
        let expected = false
        let result = signUpRequirementsInstance.requirementsForSignUp.characterRequirementsForSignUp.requiresSpecialCharacter
        XCTAssertTrue(result == expected)
    }
    
    
    //MARK: Features Tests
    func testGetAccountCreationJson() {
        let expected = "Account Creation Successful"
        let result = featuresInstance.accountCreation
        XCTAssertTrue(result == expected)
    }
    
    func testGetAccountBalanceJson() {
        let expected = "Account Balance Succesful"
        let result = featuresInstance.balance
        XCTAssertTrue(result == expected)
    }
    
    func testGetAccountTransactionHistoryJson() {
        let expected = "Account Transaction History Successful"
        let result = featuresInstance.transaction
        XCTAssertTrue(result == expected)
    }
    
}
