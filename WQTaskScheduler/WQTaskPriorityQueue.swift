//
//  WQTaskPriorityQueue.swift
//  WQTaskScheduler
//
//  Created by kris.wang on 2019/1/29.
//  Copyright © 2019年 kris.wang. All rights reserved.
//

import Foundation

/// 拥有优先级的任务
struct WQPriorityTask {
    var taskBlock: WQTaskBlock
    var priority: Int
    var time: TimeInterval
}

/// 有优先级的队列
class WQTaskPriorityQueue {
    
    
}
