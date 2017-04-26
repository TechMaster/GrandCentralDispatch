//
//  SemaphoreWait.swift
//  GrandCentralDispatch
//
//  Created by Techmaster on 9/9/16.
//  Copyright © 2016 Techmaster Vietnam. All rights reserved.
//

import UIKit

class SemaphoreWait: UIViewController {

    @IBOutlet weak var progress1: UIProgressView!
    @IBOutlet weak var progress2: UIProgressView!
    @IBOutlet weak var progress3: UIProgressView!
    
    lazy var queueA:DispatchQueue = {
        return DispatchQueue(label: "queueA", attributes: DispatchQueue.Attributes.concurrent)
    }()
    
    
    lazy var queueC:DispatchQueue = {
        return DispatchQueue(label: "queueB", attributes: DispatchQueue.Attributes.concurrent)
    }()
    
    lazy var semaphoreB = {
        //Passing zero for the value is useful for when two threads need to reconcile
        //the completion of a particular event.
        return DispatchSemaphore(value: 0)
    }()
    
    lazy var semaphoreC = {
        return DispatchSemaphore(value: 0)
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.edgesForExtendedLayout = UIRectEdge()
        initUI()
    }
    @IBAction func startDemo(_ sender: UIButton) {
        initUI()
        queueA.async {
            self.taskA()
        }
        
        queueA.async { 
            self.taskB()
        }
        
        queueC.async {
            self.taskC()
        }
        

    }
    func initUI() {
        progress1.progress = 0.0
        progress2.progress = 0.0
        progress3.progress = 0.0
    }
    
    func taskA() {
        let counter = 1000
        for i in 1...counter {
            usleep(Random.within(800,8000))
            DispatchQueue.main.async {
                self.progress1.progress += 1.0 / Float(counter)
            }
            
            if i == counter/2 {
                semaphoreB.signal()
            }
        }
        //End
        semaphoreC.signal()
    }
    
    func taskB() {
        if semaphoreB.wait(timeout: DispatchTime.distantFuture) == DispatchTimeoutResult.success {
            let counter = 1000
            for _ in 1...counter {
                usleep(Random.within(800, 8000))
                DispatchQueue.main.async {
                    self.progress2.progress += 1.0 / Float(counter)
                }
            }
        }
        
    }
    
    func taskC() {
        if semaphoreC.wait(timeout: DispatchTime.distantFuture) == DispatchTimeoutResult.success {
            let counter = 1000
            for _ in 1...counter {
                usleep(Random.within(800, 8000))
                DispatchQueue.main.async {
                    self.progress3.progress += 1.0 / Float(counter)
                }
            }
        }       
    }
}
