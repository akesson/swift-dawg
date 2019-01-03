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

    var trie = Trie() {
        didSet {
            buttonWriteTrie.isEnabled = true
            queryField.isEnabled = true
        }
    }
    
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
    
    @IBAction func buttonReadTrieTapped(_ sender: Any) {
        let dialog = NSOpenPanel(fileEnding: "trie")
        dialog.begin { (response) in
            if response == NSApplication.ModalResponse.OK, let path = dialog.url {
                self.loadTrie(path: path)
            }
        }
    }
    
    @IBAction func buttonLoadCSVTapped(_ sender: Any) {
        
        let dialog = NSOpenPanel(fileEnding: "csv")
        dialog.begin { (response) in
            if response == NSApplication.ModalResponse.OK, let path = dialog.url {
                self.loadCSV(path: path)
            }
        }
    }
    
    @IBAction func buttonWriteTrieTapped(_ sender: Any) {
        
        let dialog = NSSavePanel()
        
        dialog.title = "Destination file"
        dialog.showsResizeIndicator = true
        dialog.allowedFileTypes = ["trie"]
        
        dialog.begin { (result) in
            if result == NSApplication.ModalResponse.OK {
                if let path = dialog.url {
                    self.writeTrie(path: path)
                }
            }
        }
    }
    
    func loadCSV(path: URL) {
        statusText = "read \(path)"
        
        time({
            do {
                trie = try Trie(csvFile: path)
            } catch {
                statusText = error.localizedDescription
            }
        }, then: { (seconds) in
            statusText = "csv read in \(seconds) seconds"
        })
    }
    
    func loadTrie(path: URL) {
        statusText = "read \(path)"
        time({
            do {
                trie = try Trie(trieFile: path)
            } catch {
                statusText = error.localizedDescription
            }
        }, then: { (seconds) in
            statusText = "trie read in \(seconds) seconds"
        })
    }
    
    func writeTrie(path: URL) {
        statusText = "write \(path)"
        
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
