//
//  DispatchOnce.swift
//  GrandCentralDispatch
//
//  Created by Techmaster on 9/8/16.
//  Copyright © 2016 Techmaster Vietnam. All rights reserved.
//

import UIKit

class DispatchOnce: ConsoleScreen {

    private lazy var __once: () = {
                self.writeln("This runs only one")
            }()

    override func viewDidLoad() {
        super.viewDidLoad()

        var token: Int = 0
        func test(_ i: Int) {
            _ = self.__once
            self.writeln("print \(i)")
        }
        
        for i in 0..<4 {
            test(i)
        }
    }

    
}
