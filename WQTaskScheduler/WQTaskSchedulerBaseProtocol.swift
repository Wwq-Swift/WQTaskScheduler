//
//  WQTaskSchedulerBaseProtocol.swift
//  WQTaskScheduler
//
//  Created by kris.wang on 2019/1/10.
//  Copyright © 2019年 kris.wang. All rights reserved.
//


/// 基础的协议。  本调度器的一些基本方法
import Foundation

typealias WQTaskBlock = () -> Void

/// 任务权限枚举
///
/// - tHigh: 优先级高
/// - tDefault: 优先级正常
/// - tLow: 优先级低
enum WQTaskPriority: Int {
    case tHigh = 750
    case tDefault = 500
    case tLow = 250
}

/// 调度器的调度规则方式
///
/// - taskLIFO: 后进先出（后进任务优先级高）  队列的方式
/// - taskFIFO: //先进先出（先进任务优先级高）栈的方式
/// - taskPriority）: //优先级调度（自定义任务的优先级
enum WQTaskSchedulerMethodType: Int {
    case taskLIFO
    case taskFIFO
    case taskPriority   
}

protocol WQTaskSchedulerBaseProtocol {
    
    /// 添加任务，  以及对应的优先级
    func addTask(_ task: @escaping WQTaskBlock, withPriority: WQTaskPriority)
    /// 执行任务
    func executeTask()
    /// 清空任务
    func clearTasks()
    /// 判断是否任务为空
    var isEmpty: Bool { get }
    /// 最大任务数目
    var maxTaskNum: Int { set get }
}
