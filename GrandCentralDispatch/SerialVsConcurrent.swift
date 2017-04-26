//
//  SerialVsConcurrent.swift
//  GrandCentralDispatch
//
//  Created by Techmaster on 9/7/16.
//  Copyright © 2016 Techmaster Vietnam. All rights reserved.
//

import UIKit

class SerialVsConcurrent: ConsoleScreen {

    var serialQueue: DispatchQueue?
    var concurrentQueue: DispatchQueue?
    override func viewDidLoad() {
        super.viewDidLoad()
        //demoSerialQueue()
        demoConcurrentQueue()
    }
    
    func demoSerialQueue() {
        self.writeln("Serial: tác vụ hoàn thành theo thứ tự vào queue")
        serialQueue = DispatchQueue(label: "vn.techmaster.SerialQueue", attributes: [])
        guard serialQueue != nil else {
            return
        }
        serialQueue!.async {
            self.heavyTask1()
        }
        
        serialQueue!.async {
            self.heavyTask2()
        }
    }
    
    func demoConcurrentQueue(){
        self.writeln("Concurrent: Tác vụ xong trước, trả về trước")
        concurrentQueue = DispatchQueue(label: "vn.techmaster.ConcurrentQueue", attributes: DispatchQueue.Attributes.concurrent)
        
        guard concurrentQueue != nil else {
            return
        }
        concurrentQueue!.async {
            self.heavyTask1()
        }
        
        concurrentQueue!.async {
            self.heavyTask2()
        }
    }
    
    func heavyTask1() {
        sleep(Random.within(1, 3))
        DispatchQueue.main.async { 
            self.writeln("heavy task 1 completes")
        }
    }
    func heavyTask2() {
        sleep(Random.within(1, 3))
        DispatchQueue.main.async {
            self.writeln("heavy task 2 completes")
        }
    }
}
