//
//  ViewController.swift
//  Bebop PUD Reader
//
//  Created by Martin ROGER on 18/02/2015.
//  Copyright (c) 2015 Martin ROGER. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    var jsonUsefulInfos = [ NSString : NSString ]() //Dictionary linked to fun extractUsefulJSONData
    var hashedData = [dataLine]()//array of dataLines is final product that needs to be typecase to String for CSV
    var rawData = binaryRAW()
    
    @IBOutlet weak var currentStatus: NSTextField!
    @IBOutlet weak var flightDateToDisplay: NSTextField!
    @IBOutlet weak var serialNumberToDisplay: NSTextField!
    @IBOutlet weak var uuidToDisplay: NSTextField!
    @IBOutlet weak var flightDurationToDisplay: NSTextField!
    @IBOutlet weak var maxHeightToDisplay: NSTextField!
    @IBOutlet weak var maxSpeedToDisplay: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @IBAction func loadPUDFilePressed(sender: NSButton) {

            self.currentStatus.stringValue = "Opening PUD File"
        rawData.binaryRaw = self.openPUDFile()
        if rawData.binaryRaw.length != 0 //only proceed with operations if OK button has been pressed and data is not empty
        {
            rawData.scindRawData(rawData.findEndOfJSON())
                self.currentStatus.stringValue = "JSON end found"
            jsonUsefulInfos = self.extractUsefulJSONData(rawData.jsonData)
                self.currentStatus.stringValue = "JSON header parsed"
            hashedData = parseRAWData(rawData.flightData)
            /* uncomment to debug parsed values
            var counter: Int = 0
            for index in hashedData {
            
                println("\(counter)" + " " + "\(index.productGPSAvailable)")
                counter++
            }*/
                self.currentStatus.stringValue = "RAW data parsed"
            updateDisplay(hashedData)
            self.currentStatus.stringValue = "Infos updated"
        
            self.currentStatus.stringValue = "Ready to save"
        }
    }
    
    @IBAction func saveKMLFilePressed(sender: NSButton) {
        self.currentStatus.stringValue = "KML file saving not yet implemented"
    }
    
    @IBAction func saveCSVFilePressed(sender: NSButton) {
        var resultStringToWrite = String()
        var headerStringToWrite = "TimeStamp;Battery Level;Controller GPS Longitude;Controller GPS Latitude;Flying State;Alert State;Wifi Strength;Product GPS Available;Product GPS Longitude;Product GPS Latitude;Product GPS Position Error;Speed Vx;Speed Vy;Speed Vz;Angle Phi;Angle Theta;Angle Psi;Altitude;Flip Type\n"
        if hashedData.isEmpty == false {
            self.currentStatus.stringValue = "Saving..."
            resultStringToWrite = headerStringToWrite + generateResultString(hashedData)
            var saveFileDialog: NSSavePanel = NSSavePanel()
            saveFileDialog.allowedFileTypes = [ "csv" ]
            saveFileDialog.canCreateDirectories = true
            saveFileDialog.beginWithCompletionHandler { (result) -> Void in
                if result == NSFileHandlingPanelOKButton
                {
                    resultStringToWrite.writeToURL(saveFileDialog.URL!, atomically: true, encoding: NSUTF8StringEncoding, error: nil)
                    self.currentStatus.stringValue = "CSV file saved"
                    
                }
            }

            
        }
    }

    func updateDisplay(data: [ dataLine ]) {
        self.flightDateToDisplay.stringValue = jsonUsefulInfos["date"]!
        self.serialNumberToDisplay.stringValue = jsonUsefulInfos["serialnumber"]!
        self.uuidToDisplay.stringValue = jsonUsefulInfos["uuid"]!
        
        var maxHeight: Int32 = 0
        var maxSpeed: Float = 0.0
        var flightDuration: Double = 0.0
        for index in data {
            if maxHeight < index.altitude {
                maxHeight = index.altitude
            }
            if maxSpeed < sqrt(index.speedVx * index.speedVx + index.speedVy * index.speedVy + index.speedVz * index.speedVz) {
                maxSpeed = sqrt(index.speedVx * index.speedVx + index.speedVy * index.speedVy + index.speedVz * index.speedVz)
            }
        }
        flightDuration = (Double(data[data.count - 1].timeStamp)) / 1000.0
        self.flightDurationToDisplay.stringValue = String(format: "%.2f", flightDuration) + " s"
        self.maxHeightToDisplay.stringValue = String(format: "%.2f", Float(maxHeight)/1000.0) + " m"
        self.maxSpeedToDisplay.stringValue = String(format: "%.2f", maxSpeed) + "m/s"
    }
    
    func openPUDFile() -> NSData {
        var raw = NSData()
        var openFileDialog: NSOpenPanel = NSOpenPanel()
        openFileDialog.allowsMultipleSelection = false
        openFileDialog.canChooseDirectories = false
        openFileDialog.runModal()
        var chosenFile = openFileDialog.URL
        if chosenFile != nil
        {
            raw = NSData(contentsOfURL: chosenFile!)!
        }
        return raw
    }
    
    func generateResultString(byteHashedData: [dataLine]) -> String {
        //Il va falloir faire une seule grosse String avec des \n et la writeToUrl et l'entête
        var result = String()
        for tempDataLine in byteHashedData {
            result = result + "\(tempDataLine.timeStamp)" + ";"
            result = result + ("\(tempDataLine.batteryLevel)" + ";")
            result = result + (String(format: "%f", tempDataLine.controllerGPSLongitude) + ";")
            result = result + (String(format: "%f", tempDataLine.controllerGPSLatitude) + ";")
            result = result + ("\(tempDataLine.flyingState)" + ";")
            result = result + ("\(tempDataLine.alertState)" + ";")
            result = result + ("\(tempDataLine.wifiStrength)" + ";")
            result = result + ("\(tempDataLine.productGPSAvailable)" + ";")
            result = result + (String(format: "%f", tempDataLine.productGPSLongitude) + ";")
            result = result + (String(format: "%f", tempDataLine.productGPSLatitude) + ";")
            result = result + ("\(tempDataLine.productGPSPositionError)" + ";")
            result = result + (String(format: "%f", tempDataLine.speedVx) + ";")
            result = result + (String(format: "%f", tempDataLine.speedVy) + ";")
            result = result + (String(format: "%f", tempDataLine.speedVz) + ";")
            result = result + (String(format: "%f", tempDataLine.anglePhi) + ";")
            result = result + (String(format: "%f", tempDataLine.angleTheta) + ";")
            result = result + (String(format: "%f", tempDataLine.anglePsi) + ";")
            result = result + ("\(tempDataLine.altitude)" + ";")
            result = result + ("\(tempDataLine.flipType)") + "\n"
        }
        return result
    }
    
    func extractUsefulJSONData(JSONData: NSData) -> [ NSString : NSString ] {
        var infos = [ NSString : NSString ]()
        var readableDate = NSString()
        var originalDate = NSString()
        let jsonObject: AnyObject! = NSJSONSerialization.JSONObjectWithData(JSONData, options: NSJSONReadingOptions.MutableContainers, error: nil)
        if let JSONDict = jsonObject as? NSDictionary {
            if let date = JSONDict["date"] as? NSString {
                infos["date"] = date
            }
            if let serialnumber = JSONDict["serial_number"] as? NSString {
                infos["serialnumber"] = serialnumber
            }
            if let uuid = JSONDict["uuid"] as? NSString {
                infos["uuid"] = uuid
            }
        }
        originalDate = infos["date"]!
        readableDate = readableDate + originalDate.substringWithRange(NSMakeRange(11,2)) + "H" + originalDate.substringWithRange(NSMakeRange(13, 2)) + ":" + originalDate.substringWithRange(NSMakeRange(15, 2)) + " on "
        readableDate = readableDate + originalDate.substringWithRange(NSMakeRange(8, 2)) + "/" + originalDate.substringWithRange(NSMakeRange(5, 2)) + "/" + originalDate.substringWithRange(NSMakeRange(0,4))
        infos["date"] = readableDate
        return infos
    }
    
    func parseRAWData(data: NSData) -> [dataLine] {
        var result = [dataLine]()
        var currentLine = dataLine()
        var tempData = NSData()
        var byteIndex = 0
        while (byteIndex * 77) < data.length
        {
            data.getBytes(&currentLine.timeStamp, range : NSMakeRange(byteIndex*77,4))
            data.getBytes(&currentLine.batteryLevel, range: NSMakeRange(byteIndex*77 + 4, 4))
            data.getBytes(&currentLine.controllerGPSLongitude, range: NSMakeRange(byteIndex*77 + 8, 8))
            data.getBytes(&currentLine.controllerGPSLatitude, range: NSMakeRange(byteIndex*77 + 16, 8))
            data.getBytes(&currentLine.flyingState, range: NSMakeRange(byteIndex*77 + 24, 1))
            data.getBytes(&currentLine.alertState, range: NSMakeRange(byteIndex*77 + 25, 1))
            data.getBytes(&currentLine.wifiStrength, range: NSMakeRange(byteIndex*77 + 26, 1))
            data.getBytes(&currentLine.productGPSAvailable, range: NSMakeRange(byteIndex*77 + 27, 1))
            data.getBytes(&currentLine.productGPSLongitude, range: NSMakeRange(byteIndex*77 + 28, 8))
            data.getBytes(&currentLine.productGPSLatitude, range: NSMakeRange(byteIndex*77 + 36, 8))
            data.getBytes(&currentLine.productGPSPositionError, range: NSMakeRange(byteIndex*77 + 44, 4))
            data.getBytes(&currentLine.speedVx, range: NSMakeRange(byteIndex*77 + 48, 4))
            data.getBytes(&currentLine.speedVy, range: NSMakeRange(byteIndex*77 + 52, 4))
            data.getBytes(&currentLine.speedVz, range: NSMakeRange(byteIndex*77 + 56, 4))
            data.getBytes(&currentLine.anglePhi, range: NSMakeRange(byteIndex*77 + 60, 4))
            data.getBytes(&currentLine.angleTheta, range: NSMakeRange(byteIndex*77 + 64, 4))
            data.getBytes(&currentLine.anglePsi, range: NSMakeRange(byteIndex*77 + 68, 4))
            data.getBytes(&currentLine.altitude, range: NSMakeRange(byteIndex*77 + 72, 4))
            data.getBytes(&currentLine.flipType, range: NSMakeRange(byteIndex*77 + 76, 1))
            result.append(currentLine)
            byteIndex++
        }
        return result
    }
    
    
}

