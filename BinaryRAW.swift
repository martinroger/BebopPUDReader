//
//  BinaryRAW.swift
//  Bebop PUD Reader
//
//  Created by Martin ROGER on 18/02/2015.
//  Copyright (c) 2015 Martin ROGER. All rights reserved.
//

import Foundation

class binaryRAW {
    var binaryRaw = NSData()
    var jsonData = NSData()
    var flightData = NSData()
    
    func findEndOfJSON() -> Int {
        var endOfJSONIndex: Int = 0
        var openCurly: Int = 0
        var closedCurly: Int = 0
        while(true) {
            if NSString(data: self.binaryRaw.subdataWithRange(NSMakeRange(endOfJSONIndex , 1)), encoding: NSUTF8StringEncoding)! == "{" {
                openCurly++
            }
            if NSString(data: self.binaryRaw.subdataWithRange(NSMakeRange(endOfJSONIndex , 1)), encoding: NSUTF8StringEncoding)! == "}" {
                closedCurly++
            }
            endOfJSONIndex++
            //breakout condition
            if openCurly == closedCurly {
                break
            }
        }
        return endOfJSONIndex
    }
    
    func scindRawData(index: Int) {
        self.jsonData = self.binaryRaw.subdataWithRange(NSMakeRange(0, index))
        self.flightData = self.binaryRaw.subdataWithRange(NSMakeRange(index , binaryRaw.length - index )) //gros doute
    }
    
}