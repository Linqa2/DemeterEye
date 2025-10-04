//
//  MockData.swift
//  DemeterEye
//
//  Created by Konstantin Polin on 10/2/25.
//

import Foundation

extension Field {
    static let mockFields: [Field] = [
        Field(
            id: "mock1",
            ownerId: "owner1",
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
            meta: FieldMeta(areaHa: 12.8, notes: "Sunny side; loam soil", crop: "wheat"),
            yields: [
                YieldData(year: 2023, valueTph: 4.2, unit: "t/ha", source: "manual", notes: ""),
                YieldData(year: 2024, valueTph: 4.7, unit: "t/ha", source: "manual", notes: nil)
            ],
            history: [
                FieldHistory(
                    year: 2024,
                    phenology: Phenology(
                        sos: "2024-03-25T00:00:00Z",
                        peakDate: "2024-05-18T00:00:00Z",
                        eos: "2024-08-20T00:00:00Z",
                        los: 148,
                        peakNdvi: 0.78,
                        deviation: Deviation(daysSOS: -3, daysPeak: 0, daysEOS: 1, daysLOS: 2, peakNdvi: 0.03)
                    ),
                    ndviStats: NDVIStats(mean: 0.56, max: 0.78, auc: 52.3, samples: 24, source: "HLS/Sentinel-2"),
                    weather: Weather(tminAvgC: 6.1, tmaxAvgC: 18.9, windAvgMs: 3.2, sunHours: 820, precipMm: 210, gdd: 1350)
                )
            ],
            norm: FieldNorm(sosAvgDOY: 85, peakAvgDOY: 138, eosAvgDOY: 233, losAvgDays: 148, peakNdviAvg: 0.75),
            current: CurrentData(
                sos: "2025-03-27T00:00:00Z",
                peakDate: "2025-05-18T00:00:00Z",
                eos: nil,
                los: nil,
                peakNdvi: 0.62,
                deviation: Deviation(daysSOS: 2, daysPeak: nil, daysEOS: nil, daysLOS: nil, peakNdvi: -0.05)
            ),
            forecast: ForecastData(
                year: 2025,
                yieldTph: 4.5,
                ndviPeak: 0.73,
                ndviPeakAt: "2025-05-22T00:00:00Z",
                model: "xgb-v1",
                confidence: 0.72,
                updatedAt: "2025-10-01T20:31:00Z"
            )
        ),
        Field(
            id: "mock2",
            ownerId: "owner1",
            name: "South Field B",
            geometry: GeoJSONGeometry.polygon(Polygon(coordinates: [
                [
                    Position(longitude: 36.130, latitude: 49.980),
                    Position(longitude: 36.137, latitude: 49.981),
                    Position(longitude: 36.136, latitude: 49.985),
                    Position(longitude: 36.129, latitude: 49.984),
                    Position(longitude: 36.130, latitude: 49.980)
                ]
            ])),
            createdAt: "2025-09-15T18:45:00Z",
            meta: FieldMeta(areaHa: 18.5, notes: "Clay soil, good drainage", crop: "corn"),
            yields: [
                YieldData(year: 2023, valueTph: 8.1, unit: "t/ha", source: "manual", notes: ""),
                YieldData(year: 2024, valueTph: 8.8, unit: "t/ha", source: "manual", notes: nil)
            ],
            history: [
                FieldHistory(
                    year: 2024,
                    phenology: Phenology(
                        sos: "2024-04-10T00:00:00Z",
                        peakDate: "2024-06-25T00:00:00Z",
                        eos: "2024-09-15T00:00:00Z",
                        los: 158,
                        peakNdvi: 0.82,
                        deviation: Deviation(daysSOS: 1, daysPeak: -2, daysEOS: 3, daysLOS: 2, peakNdvi: 0.07)
                    ),
                    ndviStats: NDVIStats(mean: 0.61, max: 0.82, auc: 58.7, samples: 28, source: "HLS/Sentinel-2"),
                    weather: Weather(tminAvgC: 8.3, tmaxAvgC: 22.1, windAvgMs: 2.8, sunHours: 950, precipMm: 385, gdd: 1680)
                )
            ],
            norm: FieldNorm(sosAvgDOY: 100, peakAvgDOY: 178, eosAvgDOY: 255, losAvgDays: 155, peakNdviAvg: 0.75),
            current: CurrentData(
                sos: "2025-04-12T00:00:00Z",
                peakDate: nil,
                eos: nil,
                los: nil,
                peakNdvi: 0.71,
                deviation: Deviation(daysSOS: 2, daysPeak: nil, daysEOS: nil, daysLOS: nil, peakNdvi: -0.04)
            ),
            forecast: ForecastData(
                year: 2025,
                yieldTph: 9.2,
                ndviPeak: 0.79,
                ndviPeakAt: "2025-06-20T00:00:00Z",
                model: "xgb-v1",
                confidence: 0.78,
                updatedAt: "2025-10-01T20:31:00Z"
            )
        ),
        Field(
            id: "mock3",
            ownerId: "owner1",
            name: "East Pasture",
            geometry: GeoJSONGeometry.polygon(Polygon(coordinates: [
                [
                    Position(longitude: 36.140, latitude: 49.995),
                    Position(longitude: 36.148, latitude: 49.996),
                    Position(longitude: 36.147, latitude: 50.001),
                    Position(longitude: 36.139, latitude: 50.000),
                    Position(longitude: 36.140, latitude: 49.995)
                ]
            ])),
            createdAt: "2025-08-20T14:20:00Z",
            meta: FieldMeta(areaHa: 25.3, notes: "Mixed soil types, rolling hills", crop: "soybeans"),
            yields: [
                YieldData(year: 2023, valueTph: 2.8, unit: "t/ha", source: "manual", notes: "Drought year"),
                YieldData(year: 2024, valueTph: 3.4, unit: "t/ha", source: "manual", notes: nil)
            ],
            history: [
                FieldHistory(
                    year: 2024,
                    phenology: Phenology(
                        sos: "2024-05-05T00:00:00Z",
                        peakDate: "2024-07-12T00:00:00Z",
                        eos: "2024-09-28T00:00:00Z",
                        los: 146,
                        peakNdvi: 0.74,
                        deviation: Deviation(daysSOS: 0, daysPeak: 3, daysEOS: -2, daysLOS: 1, peakNdvi: -0.01)
                    ),
                    ndviStats: NDVIStats(mean: 0.52, max: 0.74, auc: 47.9, samples: 22, source: "HLS/Sentinel-2"),
                    weather: Weather(tminAvgC: 12.1, tmaxAvgC: 26.4, windAvgMs: 3.5, sunHours: 1120, precipMm: 290, gdd: 1580)
                )
            ],
            norm: FieldNorm(sosAvgDOY: 125, peakAvgDOY: 190, eosAvgDOY: 273, losAvgDays: 148, peakNdviAvg: 0.75),
            current: CurrentData(
                sos: "2025-05-08T00:00:00Z",
                peakDate: nil,
                eos: nil,
                los: nil,
                peakNdvi: 0.68,
                deviation: Deviation(daysSOS: 3, daysPeak: nil, daysEOS: nil, daysLOS: nil, peakNdvi: -0.07)
            ),
            forecast: ForecastData(
                year: 2025,
                yieldTph: 3.6,
                ndviPeak: 0.76,
                ndviPeakAt: "2025-07-15T00:00:00Z",
                model: "xgb-v1",
                confidence: 0.69,
                updatedAt: "2025-10-01T20:31:00Z"
            )
        )
    ]
}