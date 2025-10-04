//
//  FieldDetailView.swift
//  DemeterEye
//
//  Created by Konstantin Polin on 10/2/25.
//

import SwiftUI
import MapKit
import Observation

struct FieldDetailView: View {
    let field: Field
    @State private var viewModel = FieldDetailViewModel()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Map Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Field Location")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                        
                        Map(initialPosition: .region(
                            MKCoordinateRegion(
                                center: field.centerCoordinate,
                                span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
                            )
                        )) {
                            MapPolygon(coordinates: field.coordinates)
                                .foregroundStyle(Color.demeterGreen.opacity(0.3))
                                .stroke(Color.demeterGreen, lineWidth: 3)
                        }
                        .frame(height: 300)
                        .cornerRadius(16)
                    }
                    .padding(.horizontal, 16)
                    
                    // Summary Cards
                    VStack(spacing: 16) {
                        // Season Start Card
                        if let current = field.current {
                            SummaryCardView(
                                title: "Season Start",
                                value: viewModel.formatDate(current.sos),
                                subtitle: viewModel.getSeasonStartComparison(field: field),
                                icon: "sun.max.fill",
                                iconColor: .orange
                            )
                            
                            // Peak NDVI Card
                            SummaryCardView(
                                title: "Peak NDVI",
                                value: String(format: "%.2f", current.peakNdvi),
                                subtitle: viewModel.getPeakNDVIDate(field: field),
                                icon: "chart.line.uptrend.xyaxis",
                                iconColor: .demeterGreen
                            )
                        } else {
                            // No current data available cards
                            SummaryCardView(
                                title: "Season Start",
                                value: "No Data",
                                subtitle: "Current season data not available",
                                icon: "sun.max.fill",
                                iconColor: .gray
                            )
                            
                            SummaryCardView(
                                title: "Peak NDVI",
                                value: "No Data",
                                subtitle: "Current season data not available",
                                icon: "chart.line.uptrend.xyaxis",
                                iconColor: .gray
                            )
                        }
                        
                        // Comparison Card
                        if field.norm != nil && field.current != nil {
                            SummaryCardView(
                                title: "vs Long-term Average",
                                value: viewModel.getComparisonText(field: field),
                                subtitle: "Based on historical data",
                                icon: "clock.arrow.circlepath",
                                iconColor: .blue
                            )
                        } else {
                            SummaryCardView(
                                title: "vs Long-term Average",
                                value: "No Data",
                                subtitle: "Historical data not available",
                                icon: "clock.arrow.circlepath",
                                iconColor: .gray
                            )
                        }
                        
                        // Forecast Card
                        if let forecast = field.forecast {
                            SummaryCardView(
                                title: "Yield Forecast",
                                value: String(format: "%.1f t/ha", forecast.yieldTph),
                                subtitle: String(format: "%.0f%% confidence", forecast.confidence * 100),
                                icon: "target",
                                iconColor: .purple
                            )
                        } else {
                            SummaryCardView(
                                title: "Yield Forecast",
                                value: "No Data",
                                subtitle: "Forecast not available",
                                icon: "target",
                                iconColor: .gray
                            )
                        }
                    }
                    .padding(.horizontal, 16)
                    
                    Spacer(minLength: 20)
                }
                .padding(.vertical, 16)
            }
            .background(Color.demeterBackground)
            .navigationTitle(field.name)
            .navigationBarTitleDisplayMode(.large)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { dismiss() }) {
                        HStack(spacing: 4) {
                            Image(systemName: "chevron.left")
                            Text("Fields")
                        }
                        .foregroundColor(.demeterGreen)
                    }
                }
            }
        }
    }
}

struct SummaryCardView: View {
    let title: String
    let value: String
    let subtitle: String
    let icon: String
    let iconColor: Color
    
    var body: some View {
        HStack(spacing: 16) {
            Circle()
                .fill(iconColor.opacity(0.1))
                .frame(width: 50, height: 50)
                .overlay(
                    Image(systemName: icon)
                        .foregroundColor(iconColor)
                        .font(.title2)
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Text(value)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
            
            Spacer()
        }
        .padding(20)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
    }
}

@Observable
class FieldDetailViewModel {
    
    func formatDate(_ dateString: String) -> String {
        return dateString.formatAsDisplayDate()
    }
    
    func getSeasonStartComparison(field: Field) -> String {
        guard let current = field.current else {
            return "No current data available"
        }
        
        let daysDiff = current.deviation.daysSOS ?? 0
        
        if daysDiff > 0 {
            return "\(daysDiff) days later than normal"
        } else if daysDiff < 0 {
            return "\(abs(daysDiff)) days earlier than normal"
        } else {
            return "Right on schedule"
        }
    }
    
    func getPeakNDVIDate(field: Field) -> String {
        guard let current = field.current else {
            return "No current data available"
        }
        
        if let peakDate = current.peakDate {
            return "Peak reached: \(formatDate(peakDate))"
        } else if let forecast = field.forecast {
            let forecastDate = formatDate(forecast.ndviPeakAt)
            return "Expected: \(forecastDate)"
        } else {
            return "Peak date not available"
        }
    }
    
    func getComparisonText(field: Field) -> String {
        guard let current = field.current,
              let norm = field.norm else {
            return "No data available"
        }
        
        let ndviDiff = current.deviation.peakNdvi
        let percentage = (ndviDiff / norm.peakNdviAvg) * 100
        
        if percentage > 5 {
            return String(format: "+%.0f%% Above Average", percentage)
        } else if percentage < -5 {
            return String(format: "%.0f%% Below Average", percentage)
        } else {
            return "Within Normal Range"
        }
    }
}

#Preview {
    // Create a sample field for preview
    let sampleField = Field(
        id: "sample",
        ownerId: "owner",
        name: "North Field A",
        geometry: GeoJSONGeometry.polygon(Polygon(coordinates: [
            [
                Position(longitude: 36.121, latitude: 49.987),
                Position(longitude: 36.128, latitude: 49.988),
                Position(longitude: 36.127, latitude: 49.992),
                Position(longitude: 36.120, latitude: 49.991),
                Position(longitude: 36.121, latitude: 49.987)
            ]
        ])),
        createdAt: "2025-10-01T20:30:00Z",
        meta: FieldMeta(areaHa: 12.8, notes: "Sample field", crop: "wheat"),
        yields: [],
        history: [],
        norm: FieldNorm(sosAvgDOY: 85, peakAvgDOY: 138, eosAvgDOY: 233, losAvgDays: 148, peakNdviAvg: 0.75),
        current: CurrentData(sos: "2025-03-27T00:00:00Z", peakDate: "2025-05-18T00:00:00Z", eos: nil, los: nil, peakNdvi: 0.62, deviation: Deviation(daysSOS: 2, daysPeak: 0, daysEOS: nil, daysLOS: nil, peakNdvi: -0.05)),
        forecast: ForecastData(year: 2025, yieldTph: 4.5, ndviPeak: 0.73, ndviPeakAt: "2025-05-22T00:00:00Z", model: "xgb-v1", confidence: 0.72, updatedAt: "2025-10-01T20:31:00Z")
    )
    
    FieldDetailView(field: sampleField)
}
