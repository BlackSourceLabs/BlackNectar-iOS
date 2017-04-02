//
//  EBTCardModel.swift
//  BlackNectar
//
//  Created by Cordero Hernandez on 4/2/17.
//  Copyright © 2017 BlackSource. All rights reserved.
//

import Archeota
import Foundation
import UIKit

//MARK: Supported States
struct SupportedStates {
    
    let stateID: String
    let stateName: String
    
    static func getSupportedStatesJsonData(from supportedStatesDictionary: NSDictionary) -> SupportedStates? {
        
        return SupportedStates(json: supportedStatesDictionary)
        
    }
    
}

extension SupportedStates {
    
    init?(json: NSDictionary) {
        
        guard let stateID = json["id"] as? String,
            let stateName = json["name"] as? String
            else {
                
                LOG.error("Failed to parse Supported States: \(json)")
                return nil
        }
        
        self.stateID = stateID
        self.stateName = stateName
        
    }
    
}

//MARK: Sign In Requirements, Sign Up Requirements, and Features
struct StateFeaturesAndRequiremets {
    
    let signInRequirements: [SignInRequirements]
    let signUpRequirements: [SignUpRequirements]
    let features: Features
    
    static func getStateFeaturesAndRequirementsJsonData(from statesDictionary: NSDictionary) -> StateFeaturesAndRequiremets? {
        
        return StateFeaturesAndRequiremets(json: statesDictionary)
    }
 
}

extension StateFeaturesAndRequiremets {
    
    init?(json: NSDictionary) {
        
        guard let signInRequirementsJSON = json["sign_in_requirements"] as? NSDictionary,
            let signUpRequirementsJSON = json["sign_up_requirements"] as? NSDictionary,
            let featuresJSON = json["features"] as? NSDictionary
            else {
                
                LOG.error("Failed to Parse State Features and Requirements: \(json)")
                return nil
        }
        
        guard let signInRequirements = SignInRequirements(from: signInRequirementsJSON) else { return nil }
        guard let signUpRequirements = SignUpRequirements(from: signUpRequirementsJSON) else { return nil }
        guard let features = Features(from: featuresJSON) else { return nil }
        
        self.signInRequirements = [signInRequirements]
        self.signUpRequirements = [signUpRequirements]
        self.features = features
        
    }
    
}

//MARK: Sign In Requirements
struct SignInRequirements {
    
    let name: String
    let type: String
    let description: String
    let isRequired: String
    let requirements: Requirements
    
}

extension SignInRequirements {
    
    init?(from signInRequirementsDictionary: NSDictionary) {
        
        guard let name = signInRequirementsDictionary["name"] as? String,
            let type = signInRequirementsDictionary["type"] as? String,
            let description = signInRequirementsDictionary["description"] as? String,
            let isRequired = signInRequirementsDictionary["is_required"] as? String,
            let requirementsJSON = signInRequirementsDictionary["requirements"] as? NSDictionary
            else {
                
                LOG.error("Failed to Parse Sign In Requirements: \(signInRequirementsDictionary)")
                return nil
        }
        
        guard let requirements = Requirements(from: requirementsJSON) else { return nil }
        
        self.name = name
        self.type = type
        self.description = description
        self.isRequired = isRequired
        self.requirements = requirements
        
    }
    
}

struct Requirements {
    
    let minLength: Int
    let maxLength: Int
    let characterRequirementsForSignIn: CharacterRequirementsForSignIn
    
}

extension Requirements {
    
    init?(from requirementsDictionary: NSDictionary) {
        
        guard let minLength = requirementsDictionary["min_length"] as? Int,
            let maxLength = requirementsDictionary["max_length"] as? Int,
            let characterRequirementsJSON = requirementsDictionary["character_requirements"] as? NSDictionary
            else {
                
                LOG.error("Failed to Parse Requirements: \(requirementsDictionary)")
                return nil
        }
        
        guard let characterRequirementsForSignIn = CharacterRequirementsForSignIn(from: characterRequirementsJSON) else { return nil }
        
        self.minLength = minLength
        self.maxLength = maxLength
        self.characterRequirementsForSignIn = characterRequirementsForSignIn
        
    }
    
}

struct CharacterRequirementsForSignIn {
    
    let requiresLowerCase: Bool
    let requiresUpperCase: Bool
    let requiresNumber: Bool
    let requiresSpecialCharacter: Bool
    
}

extension CharacterRequirementsForSignIn {
    
    init?(from characterRequirementsDictionary: NSDictionary) {
        
        guard let requiresLowerCase = characterRequirementsDictionary["requires_lower_case"] as? Bool,
            let requiresUpperCase = characterRequirementsDictionary["requires_upper_case"] as? Bool,
            let requiresNumber = characterRequirementsDictionary["requires_number"] as? Bool,
            let requiresSpecialCharacter = characterRequirementsDictionary["requires_special_character"] as? Bool
            else {
                
                LOG.error("Failed to Parse Character Requirements: \(characterRequirementsDictionary)")
                return nil
        }
        
        self.requiresLowerCase = requiresLowerCase
        self.requiresUpperCase = requiresUpperCase
        self.requiresNumber = requiresNumber
        self.requiresSpecialCharacter = requiresSpecialCharacter
        
    }
    
}

//MARK: Sign Up Requirements
struct SignUpRequirements {
    
    let name: String
    let type: String
    let description: String
    let isRequired: String
    let requirementsForSignUp: RequirementsForSignUp
    
}

