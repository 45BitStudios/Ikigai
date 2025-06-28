//
//  GenericLineChartView.swift
//  IkigaiAPI
//
//  Created by Vince Davis on 3/1/25.
//

import SwiftUI
import Charts

public enum ChartType {
    case line
    case bar
    case pie
}

/// A generic interactive line chart.
/// - Parameters:
///   - data: An array of your custom data.
///   - xValue: Closure to extract the x-axis value (must be Plottable).
///   - yValue: Closure to extract the y-axis value as a Double.
///   - tooltipText: Closure to format the tooltip text for a given data point.
///   - lineColor: The color for the chart line.
///   - fillGradient: The gradient fill beneath the line.
///   - textColor: The color for tooltip text.
///   - backgroundColor: The background color for the chart.
public struct GenericLineChartView<T, X: Plottable>: View {
    public let data: [T]
    public let xValue: (T) -> X
    public let yValue: (T) -> Double
    public let tooltipText: (T) -> String
    
    // Customizable styling
    public let lineColor: Color
    public let fillGradient: LinearGradient
    public let textColor: Color
    public let backgroundColor: Color
    public let chartType: ChartType
    
    // State for tracking the currently selected data point (for the marker/tooltip)
    @State private var selectedData: T?
    
    /// Public initializer for the generic line chart view.
    public init(
        data: [T],
        xValue: @escaping (T) -> X,
        yValue: @escaping (T) -> Double,
        tooltipText: @escaping (T) -> String,
        lineColor: Color,
        fillGradient: LinearGradient,
        textColor: Color,
        backgroundColor: Color,
        chartType: ChartType
    ) {
        self.data = data
        self.xValue = xValue
        self.yValue = yValue
        self.tooltipText = tooltipText
        self.lineColor = lineColor
        self.fillGradient = fillGradient
        self.textColor = textColor
        self.backgroundColor = backgroundColor
        self.chartType = chartType
    }
    
    public var body: some View {
        ZStack {
            backgroundColor.ignoresSafeArea()
            
            VStack {
                // Display tooltip at the top when a data point is selected.
                if let selected = selectedData {
                    Text(tooltipText(selected))
                        .font(.headline)
                        .padding(8)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(textColor.opacity(0.2))
                        )
                        .foregroundColor(textColor)
                        .padding(.bottom, 4)
                }
                
                Chart {
                    switch chartType {
                    case .line:
                        ForEach(data.indices, id: \.self) { index in
                            let entry = data[index]
                            let xVal = xValue(entry)
                            let yVal = yValue(entry)

                            LineMark(
                                x: .value("X", xVal),
                                y: .value("Y", yVal)
                            )
                            .interpolationMethod(.catmullRom)
                            .foregroundStyle(lineColor)

                            AreaMark(
                                x: .value("X", xVal),
                                y: .value("Y", yVal)
                            )
                            .interpolationMethod(.catmullRom)
                            .foregroundStyle(fillGradient)
                        }

                        if let selected = selectedData {
                            let xVal = xValue(selected)
                            let yVal = yValue(selected)

                            RuleMark(x: .value("X", xVal))
                                .foregroundStyle(.secondary)
                                .lineStyle(StrokeStyle(dash: [2]))

                            PointMark(
                                x: .value("X", xVal),
                                y: .value("Y", yVal)
                            )
                            .symbolSize(60)
                            .foregroundStyle(.red)
                        }

                    case .bar:
                        ForEach(data.indices, id: \.self) { index in
                            let entry = data[index]
                            let xVal = xValue(entry)
                            let yVal = yValue(entry)

                            BarMark(
                                x: .value("X", xVal),
                                y: .value("Y", yVal)
                            )
                            .foregroundStyle(lineColor)
                        }

                    case .pie:
                        ForEach(data.indices, id: \.self) { index in
                            let entry = data[index]
                            let xVal = xValue(entry)
                            let yVal = yValue(entry)

                            SectorMark(
                                angle: .value("Value", yVal),
                                innerRadius: .ratio(0.5),
                                angularInset: 1.0
                            )
                            .foregroundStyle(by: .value("X", xVal))
                        }
                    }
                }
                .chartXAxis {
                    AxisMarks(position: .bottom)
                }
                .chartYAxis {
                    AxisMarks(position: .leading)
                }
                // Overlay for tap/drag detection.
                .chartOverlay { proxy in
                    GeometryReader { geometry in
                        Rectangle()
                            .fill(Color.clear)
                            .contentShape(Rectangle())
                            .gesture(
                                DragGesture(minimumDistance: 0)
                                    .onChanged { value in
                                        if let closest = findClosestData(
                                            to: value.location,
                                            in: proxy,
                                            within: geometry
                                        ) {
                                            selectedData = closest
                                        }
                                    }
                                    .onEnded { _ in
                                        // Optionally, clear the selection on gesture end:
                                        // selectedData = nil
                                    }
                            )
                    }
                }
                .frame(height: 300)
            }
            .padding()
        }
    }
    
    /// Finds the data point whose x-axis position is closest to the given location.
    private func findClosestData(
        to location: CGPoint,
        in proxy: ChartProxy,
        within geometry: GeometryProxy
    ) -> T? {
        // Convert the touch location to the plot area's coordinate system.
        let xPosition = location.x - geometry[proxy.plotAreaFrame].origin.x
        
        // Determine the index of the closest data point based on its x-position.
        if let index = data.indices.min(by: { index1, index2 in
            let x1 = proxy.position(forX: xValue(data[index1])) ?? 0
            let x2 = proxy.position(forX: xValue(data[index2])) ?? 0
            return abs(x1 - xPosition) < abs(x2 - xPosition)
        }) {
            return data[index]
        }
        return nil
    }
}

struct GenericLineChartView_Previews: PreviewProvider {
    // A simple sample data type for previewing the chart.
    struct SampleData {
        let date: String
        let value: Double
    }
    
    static let previewData: [SampleData] = [
        SampleData(date: "Mon", value: 12.5),
        SampleData(date: "Tue", value: 10.2),
        SampleData(date: "Wed", value: 8.9),
        SampleData(date: "Thur", value: 15.3),
        SampleData(date: "Fri", value: 11.1)
    ]
    
    static var previews: some View {
        GenericLineChartView<SampleData, String>(
            data: previewData,
            xValue: { $0.date },
            yValue: { $0.value },
            tooltipText: { "\($0.date): \($0.value) kWh" },
            lineColor: .blue,
            fillGradient: LinearGradient(
                gradient: Gradient(colors: [.blue.opacity(0.3), .blue.opacity(0.0)]),
                startPoint: .top,
                endPoint: .bottom
            ),
            textColor: .black,
            backgroundColor: .white,
            chartType: .line
        )
        .frame(height: 200)
    }
}
