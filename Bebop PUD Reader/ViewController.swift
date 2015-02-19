//
//  ViewController.swift
//  Bebop PUD Reader
//
//  Created by Martin ROGER on 18/02/2015.
//  Copyright (c) 2015 Martin ROGER. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

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
    }
    @IBAction func saveKMLFilePressed(sender: NSButton) {
    }
    @IBAction func saveCSVFilePressed(sender: NSButton) {
    }

    func updateDisplay() {
        
    }
    
    func openPUDFile() {
        
    }
    
    func saveCSVFile() {
        
    }
    
}

