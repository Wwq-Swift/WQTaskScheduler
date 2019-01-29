//
//  WQTaskSchedule.swift
//  WQTaskScheduler
//
//  Created by kris.wang on 2019/1/29.
//  Copyright © 2019年 kris.wang. All rights reserved.
//

import Foundation


/// 任务调度
class WQTaskSchedule {
    
    /// 操作队列
    var taskQueue = OperationQueue()
    /// 操作队列最大持有任务数目
    var maxTaskNum = 10 {
        didSet {
            strategy?.maxTaskNum = maxTaskNum
        }
    }
    /// 每次执行的任务数目 (最大并发数目)
    var executeMaxTaskNum = 3 {
        didSet {
            taskQueue.maxConcurrentOperationCount = executeMaxTaskNum
        }
    }
    /// 执行频率 （每次消息循环执行的任务数目 默认给 1）
    var executeFrequency = 1
    
    private var strategy: WQTaskSchedulerBaseProtocol?
    
    /// 构造 调度策略  (默认 队列 先进先出)
    init(strategy: WQTaskSchedulerMethodType = .taskFIFO) {
        
        switch strategy {
        case .taskFIFO:
            self.strategy = WQTaskQueue()
            break
        case .taskLIFO:
            self.strategy = WQTaskStack()
        default:
            break
        }
        addRunloopObserver()
    }
    
    /// 添加任务  (提供一个默认优先级)
    func addTask(_ task: @escaping WQTaskBlock, withPriority: WQTaskPriority = .tDefault) {
        strategy?.addTask(task, withPriority: withPriority)
    }
    
    ///清空所有任务
    func clearTasks() {
        strategy?.clearTasks()
    }
    /// 执行任务
    func executeTasks(num: Int) {
        guard let strategy = strategy,
            strategy.isEmpty == false else {
            return
        }
        for _ in 0..<num {
            taskQueue.addOperation {
                strategy.executeTask()
            }
            if strategy.isEmpty == true { return }
        }
    }
    
    /// 添加runloop 监听
    private func addRunloopObserver() {
        /// 主线程的runloop
        let runloop = CFRunLoopGetMain()//CFRunLoopGetCurrent()
        let activities = CFRunLoopActivity.allActivities.rawValue

        let observer = CFRunLoopObserverCreateWithHandler( kCFAllocatorDefault, activities, true, 0) { [weak self] (ob, ac) in

            guard let `self` = self else { return }
            guard self.strategy?.isEmpty == false else { return }
            if ac == .beforeWaiting {
                self.executeTasks(num: self.executeFrequency)
            }
        }
        CFRunLoopAddObserver(runloop, observer, .defaultMode)
    }
}
