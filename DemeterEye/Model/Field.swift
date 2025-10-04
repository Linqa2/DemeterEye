//
//  Field.swift
//  DemeterEye
//
//  Created by Konstantin Polin on 10/2/25.
//

import Foundation
import CoreLocation

struct Field: Codable, Identifiable {
    let id: String
    let ownerId: String
    let name: String
    let geometry: GeoJSONGeometry
    let createdAt: String
    let meta: FieldMeta
    let yields: [YieldData]?
    let history: [FieldHistory]?
    let norm: FieldNorm?
    let current: CurrentData?
    let forecast: ForecastData?
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case ownerId, name, geometry, createdAt, meta, yields, history, norm, current, forecast
    }
    
    // Parameter-based initializer
    init(id: String, ownerId: String, name: String, geometry: GeoJSONGeometry, createdAt: String, meta: FieldMeta, yields: [YieldData]? = nil, history: [FieldHistory]? = nil, norm: FieldNorm? = nil, current: CurrentData? = nil, forecast: ForecastData? = nil) {
        self.id = id
        self.ownerId = ownerId
        self.name = name
        self.geometry = geometry
        self.createdAt = createdAt
        self.meta = meta
        self.yields = yields
        self.history = history
        self.norm = norm
        self.current = current
        self.forecast = forecast
    }
    
    // Dictionary-based initializer
    init(from dictionary: [String: Any]) throws {
        guard let id = dictionary["_id"] as? String ?? dictionary["id"] as? String,
              let ownerId = dictionary["ownerId"] as? String,
              let name = dictionary["name"] as? String,
              let geometryDict = dictionary["geometry"] as? [String: Any],
              let createdAt = dictionary["createdAt"] as? String,
              let metaDict = dictionary["meta"] as? [String: Any] else {
            throw DecodingError.dataCorrupted(
                DecodingError.Context(codingPath: [], debugDescription: "Missing required fields in Field dictionary")
            )
        }
        
        self.id = id
        self.ownerId = ownerId
        self.name = name
        
        // Parse geometry from dictionary to GeoJSONGeometry
        let geometryData = try JSONSerialization.data(withJSONObject: geometryDict)
        self.geometry = try JSONDecoder().decode(GeoJSONGeometry.self, from: geometryData)
        
        self.createdAt = createdAt
        self.meta = try FieldMeta(from: metaDict)
        
        // Optional yields field
        if let yieldsArray = dictionary["yields"] as? [[String: Any]] {
            self.yields = try yieldsArray.map { try YieldData(from: $0) }
        } else {
            self.yields = nil
        }
        
        // Optional fields
//        if let historyArray = dictionary["history"] as? [[String: Any]] {
//            self.history = try historyArray.map { try FieldHistory(from: $0) }
//        } else {
            self.history = nil
//        }
        
        if let normDict = dictionary["norm"] as? [String: Any] {
            self.norm = try FieldNorm(from: normDict)
        } else {
            self.norm = nil
        }
        
        if let currentDict = dictionary["current"] as? [String: Any] {
            self.current = try CurrentData(from: currentDict)
        } else {
            self.current = nil
        }
        
        if let forecastDict = dictionary["forecast"] as? [String: Any] {
            self.forecast = try ForecastData(from: forecastDict)
        } else {
            self.forecast = nil
        }
    }
    
    // Computed properties for easy access
    var cropType: String {
        meta.crop?.capitalized ?? "Unknown"
    }
    
    var areaText: String {
        guard let area = meta.areaHa else { return "Unknown area" }
        return String(format: "%.1f ha", area)
    }
    
    var coordinates: [CLLocationCoordinate2D] {
        return geometry.allCoordinates
    }
    
    var centerCoordinate: CLLocationCoordinate2D {
        return geometry.centerCoordinate
    }
    
    // MARK: - Geometry Convenience Methods
    
    /// Get polygon coordinates if this field is a polygon
    var polygonCoordinates: [CLLocationCoordinate2D]? {
        guard case .polygon(let polygon) = geometry else { return nil }
        return polygon.outerRingCoordinates
    }
    
    /// Check if the field geometry contains a given coordinate
    func contains(coordinate: CLLocationCoordinate2D) -> Bool {
        guard case .polygon(let polygon) = geometry else { return false }
        
        let ring = polygon.outerRingCoordinates
        guard ring.count >= 3 else { return false }
        
        var inside = false
        var j = ring.count - 1
        
        for i in 0..<ring.count {
            let xi = ring[i].longitude
            let yi = ring[i].latitude
            let xj = ring[j].longitude
            let yj = ring[j].latitude
            
            if ((yi > coordinate.latitude) != (yj > coordinate.latitude)) &&
                (coordinate.longitude < (xj - xi) * (coordinate.latitude - yi) / (yj - yi) + xi) {
                inside.toggle()
            }
            j = i
        }
        
        return inside
    }
}


struct FieldMeta: Codable {
    let areaHa: Double?
    let notes: String?
    let crop: String?
    
    // Parameter-based initializer
    init(areaHa: Double? = nil, notes: String? = nil, crop: String? = nil) {
        self.areaHa = areaHa
        self.notes = notes
        self.crop = crop
    }
    
    // Dictionary-based initializer
    init(from dictionary: [String: Any]) throws {
        self.areaHa = dictionary["areaHa"] as? Double
        self.notes = dictionary["notes"] as? String
        self.crop = dictionary["crop"] as? String
    }
}

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

struct FieldHistory: Codable {
    let year: Int
    let phenology: Phenology?
    let ndviStats: NDVIStats?
    let weather: Weather?
    
    // Parameter-based initializer
    init(year: Int, phenology: Phenology? = nil, ndviStats: NDVIStats? = nil, weather: Weather? = nil) {
        self.year = year
        self.phenology = phenology
        self.ndviStats = ndviStats
        self.weather = weather
    }
    
    // Dictionary-based initializer
    init(from dictionary: [String: Any]) throws {
        guard let year = dictionary["year"] as? Int else {
            throw DecodingError.dataCorrupted(
                DecodingError.Context(codingPath: [], debugDescription: "Missing required year field in FieldHistory dictionary")
            )
        }
        
        self.year = year
        
        // Optional phenology
        if let phenologyDict = dictionary["phenology"] as? [String: Any] {
            self.phenology = try Phenology(from: phenologyDict)
        } else {
            self.phenology = nil
        }
        
        // Optional ndviStats
        if let ndviStatsDict = dictionary["ndviStats"] as? [String: Any] {
            self.ndviStats = try NDVIStats(from: ndviStatsDict)
        } else {
            self.ndviStats = nil
        }
        
        // Optional weather
        if let weatherDict = dictionary["weather"] as? [String: Any] {
            self.weather = try Weather(from: weatherDict)
        } else {
            self.weather = nil
        }
    }
}

struct Phenology: Codable {
    let sos: String
    let peakDate: String
    let eos: String
    let los: Int
    let peakNdvi: Double
    let deviation: Deviation
    
    // Parameter-based initializer
    init(sos: String, peakDate: String, eos: String, los: Int, peakNdvi: Double, deviation: Deviation) {
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
              let peakDate = dictionary["peakDate"] as? String,
              let eos = dictionary["eos"] as? String,
              let los = dictionary["los"] as? Int,
              let peakNdvi = dictionary["peakNdvi"] as? Double,
              let deviationDict = dictionary["deviation"] as? [String: Any] else {
            throw DecodingError.dataCorrupted(
                DecodingError.Context(codingPath: [], debugDescription: "Missing required fields in Phenology dictionary")
            )
        }
        
        self.sos = sos
        self.peakDate = peakDate
        self.eos = eos
        self.los = los
        self.peakNdvi = peakNdvi
        self.deviation = try Deviation(from: deviationDict)
    }
}

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

// MARK: - Field Convenience Extensions

extension Field {
    /// Create a field with a simple polygon from coordinate pairs
    static func withPolygon(
        id: String,
        ownerId: String,
        name: String,
        coordinates: [(longitude: Double, latitude: Double)],
        createdAt: String,
        meta: FieldMeta,
        yields: [YieldData] = [],
        history: [FieldHistory]? = nil,
        norm: FieldNorm? = nil,
        current: CurrentData? = nil,
        forecast: ForecastData? = nil
    ) -> Field {
        let positions = coordinates.map { Position(longitude: $0.longitude, latitude: $0.latitude) }
        let polygon = Polygon(coordinates: [positions])
        let geometry = GeoJSONGeometry.polygon(polygon)
        
        return Field(
            id: id,
            ownerId: ownerId,
            name: name,
            geometry: geometry,
            createdAt: createdAt,
            meta: meta,
            yields: yields,
            history: history,
            norm: norm,
            current: current,
            forecast: forecast
        )
    }
    
    /// Create a simple rectangular field
    static func withRectangle(
        id: String,
        ownerId: String,
        name: String,
        center: CLLocationCoordinate2D,
        widthMeters: Double,
        heightMeters: Double,
        createdAt: String,
        meta: FieldMeta,
        yields: [YieldData] = [],
        history: [FieldHistory]? = nil,
        norm: FieldNorm? = nil,
        current: CurrentData? = nil,
        forecast: ForecastData? = nil
    ) -> Field {
        // Approximate conversion from meters to degrees (this is simplified)
        let latDelta = heightMeters / 111111.0 // ~111km per degree latitude
        let lonDelta = widthMeters / (111111.0 * cos(center.latitude * .pi / 180)) // Adjusted for longitude
        
        let positions = [
            Position(longitude: center.longitude - lonDelta/2, latitude: center.latitude - latDelta/2),
            Position(longitude: center.longitude + lonDelta/2, latitude: center.latitude - latDelta/2),
            Position(longitude: center.longitude + lonDelta/2, latitude: center.latitude + latDelta/2),
            Position(longitude: center.longitude - lonDelta/2, latitude: center.latitude + latDelta/2),
            Position(longitude: center.longitude - lonDelta/2, latitude: center.latitude - latDelta/2) // Close the ring
        ]
        
        let polygon = Polygon(coordinates: [positions])
        let geometry = GeoJSONGeometry.polygon(polygon)
        
        return Field(
            id: id,
            ownerId: ownerId,
            name: name,
            geometry: geometry,
            createdAt: createdAt,
            meta: meta,
            yields: yields,
            history: history,
            norm: norm,
            current: current,
            forecast: forecast
        )
    }
    
    /// Update the field's geometry
    func withGeometry(_ newGeometry: GeoJSONGeometry) -> Field {
        return Field(
            id: self.id,
            ownerId: self.ownerId,
            name: self.name,
            geometry: newGeometry,
            createdAt: self.createdAt,
            meta: self.meta,
            yields: self.yields,
            history: self.history,
            norm: self.norm,
            current: self.current,
            forecast: self.forecast
        )
    }
    
    /// Get the area in hectares (approximation for polygons)
    var approximateAreaHectares: Double {
        guard case .polygon(let polygon) = geometry else {
            return meta.areaHa ?? 0.0 // Fallback to metadata value or 0 if nil
        }
        
        // Simple polygon area calculation (Shoelace formula)
        let coords = polygon.outerRingCoordinates
        guard coords.count >= 3 else { return 0.0 }
        
        var area = 0.0
        for i in 0..<coords.count {
            let j = (i + 1) % coords.count
            area += coords[i].longitude * coords[j].latitude
            area -= coords[j].longitude * coords[i].latitude
        }
        area = abs(area) / 2.0
        
        // Convert from square degrees to hectares (very rough approximation)
        // This is highly simplified and should be replaced with proper geospatial calculations
        let hectares = area * 12100.0 // Approximate conversion factor
        
        return hectares
    }
}
