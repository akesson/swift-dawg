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

    let processingQueue = DispatchQueue(label: "processing")
    
    var trie = Trie() {
        didSet {
            DispatchQueue.main.async {
                self.buttonWriteTrie.isEnabled = true
                self.queryField.isEnabled = true
            }
        }
    }
    
    var statusText = "" {
        didSet {
            DispatchQueue.main.async {
                self.statusTextField.stringValue = self.statusText
                print(self.statusText)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        queryField.delegate = self
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    @IBOutlet weak var buttonWriteTrie: NSButton!
    @IBOutlet weak var queryField: NSTextField!
    @IBOutlet weak var statusTextField: NSTextField!
    @IBOutlet var proposalsText: NSTextView!
    
    @IBAction func buttonReadTrieTapped(_ sender: Any) {
        let dialog = NSOpenPanel(fileEnding: "trie")
        dialog.begin { (response) in
            if response == NSApplication.ModalResponse.OK, let path = dialog.url {
                self.processingQueue.async {
                    self.loadTrie(path: path)
                }
            }
        }
    }
    
    @IBAction func buttonLoadCSVTapped(_ sender: Any) {
        
        let dialog = NSOpenPanel(fileEnding: "csv")
        dialog.begin { (response) in
            if response == NSApplication.ModalResponse.OK, let path = dialog.url {
                self.processingQueue.async {
                    self.loadCSV(path: path)
                }
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
                    self.processingQueue.async {
                        self.writeTrie(path: path)
                    }
                }
            }
        }
    }
    
    func loadCSV(path: URL) {
        statusText = "read \(path)"

        do {
            try time({
                trie = try Trie(csvFile: path)
            }, then: { (seconds) in
                statusText = "csv read in \(seconds) seconds"
            })
        } catch {
            print(error.localizedDescription)
            statusText = error.localizedDescription
        }
    }
    
    func loadTrie(path: URL) {
        statusText = "read \(path)"
        do {
            try time({
                trie = try Trie(trieFile: path)
            }, then: { (seconds) in
                statusText = "trie read in \(seconds) seconds"
            })
        } catch {
            print(error.localizedDescription)
            statusText = error.localizedDescription
        }
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

extension ViewController: NSTextFieldDelegate {
    func controlTextDidChange(_ obj: Notification) {
        let searchString = queryField.stringValue
        let maxDistance = distanceFromString(length: searchString.count)
        var matchCount = 0
        time({
            let matches = trie.approximateMatches(for: searchString, maxDistance: maxDistance)
            matchCount = matches.count
            
            var proposals = [String]()
            for distance in 0..<(maxDistance + 1) {
                let distanceProposals = matches.dict.filter({ $0.value == distance }).map({ $0.key })
                proposals.append(contentsOf: distanceProposals)
            }
            proposalsText.string = proposals.joined(separator: "\n")
        }, then: { (seconds) in
            statusText = "searched (maxDistance: \(maxDistance), matches: \(matchCount)) in \(seconds)"
        })
    }
    
    func distanceFromString(length: Int) -> Int {
        if length <= 1 {
            return 0
        } else if length <= 5 {
            return 1
        } else if length <= 7 {
            return 2
        } else {
            return 3
        }
    }
}
