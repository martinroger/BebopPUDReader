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
        var rawData = binaryRAW() //This is where all the data will be handled in raw form
        
        self.currentStatus.stringValue = "Opening PUD File"
        rawData.binaryRaw = self.openPUDFile()
        rawData.scindRawData(rawData.findEndOfJSON())
        self.currentStatus.stringValue = "JSON end found"
        jsonUsefulInfos = self.extractUsefulJSONData(rawData.jsonData)
        self.currentStatus.stringValue = "JSON header parsed"
        
        self.currentStatus.stringValue = "RAW data parsed"
        updateDisplay()
        self.currentStatus.stringValue = "Infos updated"
        
        self.currentStatus.stringValue = "Ready to save"
    }
    @IBAction func saveKMLFilePressed(sender: NSButton) {
    }
    @IBAction func saveCSVFilePressed(sender: NSButton) {
        self.currentStatus.stringValue = "Saving..."
        saveCSVFile()
        self.currentStatus.stringValue = "CSV File Saved"
    }

    func updateDisplay() {
        
    }
    
    func openPUDFile() -> NSData {
        var raw = NSData()
        //This should contain the NSOpenPanel sequence
        
        return raw
    }
    
    func saveCSVFile() {
        
    }
    
    func extractUsefulJSONData(JSONData: NSData) -> [ String : String ] {
        var infos = [ String : String ]()
        //somewhere in here use NSJSONSerialization
        
        return infos
    }
    
    
}

