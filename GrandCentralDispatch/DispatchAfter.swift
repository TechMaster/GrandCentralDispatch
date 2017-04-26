//
//  DispatchAfter.swift
//  GrandCentralDispatch
//
//  Created by Techmaster on 9/8/16.
//  Copyright © 2016 Techmaster Vietnam. All rights reserved.
//

import UIKit

class DispatchAfter: UIViewController {

    @IBOutlet weak var delaySlider: UISlider!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var progressTask: UIProgressView!
    var taskIsRunning: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = UIRectEdge()
        delaySlider.minimumValue = 0.1  //second
        delaySlider.maximumValue = 2.0  //second
        delaySlider.value = 1.0
    }
    @IBAction func onSliderDelayChange(_ sender: UISlider) {
        startButton.setTitle("Run task after \(delaySlider.value) seconds", for: UIControlState())
    }

    @IBAction func startATask(_ sender: AnyObject) {
        progressTask.progress = 0.0
        startButton.isEnabled = false
        DispatchQueue.global(qos: .default).asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(Double(delaySlider.value) * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {
                self.heavyTask({
                    DispatchQueue.main.async {
                        self.startButton.isEnabled = true
                    }
                })
        })
        
    }

    //Call notifyDone when heavyTask completes
    func heavyTask(_ notifyDone: ()->()) {
        let counter = 1000
        for _ in 1...counter {
            usleep(Random.within(800, 8000))
            DispatchQueue.main.async {
                self.progressTask.progress += 1.0 / Float(counter)
            }
        }
        notifyDone()
        
        
    }
    
    

}
