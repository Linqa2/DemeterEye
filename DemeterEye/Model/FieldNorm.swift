//
//  FieldNorm.swift
//  DemeterEye
//
//  Created by Konstantin Polin on 10/2/25.
//

import Foundation

struct FieldNorm: Codable {
    let sosAvgDOY: Int
    let peakAvgDOY: Int
    let eosAvgDOY: Int
    let losAvgDays: Int
    let peakNdviAvg: Double
    
    // Parameter-based initializer
    init(sosAvgDOY: Int, peakAvgDOY: Int, eosAvgDOY: Int, losAvgDays: Int, peakNdviAvg: Double) {
        self.sosAvgDOY = sosAvgDOY
        self.peakAvgDOY = peakAvgDOY
        self.eosAvgDOY = eosAvgDOY
        self.losAvgDays = losAvgDays
        self.peakNdviAvg = peakNdviAvg
    }
    
    // Dictionary-based initializer
    init(from dictionary: [String: Any]) throws {
        guard let sosAvgDOY = dictionary["sosAvgDOY"] as? Int,
              let peakAvgDOY = dictionary["peakAvgDOY"] as? Int,
              let eosAvgDOY = dictionary["eosAvgDOY"] as? Int,
              let losAvgDays = dictionary["losAvgDays"] as? Int,
              let peakNdviAvg = dictionary["peakNdviAvg"] as? Double else {
            throw DecodingError.dataCorrupted(
                DecodingError.Context(codingPath: [], debugDescription: "Missing required fields in FieldNorm dictionary")
            )
        }
        
        self.sosAvgDOY = sosAvgDOY
        self.peakAvgDOY = peakAvgDOY
        self.eosAvgDOY = eosAvgDOY
        self.losAvgDays = losAvgDays
        self.peakNdviAvg = peakNdviAvg
    }
}