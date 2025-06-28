//
//  File.swift
//  IkigaiAPI
//
//  Created by Vince Davis on 3/31/25.
//

import Foundation
import UIKit

public struct AppGroup {
    let name = "group.com.45bitsudios.teslaservices"
    
    public static func save(image: UIImage, to appGroup: String, with imageName: String) -> Bool {
        guard let containerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroup) else {
            print("Failed to get container URL")
            return false
        }

        let fileURL = containerURL.appendingPathComponent(imageName)

        guard let data = image.pngData() else {
            print("Failed to convert image to PNG")
            return false
        }

        do {
            try data.write(to: fileURL)
            print("Image saved to App Group at: \(fileURL)")
            return true
        } catch {
            print("Error saving image: \(error)")
            return false
        }
    }
    
    /// Loads a UIImage from the shared App Group container
    public static func load(imageName: String, from appGroup: String) -> UIImage? {
        guard let containerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroup) else {
            print("Failed to get container URL")
            return nil
        }

        let fileURL = containerURL.appendingPathComponent(imageName)

        guard FileManager.default.fileExists(atPath: fileURL.path) else {
            print("Image file does not exist")
            return nil
        }

        return UIImage(contentsOfFile: fileURL.path)
    }
}
