//
//  ViewController.swift
//  WQTaskScheduler
//
//  Created by kris.wang on 2019/1/10.
//  Copyright © 2019年 kris.wang. All rights reserved.
//  任务调度器

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from anib.
        let schedule = WQTaskSchedule(strategy: .taskFIFO)
        schedule.addTask {
            // 具体的操作任务，比较耗时费性能的
            /*
             -------------- 具体业务代码
            */
            
            ///注意：主线程操作一定要写在这里面
            DispatchQueue.main.async {

            }
        }
        
        schedule.maxTaskNum = 10
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

