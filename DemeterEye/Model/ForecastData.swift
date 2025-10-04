//
//  ForecastData.swift
//  DemeterEye
//
//  Created by Konstantin Polin on 10/2/25.
//

import Foundation

struct ForecastData: Codable {
    let year: Int
    let yieldTph: Double?
    let ndviPeak: Double?
    let ndviPeakAt: String?
    let model: String?
    let confidence: Double?
    let updatedAt: String?
    
    // Parameter-based initializer
    init(year: Int, yieldTph: Double? = nil, ndviPeak: Double? = nil, ndviPeakAt: String? = nil, model: String? = nil, confidence: Double? = nil, updatedAt: String? = nil) {
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
        guard let year = dictionary["year"] as? Int else {
            throw DecodingError.dataCorrupted(
                DecodingError.Context(codingPath: [], debugDescription: "Missing required 'year' field in ForecastData dictionary")
            )
        }
        
        self.year = year
        self.yieldTph = dictionary["yieldTph"] as? Double
        self.ndviPeak = dictionary["ndviPeak"] as? Double
        self.ndviPeakAt = dictionary["ndviPeakAt"] as? String
        self.model = dictionary["model"] as? String
        self.confidence = dictionary["confidence"] as? Double
        self.updatedAt = dictionary["updatedAt"] as? String
    }
}
