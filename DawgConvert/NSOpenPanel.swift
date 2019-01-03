//
//  NSOpenPanel.swift
//  DawgConvert
//
//  Created by Henrik Akesson on 03/01/2019.
//  Copyright © 2019 Henrik Akesson. All rights reserved.
//

import Cocoa

extension NSOpenPanel {
    convenience init(fileEnding: String) {
        self.init()
        self.title = "Choose a .\(fileEnding) file"
        self.showsResizeIndicator = true
        self.showsHiddenFiles = false
        self.canChooseDirectories = true
        self.canCreateDirectories = false
        self.allowsMultipleSelection = false
        self.allowedFileTypes = [fileEnding]
    }
}
