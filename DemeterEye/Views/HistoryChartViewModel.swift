//
//  HistoryChartViewModel.swift
//  DemeterEye
//
//  Created by Konstantin Polin on 10/4/25.
//

import Foundation
import Observation

@Observable
class HistoryChartViewModel {
    private let history: [FieldHistory]
    
    init(history: [FieldHistory]) {
        self.history = history
        chartData = history.compactMap { item in
            guard let date = Self.parseDate(item.date) else { return nil }
               return HistoryDataPoint(date: date, ndvi: item.ndvi, originalData: item)
           }.sorted(by: { $0.date < $1.date })
    }
    
    
    // Computed property to get sorted chart data
    var chartData: [HistoryDataPoint]
    
    // Calculate appropriate chart width based on data points
    func calculateChartWidth(screenWidth: CGFloat) -> CGFloat {
        let dataPointCount = CGFloat(chartData.count)
        
        // For many data points, use a more reasonable width calculation
        if dataPointCount > 50 {
            // Use 8-12 points per screen width, allowing for smooth scrolling
            let pointsPerScreenWidth: CGFloat = 10
            let totalScreens = max(1, dataPointCount / pointsPerScreenWidth)
            return screenWidth * totalScreens
        } else {
            // For fewer points, use the original calculation but with a minimum
            return max(dataPointCount * 50, screenWidth)
        }
    }
    
    // Determine if points should be shown based on data density
    var shouldShowPoints: Bool {
        return chartData.count <= 50
    }
    
    // Get appropriate axis stride based on data density
    var axisStride: Calendar.Component {
        return chartData.count > 50 ? .month : .weekOfYear
    }
    
    private static func parseDate(_ dateString: String) -> Date? {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter.date(from: dateString)
    }
}

struct HistoryDataPoint {
    let date: Date
    let ndvi: Double
    let originalData: FieldHistory
}
