//
//  GroupedBarChart.swift
//  
//
//  Created by Will Dale on 25/01/2021.
//

import SwiftUI

/**
 View for creating a grouped bar chart.
 
 Uses `GroupedBarChartData` data model.
 
 # Declaration
 ```
 GroupedBarChart(chartData: data, groupSpacing: 25)
 ```
 
 # View Modifiers
 The order of the view modifiers is some what important
 as the modifiers are various types for stacks that wrap
 around the previous views.
 ```
 .touchOverlay(chartData: data)
 .averageLine(chartData: data,
 strokeStyle: StrokeStyle(lineWidth: 3,dash: [5,10]))
 .yAxisPOI(chartData: data,
           markerName: "50",
           markerValue: 50,
           lineColour: Color.blue,
           strokeStyle: StrokeStyle(lineWidth: 3, dash: [5,10]))
 .xAxisGrid(chartData: data)
 .yAxisGrid(chartData: data)
 .xAxisLabels(chartData: data)
 .yAxisLabels(chartData: data)
 .infoBox(chartData: data)
 .floatingInfoBox(chartData: data)
 .headerBox(chartData: data)
 .legends(chartData: data)
 ```
 */
public struct GroupedBarChart<ChartData>: View where ChartData: GroupedBarChartData {
    
    @ObservedObject private var chartData: ChartData
    private let groupSpacing: CGFloat

    @State private var startAnimation: Bool
    
    /// Initialises a grouped bar chart view.
    /// - Parameters:
    ///   - chartData: Must be GroupedBarChartData model.
    ///   - groupSpacing: Spacing between groups of bars.
    public init(
        chartData: ChartData,
        groupSpacing: CGFloat
    ) {
        self.chartData = chartData
        self.groupSpacing = groupSpacing
        self._startAnimation = State<Bool>(initialValue: chartData.shouldAnimate ? false : true)

        self.chartData.groupSpacing = groupSpacing        
    }
    
    
    public var body: some View {
        GeometryReader { geo in
            if chartData.isGreaterThanTwo() {
                HStack(spacing: groupSpacing) {
                    ForEach(chartData.dataSets.dataSets) { dataSet in
                        GroupedBarGroup(chartData: chartData, dataSet: dataSet)
                    }
                }
                .onAppear {
                    self.chartData.viewData.chartSize = geo.frame(in: .local)
                }
            } else { CustomNoDataView(chartData: chartData) }
        }
    }
}

internal struct GroupedBarGroup<ChartData>: View where ChartData: GroupedBarChartData {
    
    @ObservedObject private var chartData: ChartData
    private let dataSet: GroupedBarDataSet
    
    init(
        chartData: ChartData,
        dataSet: GroupedBarDataSet
    ) {
        self.chartData = chartData
        self.dataSet = dataSet
    }
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(dataSet.dataPoints) { dataPoint in
                GroupedBarCell(chartData: chartData, dataPoint: dataPoint)
            }
        }
    }
}


internal struct GroupedBarCell<ChartData>: View where ChartData: GroupedBarChartData {
    
    @ObservedObject private var chartData: ChartData
    private let dataPoint: GroupedBarDataPoint
    
    init(
        chartData: ChartData,
        dataPoint: GroupedBarDataPoint
    ) {
        self.chartData = chartData
        self.dataPoint = dataPoint
    }
    
    internal var body: some View {
        BarElement(chartData: chartData,
                   dataPoint: dataPoint,
                   fill: dataPoint.group.colour,
                   index: 0) // <<----- Hard Coded
            .accessibilityLabel(chartData.accessibilityTitle)
    }
}

