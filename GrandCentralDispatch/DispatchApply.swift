//
//  DispatchApply.swift
//  GrandCentralDispatch
//
//  Created by Techmaster on 9/8/16.
//  Copyright © 2016 Techmaster Vietnam. All rights reserved.
//

import UIKit

class DispatchApply: ConsoleScreen {

    lazy var concurrentQueue = {
       return DispatchQueue.global(qos: .default)
    }()
    
    var bigArray = Array(repeating: Array(repeating: 0, count: 100), count: 5)
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.writeln("List max value in each row of 2D array")
        
        let n = bigArray.count;
        
        for i in 0..<n {
            for j in 0..<bigArray[0].count {
                bigArray[i][j] = Random.within(0, 1000)
            }
        }
        DispatchQueue.concurrentPerform(iterations: n) { (i) in
            
            let maxNum = self.bigArray[i].max()!
            
            DispatchQueue.main.async(execute: { 
                self.writeln("\(i) : \(maxNum)")
            })
        }
    }



}
