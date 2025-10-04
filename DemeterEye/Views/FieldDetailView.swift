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
    
    var body: some View {
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
                    .allowsHitTesting(false)
                }
                .padding(.horizontal, 16)
                
                // Field Metadata Card
                VStack(spacing: 16) {
                    FieldMetadataCardView(field: field)
                    
                    // History Button Card (if history data exists)
                    if let history = field.history, !history.isEmpty {
                        HistoryButtonCardView(history: history)
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

struct FieldMetadataCardView: View {
    let field: Field
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Circle()
                    .fill(Color.demeterGreen.opacity(0.1))
                    .frame(width: 50, height: 50)
                    .overlay(
                        Image(systemName: "info.circle.fill")
                            .foregroundColor(.demeterGreen)
                            .font(.title2)
                    )
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Field Information")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    
                    Text("Basic field metadata")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
            }
            
            VStack(spacing: 12) {
                MetadataRowView(label: "Area", value: field.areaText, icon: "ruler")
                MetadataRowView(label: "Crop", value: field.cropType, icon: "leaf.fill")
                
                if let notes = field.meta.notes, !notes.isEmpty {
                    MetadataRowView(label: "Notes", value: notes, icon: "note.text")
                }
                
                MetadataRowView(label: "Created", value: formatCreatedDate(field.createdAt), icon: "calendar")
            }
        }
        .padding(20)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
    }
    
    private func formatCreatedDate(_ dateString: String) -> String {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        if let date = formatter.date(from: dateString) {
            let displayFormatter = DateFormatter()
            displayFormatter.dateStyle = .medium
            return displayFormatter.string(from: date)
        }
        return dateString
    }
}

struct MetadataRowView: View {
    let label: String
    let value: String
    let icon: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.demeterGreen)
                .font(.subheadline)
                .frame(width: 16)
            
            Text(label)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Spacer()
            
            Text(value)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.primary)
        }
    }
}

struct HistoryButtonCardView: View {
    let history: [FieldHistory]
    
    var body: some View {
        NavigationLink {
            HistoryChartView(history: history)
        } label: {
            HStack(spacing: 16) {
                Circle()
                    .fill(Color.blue.opacity(0.1))
                    .frame(width: 50, height: 50)
                    .overlay(
                        Image(systemName: "chart.xyaxis.line")
                            .foregroundColor(.blue)
                            .font(.title2)
                    )
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Historical Data")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Text("View NDVI Chart")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    Text("\(history.count) data points available")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.secondary)
                    .font(.subheadline)
            }
            .padding(20)
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

@Observable
class FieldDetailViewModel {
    // This view model can be simplified or removed entirely
    // since most functionality is now handled directly in the views
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
        meta: FieldMeta(areaHa: 12.8, notes: "Sample field for testing", crop: "wheat"),
        yields: [],
        history: [
            FieldHistory(date: "2025-03-15T00:00:00Z", ndvi: 0.25, cloudCover: 10, collection: "sentinel", temperatureDegC: 8.5, humidityPct: 65, cloudcoverPct: 10, windSpeedMps: 2.3, clarityPct: 90),
            FieldHistory(date: "2025-04-01T00:00:00Z", ndvi: 0.45, cloudCover: 15, collection: "sentinel", temperatureDegC: 12.8, humidityPct: 58, cloudcoverPct: 15, windSpeedMps: 3.1, clarityPct: 85),
            FieldHistory(date: "2025-04-15T00:00:00Z", ndvi: 0.62, cloudCover: 5, collection: "sentinel", temperatureDegC: 18.2, humidityPct: 52, cloudcoverPct: 5, windSpeedMps: 1.8, clarityPct: 95),
            FieldHistory(date: "2025-05-01T00:00:00Z", ndvi: 0.78, cloudCover: 20, collection: "sentinel", temperatureDegC: 22.1, humidityPct: 48, cloudcoverPct: 20, windSpeedMps: 2.7, clarityPct: 80),
            FieldHistory(date: "2025-05-18T00:00:00Z", ndvi: 0.82, cloudCover: 8, collection: "sentinel", temperatureDegC: 25.3, humidityPct: 45, cloudcoverPct: 8, windSpeedMps: 1.5, clarityPct: 92)
        ],
        norm: FieldNorm(sosAvgDOY: 85, peakAvgDOY: 138, eosAvgDOY: 233, losAvgDays: 148, peakNdviAvg: 0.75),
        current: CurrentData(sos: "2025-03-27T00:00:00Z", peakDate: "2025-05-18T00:00:00Z", eos: nil, los: nil, peakNdvi: 0.62, deviation: Deviation(daysSOS: 2, daysPeak: 0, daysEOS: nil, daysLOS: nil, peakNdvi: -0.05)),
        forecast: ForecastData(year: 2025, yieldTph: 4.5, ndviPeak: 0.73, ndviPeakAt: "2025-05-22T00:00:00Z", model: "xgb-v1", confidence: 0.72, updatedAt: "2025-10-01T20:31:00Z")
    )
    
    FieldDetailView(field: sampleField)
}

