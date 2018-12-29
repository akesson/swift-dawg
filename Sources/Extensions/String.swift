//
//  String.swift
//  dawg
//
//  Created by Henrik Akesson on 29/12/2018.
//  Copyright © 2018 Henrik Akesson. All rights reserved.
//

import Foundation

extension String {
    subscript(index: Int) -> Character {
        return self[self.index(self.startIndex, offsetBy: index)]
    }
}
