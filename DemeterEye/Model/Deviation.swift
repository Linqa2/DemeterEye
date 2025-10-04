//
//  Deviation.swift
//  DemeterEye
//
//  Created by Konstantin Polin on 10/2/25.
//

import Foundation

struct Deviation: Codable {
    let daysSOS: Int?
    let daysPeak: Int?
    let daysEOS: Int?
    let daysLOS: Int?
    let peakNdvi: Double
    
    // Parameter-based initializer
    init(daysSOS: Int?, daysPeak: Int?, daysEOS: Int?, daysLOS: Int?, peakNdvi: Double) {
        self.daysSOS = daysSOS
        self.daysPeak = daysPeak
        self.daysEOS = daysEOS
        self.daysLOS = daysLOS
        self.peakNdvi = peakNdvi
    }
    
    // Dictionary-based initializer
    init(from dictionary: [String: Any]) throws {
        guard let peakNdvi = dictionary["peakNdvi"] as? Double else {
            throw DecodingError.dataCorrupted(
                DecodingError.Context(codingPath: [], debugDescription: "Missing peakNdvi in Deviation dictionary")
            )
        }
        
        self.daysSOS = dictionary["daysSOS"] as? Int
        self.daysPeak = dictionary["daysPeak"] as? Int
        self.daysEOS = dictionary["daysEOS"] as? Int
        self.daysLOS = dictionary["daysLOS"] as? Int
        self.peakNdvi = peakNdvi
    }
}