//
//  Weather.swift
//  DemeterEye
//
//  Created by Konstantin Polin on 10/2/25.
//

import Foundation

struct Weather: Codable {
    let tminAvgC: Double
    let tmaxAvgC: Double
    let windAvgMs: Double
    let sunHours: Int
    let precipMm: Double
    let gdd: Int
    
    // Parameter-based initializer
    init(tminAvgC: Double, tmaxAvgC: Double, windAvgMs: Double, sunHours: Int, precipMm: Double, gdd: Int) {
        self.tminAvgC = tminAvgC
        self.tmaxAvgC = tmaxAvgC
        self.windAvgMs = windAvgMs
        self.sunHours = sunHours
        self.precipMm = precipMm
        self.gdd = gdd
    }
    
    // Dictionary-based initializer
    init(from dictionary: [String: Any]) throws {
        guard let tminAvgC = dictionary["tminAvgC"] as? Double,
              let tmaxAvgC = dictionary["tmaxAvgC"] as? Double,
              let windAvgMs = dictionary["windAvgMs"] as? Double,
              let sunHours = dictionary["sunHours"] as? Int,
              let precipMm = dictionary["precipMm"] as? Double,
              let gdd = dictionary["gdd"] as? Int else {
            throw DecodingError.dataCorrupted(
                DecodingError.Context(codingPath: [], debugDescription: "Missing required fields in Weather dictionary")
            )
        }
        
        self.tminAvgC = tminAvgC
        self.tmaxAvgC = tmaxAvgC
        self.windAvgMs = windAvgMs
        self.sunHours = sunHours
        self.precipMm = precipMm
        self.gdd = gdd
    }
}