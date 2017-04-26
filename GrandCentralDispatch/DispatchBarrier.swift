//
//  DispatchBarrier.swift
//  GrandCentralDispatch
//
//  Created by Techmaster on 9/8/16.
//  Copyright © 2016 Techmaster Vietnam. All rights reserved.
//

import UIKit

class DispatchBarrier: UIViewController {

    
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var progress1: UIProgressView!
    @IBOutlet weak var progress2: UIProgressView!
    @IBOutlet weak var progress3: UIProgressView!
    @IBOutlet weak var progress4: UIProgressView!
    @IBOutlet weak var imageDone: UIImageView!
    
    lazy var concurrentQueue : DispatchQueue = {
        return DispatchQueue(label: "vn.techmaster.concurrentQueue", attributes: .concurrent)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = UIRectEdge()
        initUI()
    }

    func initUI() {
        progress1.progress = 0.0
        progress2.progress = 0.0
        progress3.progress = 0.0
        progress4.progress = 0.0
        imageDone.isHidden = true
        
    }

    
    @IBAction func startAllTasks(_ sender: AnyObject) {
        initUI()
        concurrentQueue.async { 
            self.heavyTask(1)
        }
        concurrentQueue.async {
            self.heavyTask(2)
        }
        concurrentQueue.async(flags: .barrier, execute: { 
            self.heavyTask(3)
        }) 
        concurrentQueue.async(flags: .barrier, execute: {
            self.heavyTask(4)
            
            DispatchQueue.main.async(execute: { 
                self.imageDone.isHidden = false
                self.startButton.isEnabled = true
            })
        }) 
    }
    
    func heavyTask(_ n: Int) {
        let counter = 1000
        for _ in 1...counter {
            usleep(Random.within(800, 8000))
            DispatchQueue.main.async {
                switch n {
                case 1:
                    self.progress1.progress += 1.0 / Float(counter)
                case 2:
                    self.progress2.progress += 1.0 / Float(counter)
                case 3:
                    self.progress3.progress += 1.0 / Float(counter)
                default:
                    self.progress4.progress += 1.0 / Float(counter)
                    
                }
            }
        }
    }

  
}
