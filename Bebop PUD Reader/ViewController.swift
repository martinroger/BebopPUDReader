//
//  ViewController.swift
//  Bebop PUD Reader
//
//  Created by Martin ROGER on 18/02/2015.
//  Copyright (c) 2015 Martin ROGER. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    var jsonUsefulInfos = [ String : String ]() //Dictionary linked to fun extractUsefulJSONData
    var hashedData = [dataLine]()               //array of dataLines is final product that needs to be typecase to String for CSV

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
        var rawData = binaryRAW()
        self.currentStatus.stringValue = "Opening PUD File"
        rawData.binaryRaw = self.openPUDFile()
        //println("File Opened")
        //println(rawData.binaryRaw.length)
        rawData.scindRawData(rawData.findEndOfJSON())
        //println("File cut")
        //println(rawData.jsonData.length)
        //println(rawData.flightData.length)
        self.currentStatus.stringValue = "JSON end found"
        jsonUsefulInfos = self.extractUsefulJSONData(rawData.jsonData)
        self.currentStatus.stringValue = "JSON header parsed"
        
        self.currentStatus.stringValue = "RAW data parsed"
        updateDisplay()
        self.currentStatus.stringValue = "Infos updated"
        
        self.currentStatus.stringValue = "Ready to save"
    }
    @IBAction func saveKMLFilePressed(sender: NSButton) {
        self.currentStatus.stringValue = "KML file saving not yet implemented"
    }
    @IBAction func saveCSVFilePressed(sender: NSButton) {
        self.currentStatus.stringValue = "Saving..."
        saveCSVFile()
        self.currentStatus.stringValue = "CSV file saved"
    }

    func updateDisplay() {
        self.flightDateToDisplay.stringValue = jsonUsefulInfos["date"]!
        self.serialNumberToDisplay.stringValue = jsonUsefulInfos["serialnumber"]!
        self.uuidToDisplay.stringValue = jsonUsefulInfos["uuid"]!
        
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
    
    func saveCSVFile() {
        
    }
    
    func extractUsefulJSONData(JSONData: NSData) -> [ String : String ] {
        var infos = [ String : String ]()
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
        return infos
    }
    
    
}

