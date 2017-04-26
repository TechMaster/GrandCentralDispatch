//
//  Unsynchronize.swift
//  GrandCentralDispatch
//
//  Created by Techmaster on 9/9/16.
//  Copyright © 2016 Techmaster Vietnam. All rights reserved.
//  khi chạy sẽ bị crash ở self.number = Int(arc4random())
// hoặc giá trị khi set và get sẽ không giống nhau

import UIKit

class Unsynchronize: ConsoleScreen {

    lazy var queue = {
        //return DispatchQueue(label: "ConcurrentQueue", attributes: DispatchQueue.Attributes.concurrent)
        return DispatchQueue.init(label: "ConcurrentQueue", qos: DispatchQoS.background, attributes: DispatchQueue.Attributes.concurrent, autoreleaseFrequency: DispatchQueue.AutoreleaseFrequency.inherit, target: nil)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        demoUnsynchronize()
        
    }

    var number: Int = 0
    func demoUnsynchronize() {
        
        for i in 1...10 {
            queue.async(execute: {
                usleep(Random.within(8000,18000))
                
                self.number = Int(arc4random()%100) //This cause crashes!
                
                DispatchQueue.main.async(execute: {
                    self.writeln("At \(i) number is set \(self.number)")
                })
                
               
                
                usleep(Random.within(8000, 18000))
                
                DispatchQueue.main.async(execute: {
                    self.writeln("At \(i) number is get \(self.number)")
                })
                
            })
        }
    }


}
