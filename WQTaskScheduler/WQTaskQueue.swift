//
//  WQTaskQueue.swift
//  WQTaskScheduler
//
//  Created by kris.wang on 2019/1/10.
//  Copyright © 2019年 kris.wang. All rights reserved.
//  任务队列

import Foundation
//简单的双向队列
class WQTaskBaseQueue {
    var maxTaskNum: Int = 10
    var isEmpty: Bool {
        get {
            return deque.isEmpty
        }
    }
    /// 一个双向队列
    var deque = Queue<WQTaskBlock>()
    /// 互斥锁
    var lock = pthread_mutex_t()
    
    init() {
        var attr = pthread_mutexattr_t()
        pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_RECURSIVE)
        pthread_mutex_init(&lock, &attr)
        pthread_mutexattr_destroy(&attr);
    }
    func clearTasks() {
        pthread_mutex_lock(&lock)
        deque.clear()
        pthread_mutex_unlock(&lock)
    }
}

/// 栈
class WQTaskStack: WQTaskBaseQueue, WQTaskSchedulerBaseProtocol {
    func addTask(_ task: @escaping WQTaskBlock, withPriority: WQTaskPriority) {
        pthread_mutex_lock(&lock)
        if maxTaskNum > 0 {
            while deque.count > maxTaskNum {
                deque.popFront()
            }
        }
        deque.enqueue(task)
        pthread_mutex_unlock(&lock)
    }
    
    func executeTask() {
        pthread_mutex_lock(&lock)
        if deque.isEmpty {
            pthread_mutex_unlock(&lock)
            return
        }
        let taskBlock = deque.last
        deque.popLast()
        pthread_mutex_unlock(&lock)
        taskBlock?()
    }
}

/// 任务队列
class WQTaskQueue: WQTaskBaseQueue, WQTaskSchedulerBaseProtocol {
    func addTask(_ task: @escaping WQTaskBlock, withPriority: WQTaskPriority) {
        pthread_mutex_lock(&lock)
        if maxTaskNum > 0 {
            while deque.count > maxTaskNum {
                deque.popFront()
            }
        }
        deque.enqueue(task)
        pthread_mutex_unlock(&lock)
    }
    
    func executeTask() {
        pthread_mutex_lock(&lock)
        if deque.isEmpty {
            pthread_mutex_unlock(&lock)
            return
        }
        let taskBlock = deque.first
        deque.popFront()
        pthread_mutex_unlock(&lock)
        taskBlock?()
    }
}



