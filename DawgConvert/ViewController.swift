//
//  ViewController.swift
//  DawgConvert
//
//  Created by Henrik Akesson on 03/01/2019.
//  Copyright © 2019 Henrik Akesson. All rights reserved.
//

import Cocoa
import dawg

class ViewController: NSViewController {

    var trie: Trie?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    @IBOutlet weak var buttonWriteTrie: NSButton!
    @IBOutlet weak var queryField: NSTextField!
    @IBOutlet weak var statusText: NSTextField!
    
    @IBAction func buttonLoadCSVTapped(_ sender: Any) {
        
        let dialog = NSOpenPanel()
        
        dialog.title = "Choose a .csv file"
        dialog.showsResizeIndicator = true
        dialog.showsHiddenFiles = false
        dialog.canChooseDirectories = true
        dialog.canCreateDirectories = false
        dialog.allowsMultipleSelection = false
        dialog.allowedFileTypes = ["csv"]
        
        if dialog.runModal() == NSApplication.ModalResponse.OK {
            if let path = dialog.url {
                loadCSV(path: path)
            }
        }
    }
    
    @IBAction func buttonWriteTrieTapped(_ sender: Any) {
        
        let dialog = NSSavePanel()
        
        dialog.title = "Destination file"
        dialog.showsResizeIndicator = true
        dialog.allowedFileTypes = ["flex"]
        
        dialog.begin { (result) in
            if result == NSApplication.ModalResponse.OK {
                if let path = dialog.url?.path {
                    self.writeTrie(path: path)
                }
            }
        }
    }
    
    func loadCSV(path: URL) {
        print("load \(path)")
        statusText.stringValue = "load \(path)"
        buttonWriteTrie.isEnabled = true
        queryField.isEnabled = true
        
        time({
            do {
                trie = try Trie(file: path)
            } catch {
                print(error)
            }
        }, then: { (seconds) in
            statusText.stringValue = "processed in \(seconds) seconds"
            print("processed in \(seconds) seconds")
        })
    }
    
    func writeTrie(path: String) {
        print("write \(path)")
    }
}

func time(_ block: () throws -> Void, then onCompletion: (_ seconds: Double) -> Void) rethrows {
    let start = Date()
    try block()
    let stop = Date()
    let secs = stop.timeIntervalSince(start)
    onCompletion(secs)
}
