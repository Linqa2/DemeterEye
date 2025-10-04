//
//  FieldHistory.swift
//  DemeterEye
//
//  Created by Konstantin Polin on 10/2/25.
//

import Foundation

struct FieldHistory: Codable {
    let date: String
    let ndvi: Double
    let cloudCover: Int
    let collection: String
    let temperatureDegC: Double
    let humidityPct: Double
    let cloudcoverPct: Double
    let windSpeedMps: Double
    let clarityPct: Double
    
    enum CodingKeys: String, CodingKey {
        case date, ndvi, collection
        case cloudCover = "cloud_cover"
        case temperatureDegC = "temperature_deg_c"
        case humidityPct = "humidity_pct"
        case cloudcoverPct = "cloudcover_pct"
        case windSpeedMps = "wind_speed_mps"
        case clarityPct = "clarity_pct"
    }
    
    // Parameter-based initializer
    init(date: String, ndvi: Double, cloudCover: Int, collection: String, temperatureDegC: Double, humidityPct: Double, cloudcoverPct: Double, windSpeedMps: Double, clarityPct: Double) {
        self.date = date
        self.ndvi = ndvi
        self.cloudCover = cloudCover
        self.collection = collection
        self.temperatureDegC = temperatureDegC
        self.humidityPct = humidityPct
        self.cloudcoverPct = cloudcoverPct
        self.windSpeedMps = windSpeedMps
        self.clarityPct = clarityPct
    }
    
    // Dictionary-based initializer
    init(from dictionary: [String: Any]) throws {
        guard let date = dictionary["date"] as? String,
              let ndvi = dictionary["ndvi"] as? Double,
              let cloudCover = dictionary["cloud_cover"] as? Int,
              let collection = dictionary["collection"] as? String,
              let temperatureDegC = dictionary["temperature_deg_c"] as? Double,
              let humidityPct = dictionary["humidity_pct"] as? Double,
              let cloudcoverPct = dictionary["cloudcover_pct"] as? Double,
              let windSpeedMps = dictionary["wind_speed_mps"] as? Double,
              let clarityPct = dictionary["clarity_pct"] as? Double else {
            throw DecodingError.dataCorrupted(
                DecodingError.Context(codingPath: [], debugDescription: "Missing required fields in FieldHistory dictionary")
            )
        }
        
        self.date = date
        self.ndvi = ndvi
        self.cloudCover = cloudCover
        self.collection = collection
        self.temperatureDegC = temperatureDegC
        self.humidityPct = humidityPct
        self.cloudcoverPct = cloudcoverPct
        self.windSpeedMps = windSpeedMps
        self.clarityPct = clarityPct
    }
}