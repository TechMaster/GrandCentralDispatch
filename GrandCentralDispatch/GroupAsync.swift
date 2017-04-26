//
//  GroupAsync.swift
//  GrandCentralDispatch
//
//  Created by Techmaster on 9/7/16.
//  Copyright © 2016 Techmaster Vietnam. All rights reserved.
//  Read this http://commandshift.co.uk/blog/2014/03/19/using-dispatch-groups-to-wait-for-multiple-web-services/

import UIKit

class GroupAsync: UIViewController {

    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var progress1: UIProgressView!
    @IBOutlet weak var progress2: UIProgressView!
    @IBOutlet weak var progress3: UIProgressView!
    @IBOutlet weak var progress4: UIProgressView!
    @IBOutlet weak var imageDone: UIImageView!
    
    var groupTasks: DispatchGroup?
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
    }
    
    func initUI() {
        progress1.progress = 0.0
        progress2.progress = 0.0
        progress3.progress = 0.0
        progress4.progress = 0.0
        imageDone.isHidden = true
        
    }

    @IBAction func startAllTasks(_ sender: UIButton) {
        initUI()
        startButton.isEnabled = false
        groupTasks = DispatchGroup()
        //let backgroundQueue = DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.background)
        let backgroundQueue = DispatchQueue.global(qos: .background)
        backgroundQueue.async(group: groupTasks!) {
            self.heavyTask(1)
        }
        
        backgroundQueue.async(group: groupTasks!) {
            self.heavyTask(2)
        }
        
        backgroundQueue.async(group: groupTasks!) {
            self.heavyTask(3)
        }
        
        backgroundQueue.async(group: groupTasks!) {
            self.heavyTask(4)
        }
        
        groupTasks!.notify(queue: DispatchQueue.main) {
            self.imageDone.isHidden = false
            self.startButton.isEnabled = true
        }
        
        //Block main thread until all tasks done
        /*dispatch_group_wait(groupTasks!, DISPATCH_TIME_FOREVER)
         self.imageDone.hidden = false
         self.startButton.enabled = true
         */
        
        
        
    }
    
    func heavyTask(_ n: Int) {
        let counter = 100
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
