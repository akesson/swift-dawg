//
//  Character.swift
//  Dawg macOS
//
//  Created by Henrik Akesson on 04/01/2019.
//  Copyright © 2019 Henrik Akesson. All rights reserved.
//

import Foundation

extension Character {
    
    var asScalars: [UInt32] {
        return self.unicodeScalars.map({ $0.value })
    }
}
