//
//  NDVIStats.swift
//  DemeterEye
//
//  Created by Konstantin Polin on 10/2/25.
//

import Foundation

struct NDVIStats: Codable {
    let mean: Double
    let max: Double
    let auc: Double
    let samples: Int
    let source: String
    
    // Parameter-based initializer
    init(mean: Double, max: Double, auc: Double, samples: Int, source: String) {
        self.mean = mean
        self.max = max
        self.auc = auc
        self.samples = samples
        self.source = source
    }
    
    // Dictionary-based initializer
    init(from dictionary: [String: Any]) throws {
        guard let mean = dictionary["mean"] as? Double,
              let max = dictionary["max"] as? Double,
              let auc = dictionary["auc"] as? Double,
              let samples = dictionary["samples"] as? Int,
              let source = dictionary["source"] as? String else {
            throw DecodingError.dataCorrupted(
                DecodingError.Context(codingPath: [], debugDescription: "Missing required fields in NDVIStats dictionary")
            )
        }
        
        self.mean = mean
        self.max = max
        self.auc = auc
        self.samples = samples
        self.source = source
    }
}