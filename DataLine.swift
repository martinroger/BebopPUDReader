//
//  DataLine.swift
//  Bebop PUD Reader
//
//  Created by Martin ROGER on 18/02/2015.
//  Copyright (c) 2015 Martin ROGER. All rights reserved.
//

import Foundation

struct dataLine {
    var timeStamp: Int = 0
    var batteryLevel: Int = 0
    var controllerGPSLongitute: Double = 0.0
    var controllerGPSLatitude: Double = 0.0
    var flyingState: Int = 0
    var alertState: Int = 0
    var wifiStrength: Int = 0
    var productGPSAvailable: Bool = false
    var productGPSLongitude: Double = 0.0
    var productGPSLatitude: Double = 0.0
    var productGPSPositionError: Int = 0
    var speedVx: Float = 0.0
    var speedVy: Float = 0.0
    var speedVz: Float = 0.0
    var anglePhi: Float = 0.0
    var angleTheta: Float = 0.0
    var anglePsi: Float = 0.0
    var altitude: Int = 0
    var flipType: Int = 0
}