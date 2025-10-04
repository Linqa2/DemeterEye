//
//  CurrentData.swift
//  DemeterEye
//
//  Created by Konstantin Polin on 10/2/25.
//

import Foundation

struct CurrentData: Codable {
    let sos: String
    let peakDate: String?
    let eos: String?
    let los: Int?
    let peakNdvi: Double
    let deviation: Deviation
    
    // Parameter-based initializer
    init(sos: String, peakDate: String?, eos: String?, los: Int?, peakNdvi: Double, deviation: Deviation) {
        self.sos = sos
        self.peakDate = peakDate
        self.eos = eos
        self.los = los
        self.peakNdvi = peakNdvi
        self.deviation = deviation
    }
    
    // Dictionary-based initializer
    init(from dictionary: [String: Any]) throws {
        guard let sos = dictionary["sos"] as? String,
              let peakNdvi = dictionary["peakNdvi"] as? Double,
              let deviationDict = dictionary["deviation"] as? [String: Any] else {
            throw DecodingError.dataCorrupted(
                DecodingError.Context(codingPath: [], debugDescription: "Missing required fields in CurrentData dictionary")
            )
        }
        
        self.sos = sos
        self.peakDate = dictionary["peakDate"] as? String
        self.eos = dictionary["eos"] as? String
        self.los = dictionary["los"] as? Int
        self.peakNdvi = peakNdvi
        self.deviation = try Deviation(from: deviationDict)
    }
}