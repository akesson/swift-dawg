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
    var statusText = "" {
        didSet {
            statusTextField.stringValue = statusText
            print(statusText)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    @IBOutlet weak var buttonWriteTrie: NSButton!
    @IBOutlet weak var queryField: NSTextField!
    @IBOutlet weak var statusTextField: NSTextField!
    
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
                if let path = dialog.url {
                    self.writeTrie(path: path)
                }
            }
        }
    }
    
    func loadCSV(path: URL) {
        statusText = "load \(path)"
        buttonWriteTrie.isEnabled = true
        queryField.isEnabled = true
        
        time({
            do {
                trie = try Trie(file: path)
            } catch {
                statusText = error.localizedDescription
            }
        }, then: { (seconds) in
            statusText = "csv loaded in \(seconds) seconds"
        })
    }
    
    func writeTrie(path: URL) {
        statusText = "write \(path)"
        
        guard let trie = trie else {
            statusText = "No trie loaded"
            return
        }
        time({
            do {
                try trie.writeTo(path: path)
            } catch {
                statusText = error.localizedDescription
            }
        }, then: { (seconds) in
            statusText = "trie written in \(seconds) seconds"
        })
    }
}

func time(_ block: () throws -> Void, then onCompletion: (_ seconds: Double) -> Void) rethrows {
    let start = Date()
    try block()
    let stop = Date()
    let secs = stop.timeIntervalSince(start)
    onCompletion(secs)
}
