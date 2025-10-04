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
    private let allChartData: [HistoryDataPoint]
    
    var selectedYear: Int {
        didSet {
            updateFilteredData()
        }
    }
    
    // Available years from the data
    let availableYears: [Int]
    
    // Filtered chart data based on selected year
    var chartData: [HistoryDataPoint] = []
    
    init(history: [FieldHistory]) {
        self.history = history
        
        // Parse all data points
        self.allChartData = history.compactMap { item in
            guard let date = Self.parseDate(item.date) else { return nil }
            return HistoryDataPoint(date: date, ndvi: item.ndvi, originalData: item)
        }.sorted(by: { $0.date < $1.date })
        
        // Extract available years
        let years = Set(allChartData.map { Calendar.current.component(.year, from: $0.date) })
        self.availableYears = Array(years).sorted(by: >) // Most recent first
        
        // Set default year to most recent
        self.selectedYear = availableYears.first ?? Calendar.current.component(.year, from: Date())
        
        // Initial filter
        updateFilteredData()
    }
    
    // Calculate appropriate chart width based on data points
    func calculateChartWidth(screenWidth: CGFloat) -> CGFloat {
        let dataPointCount = CGFloat(chartData.count)
        
        // For yearly view, use a more reasonable approach
        if dataPointCount > 20 {
            // Show about 15-20 points per screen width for good readability
            let pointsPerScreenWidth: CGFloat = 15
            let totalScreens = max(1, dataPointCount / pointsPerScreenWidth)
            return screenWidth * totalScreens
        } else {
            // For fewer points, ensure minimum width for good visualization
            return max(dataPointCount * 30, screenWidth)
        }
    }
    
    // Determine if points should be shown based on data density
    var shouldShowPoints: Bool {
        // For yearly view, be more generous with showing points since we have fewer
        return chartData.count <= 100
    }
    
    // Get appropriate axis stride based on data density
    var axisStride: Calendar.Component {
        // For yearly view, always use month as it's more appropriate
        return .month
    }
    
    // Filter data for selected year
    private func updateFilteredData() {
        chartData = allChartData.filter { dataPoint in
            Calendar.current.component(.year, from: dataPoint.date) == selectedYear
        }
    }
    
    // Get data summary for selected year
    var yearSummary: (dataPoints: Int, dateRange: String) {
        let count = chartData.count
        
        guard let firstDate = chartData.first?.date,
              let lastDate = chartData.last?.date else {
            return (0, "No data")
        }
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        
        if Calendar.current.isDate(firstDate, equalTo: lastDate, toGranularity: .day) {
            return (count, formatter.string(from: firstDate))
        } else {
            return (count, "\(formatter.string(from: firstDate)) - \(formatter.string(from: lastDate))")
        }
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
