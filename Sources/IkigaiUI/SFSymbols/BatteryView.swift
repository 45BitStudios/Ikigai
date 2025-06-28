//
//  BatteryView.swift
//  IkigaiAPI
//
//  Created by Vince Davis on 3/5/25.
//


import SwiftUI

public struct BatteryView : View {
    var batteryLevel : Int
    var isCharging : Bool = false
    var outlineColor : Color = .primary
    
    public init(batteryLevel: Int, isCharging: Bool, outlineColor: Color) {
        self.batteryLevel = batteryLevel
        self.isCharging = isCharging
        self.outlineColor = outlineColor
    }
    
    var batteryLevelColor : Color {
        switch batteryLevel {
            case 0...10:
                return Color.red
            case 10...30:
                return Color.yellow
            case 30...100:
                return Color.green
            default:
                return Color.clear
        }
    }
    
    private var gradientBatteryColor: LinearGradient {
        return LinearGradient(stops: [
            Gradient.Stop(color: batteryLevelColor, location: 0),
            Gradient.Stop(color: batteryLevelColor, location: percent),
            Gradient.Stop(color: .clear, location: percent),
            Gradient.Stop(color: .clear, location: 1),
        ], startPoint: .leading, endPoint: .trailing)
    }
    
    private var percent: Double {
        if isCharging {
            return max(0.0, Double(batteryLevel)/100)
        } else {
            return max(0.0, min(1.0, 0.1 + (0.7 * Double(batteryLevel)/100.0)))
        }
    }
    
    public var body: some View {
        if isCharging {
            Image(systemName: "battery.100.bolt")
                .symbolRenderingMode(.palette)
                .foregroundStyle(.yellow, outlineColor, gradientBatteryColor)
                .symbolEffect(.pulse.byLayer, options: .repeat(.continuous))
        } else {
            Image(systemName: "battery.100percent")
                .symbolRenderingMode(.palette)
                .foregroundStyle(gradientBatteryColor, outlineColor)
        }
    }
}

struct BatteryView_Previews: PreviewProvider {
    static var previews: some View {
        BatteryView(batteryLevel: 20, isCharging: true, outlineColor: .primary)
            .font(.system(size: 80))
    }
}
