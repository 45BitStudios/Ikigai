//
//  MapHelpers.swift
//  IkigaiAPI
//
//  Created by Vince Davis on 3/31/25.
//

import Foundation
import MapKit

public struct MapHelpers {
    public static func generateSnapshot(for coordinate: CLLocationCoordinate2D, size: CGSize = CGSize(width: 100, height: 75)) async -> UIImage? {
        let options = MKMapSnapshotter.Options()
        options.region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
        //options.emphasisStyle = .muted
        options.showsBuildings = false
        options.mapType = .mutedStandard
        options.showsPointsOfInterest = false
        options.pointOfInterestFilter = .excludingAll
        //options.showsTraffic = false
        options.size = size
        options.scale = 1.0
        
        // Force Dark Mode
        let darkTraitCollection = UITraitCollection(traitsFrom: [
            UITraitCollection(userInterfaceStyle: .dark)
        ])
        options.traitCollection = darkTraitCollection

        let snapshotter = MKMapSnapshotter(options: options)
        
        do {
            let snapshot = try await snapshotter.start()
            return snapshot.image
        } catch {
            print("Snapshot error: \(error)")
            return nil
        }
    }
}
