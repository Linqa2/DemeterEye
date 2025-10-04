//
//  ForecastData.swift
//  DemeterEye
//
//  Created by Konstantin Polin on 10/2/25.
//

import Foundation

struct ForecastData: Codable {
    let year: Int
    let yieldTph: Double
    let ndviPeak: Double
    let ndviPeakAt: String
    let model: String
    let confidence: Double
    let updatedAt: String
    
    // Parameter-based initializer
    init(year: Int, yieldTph: Double, ndviPeak: Double, ndviPeakAt: String, model: String, confidence: Double, updatedAt: String) {
        self.year = year
        self.yieldTph = yieldTph
        self.ndviPeak = ndviPeak
        self.ndviPeakAt = ndviPeakAt
        self.model = model
        self.confidence = confidence
        self.updatedAt = updatedAt
    }
    
    // Dictionary-based initializer
    init(from dictionary: [String: Any]) throws {
        guard let year = dictionary["year"] as? Int,
              let yieldTph = dictionary["yieldTph"] as? Double,
              let ndviPeak = dictionary["ndviPeak"] as? Double,
              let ndviPeakAt = dictionary["ndviPeakAt"] as? String,
              let model = dictionary["model"] as? String,
              let confidence = dictionary["confidence"] as? Double,
              let updatedAt = dictionary["updatedAt"] as? String else {
            throw DecodingError.dataCorrupted(
                DecodingError.Context(codingPath: [], debugDescription: "Missing required fields in ForecastData dictionary")
            )
        }
        
        self.year = year
        self.yieldTph = yieldTph
        self.ndviPeak = ndviPeak
        self.ndviPeakAt = ndviPeakAt
        self.model = model
        self.confidence = confidence
        self.updatedAt = updatedAt
    }
}