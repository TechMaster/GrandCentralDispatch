//
//  DeadLock.swift
//  GrandCentralDispatch
//
//  Created by Techmaster on 9/8/16.
//  Copyright © 2016 Techmaster Vietnam. All rights reserved.
//

import UIKit

class DeadLock: ConsoleScreen {

    lazy var queueA = {
        //return DispatchQueue(label: "queueA", attributes: DispatchQueue.Attributes.concurrent)
        return DispatchQueue.init(label: "queueA", qos: DispatchQoS.background, attributes: DispatchQueue.Attributes.concurrent, autoreleaseFrequency: DispatchQueue.AutoreleaseFrequency.inherit, target: nil)
        
        //DispatchQueue.init(label: "Cuong")
    }()
    
    lazy var queueB = {
        //return DispatchQueue(label: "queueB", attributes: DispatchQueue.Attributes.concurrent)
        return DispatchQueue.init(label: "queueB", qos: .background, attributes: .concurrent, autoreleaseFrequency: .inherit, target: nil)
    }()
    
    
    lazy var semaphoreA = {
        //Passing zero for the value is useful for when two threads need to reconcile
        //the completion of a particular event.
        return DispatchSemaphore(value: 0)
    }()
    
    lazy var semaphoreB = {
        return DispatchSemaphore(value: 0)
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.taskA()
      
    }
    
    func taskA() {
        if semaphoreB.wait(timeout: DispatchTime.distantFuture) ==  DispatchTimeoutResult.success {
            queueB.async {
                self.heavyTaskB()
            }
            
            self.writeln("Task A done")
            semaphoreA.signal()
        }
        

    }
    
    func heavyTaskB() {
        if semaphoreA.wait(timeout: DispatchTime.distantFuture) == DispatchTimeoutResult.success {
            sleep(Random.within(1, 3))
            
            DispatchQueue.main.async {
                self.writeln("Task B done")
            }
            semaphoreB.signal()
        }        

    }
    
}
