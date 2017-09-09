//
//  NSString++.swift
//  ios-github-app
//
//  Created by Andrii Zaitsev on 8/18/17.
//  Copyright © 2017 Andrii Zaitsev. All rights reserved.
//

import Foundation

let NotFound: Int = -1

extension NSString {

    func findSubstring(_ target: NSString) -> Int {
        if target.length < 1 {
            return NotFound
        }
        
        var selfIt: Int = 0
        var targetIt: Int = 0
        
        while (selfIt < length - target.length) {
            if (character(at: selfIt) == target.character(at: targetIt)) {
                selfIt += 1
                targetIt += 1
                if (targetIt == target.length) {
                    return selfIt - (targetIt - 1)
                }
            } else {
                selfIt += 1
                targetIt = 0
            }
        }
        
        return NotFound
    }
    
    func substring(from: Int, to: Int) -> NSString? {
        if (from > to || from < 0 || to > length) {
            return nil
        }
        
        var index = from
        var buffer = Array<unichar>()
        while index < to {
            buffer.append(character(at: index))
            index += 1
        }
        
        return NSString(characters: buffer, length: buffer.count)
    }
    
}
