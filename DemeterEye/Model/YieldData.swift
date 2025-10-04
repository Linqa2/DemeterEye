//
//  YieldData.swift
//  DemeterEye
//
//  Created by Konstantin Polin on 10/2/25.
//

import Foundation

struct YieldData: Codable {
    let year: Int
    let valueTph: Double
    let unit: String
    let source: String?
    let notes: String?
    
    // Parameter-based initializer
    init(year: Int, valueTph: Double, unit: String, source: String?, notes: String?) {
        self.year = year
        self.valueTph = valueTph
        self.unit = unit
        self.source = source
        self.notes = notes
    }
    
    // Dictionary-based initializer
    init(from dictionary: [String: Any]) throws {
        guard let year = dictionary["year"] as? Int,
              let valueTph = dictionary["valueTph"] as? Double,
              let unit = dictionary["unit"] as? String else {
            throw DecodingError.dataCorrupted(
                DecodingError.Context(codingPath: [], debugDescription: "Missing required fields in YieldData dictionary")
            )
        }
        
        self.year = year
        self.valueTph = valueTph
        self.unit = unit
        self.source = dictionary["source"] as? String
        self.notes = dictionary["notes"] as? String
    }
}