//
//  EBT+ViewTransactionHistory.swift
//  BlackNectar
//
//  Created by Cordero Hernandez on 4/6/17.
//  Copyright © 2017 BlackSource. All rights reserved.
//

import Archeota
import Foundation
import UIKit

//MARK: View Transaction History
struct ViewTransactionHistory {
    
    let name: String
    let value: String
    let timestamp: Timestamp
    let amount: Int
    let address: String
    let retailer: String
    let transactionType: TransactionType
    let type: String
    
    static func getViewTransactionHistory(from viewTransactionDictionary: NSDictionary) -> ViewTransactionHistory? {
        
        return ViewTransactionHistory(fromJSON: viewTransactionDictionary)
    }
    
}

extension ViewTransactionHistory {
    
    init?(fromJSON viewTransactionHistoryDictionary: NSDictionary) {
        
        guard let name = viewTransactionHistoryDictionary["name"] as? String,
            let value = viewTransactionHistoryDictionary["value"] as? String,
            let timestampJSON = viewTransactionHistoryDictionary["timestamp"] as? NSDictionary,
            let amount = viewTransactionHistoryDictionary["amount"] as? Int,
            let address = viewTransactionHistoryDictionary["address"] as? String,
            let retailer = viewTransactionHistoryDictionary["retailer"] as? String,
            let transactionTypeJSON = viewTransactionHistoryDictionary["transaction_type"] as? NSDictionary,
            let type = viewTransactionHistoryDictionary["type"] as? String
            else {
                
                LOG.error("Failed to Parse View Transaction History Dictionary: \(viewTransactionHistoryDictionary)")
                return nil
        }
        
        guard let timestamp = Timestamp(from: timestampJSON) else { return nil }
        guard let transactionType = TransactionType(from: transactionTypeJSON) else { return nil }
        
        self.name = name
        self.value = value
        self.timestamp = timestamp
        self.amount = amount
        self.address = address
        self.retailer = retailer
        self.transactionType = transactionType
        self.type = type
        
    }
    
}

struct Timestamp {
    
    let seconds: Int
    let nano: Int
    
}

extension Timestamp {
    
    init?(from timeStampDictionary: NSDictionary) {
        
        guard let seconds = timeStampDictionary["seconds"] as? Int,
            let nano = timeStampDictionary["nano"] as? Int
            else {
                
                LOG.error("Failed to Parse Time Stamp Dictionary: \(timeStampDictionary)")
                return nil
        }
        
        self.seconds = seconds
        self.nano = nano
        
    }
    
}

struct TransactionType {
    
    let charge: String
    let deposit: String
    
}

extension TransactionType {
    
    init?(from transactionTypeDictionary: NSDictionary) {
        
        guard let charge = transactionTypeDictionary["charge"] as? String,
            let deposit = transactionTypeDictionary["deposit"] as? String
            else {
                
                LOG.error("Failed to Parse Transaction Type: \(transactionTypeDictionary)")
                return nil
        }
        
        self.charge = charge
        self.deposit = deposit
        
    }
    
}
