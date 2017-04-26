//
//  random.swift
//  GrandCentralDispatch
//
//  Created by Techmaster on 9/7/16.
//  Copyright © 2016 Techmaster Vietnam. All rights reserved.
//

import Foundation
struct Random {
    static func within(_ start: Int, _ end: Int) -> Int {
        return Int(Float(end - start) * Float(arc4random()) / Float(Int32.max)) + start
    }
    
    static func within(_ start: UInt32, _ end: UInt32) -> UInt32 {
        return UInt32(Float(end - start) * Float(arc4random()) / Float(UInt32.max)) + start
    }

    
    static func within(_ start: Float, _ end: Float) -> Float {
        return (end - start) * Float(Float(arc4random()) / Float(UInt32.max)) + start
    }
    
    static func within(_ start: Double, _ end: Double) -> Double {
     
     return (end - start) * Double(Double(arc4random()) / Double(UInt32.max)) + start
    }
    
    static func generate() -> Int {
        return Random.within(0, 1)
    }
    
    static func generate() -> Bool {
        return Random.generate() == 0
    }
    
    static func generate() -> Float {
        return Random.within(0.0, 1.0)
    }
    
    static func generate() -> Double {
        return Random.within(0.0, 1.0)
    }
}
