//
//  File.swift
//  
//
//  Created by Will Dale on 01/08/2021.
//

import SwiftUI

/// A protocol to get the correct touch overlay marker.
public protocol MarkerType {}

// MARK: - Touch
public protocol Touchable {
    
    associatedtype Marker = MarkerType
        
    var touchMarkerType: Marker { get set }
    static var defualtTouchMarker: Marker { get }
    
    /**
     Takes in the required data to set up all the touch interactions.
     
     Output via `getTouchInteraction(touchLocation: CGPoint, chartSize: CGRect) -> Touch`
     
     - Parameters:
     - touchLocation: Current location of the touch
     - chartSize: The size of the chart view as the parent view.
     */
    func setTouchInteraction(touchLocation: CGPoint, chartSize: CGRect)
    
    /// A type representing a view for the results of the touch interaction.
    associatedtype Touch: View
    
    /**
     Takes touch location and return a view based on the chart type and configuration.
     
     Inputs from `setTouchInteraction(touchLocation: CGPoint, chartSize: CGRect)`
     
     - Parameters:
     - touchLocation: Current location of the touch
     - chartSize: The size of the chart view as the parent view.
     - Returns: The relevent view for the chart type and options.
     */
    func getTouchInteraction(touchLocation: CGPoint, chartSize: CGRect) -> Touch
    
    
    /// Informs the data model that touch
    /// input has finished.
    func touchDidFinish()
}

extension Touchable where Marker == LineMarkerType {
    public static var defualtTouchMarker: LineMarkerType { .full(attachment: .line(dot: .style(DotStyle()))) }
}

extension Touchable where Marker == BarMarkerType {
    public static var defualtTouchMarker: BarMarkerType { .full() }
}

extension Touchable where Marker == PieMarkerType {
    public static var defualtTouchMarker: PieMarkerType { .none }
}