//
//  HistoryChartView.swift
//  DemeterEye
//
//  Created by Konstantin Polin on 10/4/25.
//

import SwiftUI
import Charts

struct HistoryChartView: View {
    @State private var viewModel: HistoryChartViewModel
    
    init(history: [FieldHistory]) {
        self._viewModel = State(initialValue: HistoryChartViewModel(history: history))
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Year Selector Tabs
                if viewModel.availableYears.count > 1 {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Select Year")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .padding(.horizontal)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(viewModel.availableYears, id: \.self) { year in
                                    YearTabView(
                                        year: String(year),
                                        isSelected: year == viewModel.selectedYear,
                                        action: { viewModel.selectedYear = year }
                                    )
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                }
                
                // Chart Section
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text("NDVI Over Time - \(viewModel.selectedYear)")
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        Spacer()
                        
                        VStack(alignment: .trailing, spacing: 2) {
                            Text("\(viewModel.chartData.count) points")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            
                            Text(viewModel.yearSummary.dateRange)
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.horizontal)
                    
                    ScrollView(.horizontal, showsIndicators: true) {
                        Chart(viewModel.chartData, id: \.date) { dataPoint in
                            LineMark(
                                x: .value("Date", dataPoint.date),
                                y: .value("NDVI", dataPoint.ndvi)
                            )
                            .foregroundStyle(Color.demeterGreen)
                            .lineStyle(StrokeStyle(lineWidth: 2))
                            
                            // Only show points if we have reasonable density
                            if viewModel.shouldShowPoints {
                                PointMark(
                                    x: .value("Date", dataPoint.date),
                                    y: .value("NDVI", dataPoint.ndvi)
                                )
                                .foregroundStyle(Color.demeterGreen)
                                .symbol(.circle)
                                .symbolSize(30)
                            }
                        }
                        .chartYScale(domain: [0, 1]) // NDVI ranges from 0 to 1
                        .chartXAxis {
                            AxisMarks(values: .stride(by: viewModel.axisStride)) { value in
                                AxisValueLabel {
                                    if let date = value.as(Date.self) {
                                        Text(date.formatted(.dateTime.month(.abbreviated).year(.twoDigits)))
                                    }
                                }
                                AxisGridLine()
                                AxisTick()
                            }
                        }
                        .chartYAxis {
                            AxisMarks { value in
                                AxisValueLabel {
                                    if let ndviValue = value.as(Double.self) {
                                        Text("\(ndviValue, specifier: "%.2f")")
                                    }
                                }
                                AxisGridLine()
                                AxisTick()
                            }
                        }
                        .frame(width: calculateChartWidth(), height: 300)
                        .padding(.horizontal)
                    }
                }
                
                // Data Summary
                VStack(alignment: .leading, spacing: 12) {
                    Text("Data Summary")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .padding(.horizontal)
                    
                    LazyVStack(spacing: 8) {
                        ForEach(viewModel.chartData.reversed(), id: \.date) { dataPoint in
                            DataSummaryRowView(dataPoint: dataPoint)
                        }
                    }
                    .padding(.horizontal)
                }
                
                Spacer(minLength: 20)
            }
        }
        .background(Color.demeterBackground)
        .navigationTitle("Field History")
        .navigationBarTitleDisplayMode(.large)
    }
    
    private func calculateChartWidth() -> CGFloat {
        let screenWidth = UIScreen.main.bounds.width - 32
        return viewModel.calculateChartWidth(screenWidth: screenWidth)
    }
}

struct DataSummaryRowView: View {
    let dataPoint: HistoryDataPoint
    
    private var temperatureText: String {
        if let temp = dataPoint.originalData.temperatureDegC {
            return String(format: "%.1f°C", temp)
        } else {
            return "—"
        }
    }
    
    private var clarityText: String {
        if let clarity = dataPoint.originalData.clarityPct {
            return String(format: "%.0f%% clarity", clarity)
        } else {
            return "—"
        }
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(dataPoint.date.formatted(date: .abbreviated, time: .omitted))
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Text("NDVI: \(dataPoint.ndvi, specifier: "%.3f")")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 2) {
                Text(temperatureText)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text(clarityText)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(Color.gray.opacity(0.05))
        .cornerRadius(8)
    }
}

struct YearTabView: View {
    let year: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Text("\(year)")
                    .font(.subheadline)
                    .fontWeight(isSelected ? .semibold : .medium)
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.caption)
                }
            }
            .foregroundColor(isSelected ? .white : .demeterGreen)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(isSelected ? Color.demeterGreen : Color.demeterGreen.opacity(0.1))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.demeterGreen, lineWidth: isSelected ? 0 : 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    let sampleHistory = [
        // 2023 data
        FieldHistory(date: "2023-03-15T00:00:00.000Z", ndvi: 0.20, cloudCover: 12, collection: "sentinel", temperatureDegC: 7.2, humidityPct: 68, cloudcoverPct: 12, windSpeedMps: 2.1, clarityPct: 88),
        FieldHistory(date: "2023-06-01T00:00:00.000Z", ndvi: 0.75, cloudCover: 8, collection: "sentinel", temperatureDegC: 21.5, humidityPct: 52, cloudcoverPct: 8, windSpeedMps: 1.9, clarityPct: 92),
        FieldHistory(date: "2023-09-15T00:00:00.000Z", ndvi: 0.45, cloudCover: 15, collection: "sentinel", temperatureDegC: 16.8, humidityPct: 62, cloudcoverPct: 15, windSpeedMps: 2.8, clarityPct: 85),
        
        // 2024 data  
        FieldHistory(date: "2024-03-15T00:00:00.000Z", ndvi: 0.25, cloudCover: 10, collection: "sentinel", temperatureDegC: 8.5, humidityPct: 65, cloudcoverPct: 10, windSpeedMps: 2.3, clarityPct: 90),
        FieldHistory(date: "2024-04-01T00:00:00.000Z", ndvi: 0.45, cloudCover: 15, collection: "sentinel", temperatureDegC: 12.8, humidityPct: 58, cloudcoverPct: 15, windSpeedMps: 3.1, clarityPct: 85),
        FieldHistory(date: "2024-04-15T00:00:00.000Z", ndvi: 0.62, cloudCover: 5, collection: "sentinel", temperatureDegC: 18.2, humidityPct: 52, cloudcoverPct: 5, windSpeedMps: 1.8, clarityPct: 95),
        
        // 2025 data
        FieldHistory(date: "2025-05-01T00:00:00.000Z", ndvi: 0.78, cloudCover: 20, collection: "sentinel", temperatureDegC: 22.1, humidityPct: 48, cloudcoverPct: 20, windSpeedMps: 2.7, clarityPct: 80),
        FieldHistory(date: "2025-05-18T00:00:00.000Z", ndvi: 0.82, cloudCover: 8, collection: "sentinel", temperatureDegC: 25.3, humidityPct: 45, cloudcoverPct: 8, windSpeedMps: 1.5, clarityPct: 92)
    ]
    
    HistoryChartView(history: sampleHistory)
}
