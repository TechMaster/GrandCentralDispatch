//
//  SyncVsAsync.swift
//  GrandCentralDispatch
//
//  Created by Techmaster on 9/6/16.
//  Copyright © 2016 Techmaster Vietnam. All rights reserved.
//

import UIKit

class SyncVsAsync: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()        
    }


    @IBAction func doHeavyTaskInMainThread(_ sender: UIButton) {
        self.heavyTask()
    }

    @IBAction func doHeavyTaskInConcurrentQueue(_ sender: UIButton) {
        DispatchQueue.global(qos: .background).async {
            self.heavyTask()
        }
    }
    
    func heavyTask() {
        sleep(2)
    }
}
