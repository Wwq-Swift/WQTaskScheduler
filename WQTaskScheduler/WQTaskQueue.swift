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
}

/// 栈
class WQTaskStack: WQTaskBaseQueue, WQTaskSchedulerBaseProtocol {
    func addTask(_ task: @escaping WQTaskBlock, withPriority: WQTaskPriority) {
        pthread_mutex_lock(&lock)
        if maxTaskNum > 0 {
            while deque.count > maxTaskNum {
                deque.popLast()
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
    
    func clearTasks() {
        pthread_mutex_lock(&lock)
        deque.clear()
        pthread_mutex_unlock(&lock)
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
    
    func clearTasks() {
        pthread_mutex_lock(&lock)
        deque.clear()
        pthread_mutex_unlock(&lock)
    }
}

public struct Queue<T>{
    private var array = [T]()
//    private var head = 0
    
    var isEmpty : Bool {
        return count == 0
    }
    
    var last: T? {
        return array.last
    }
    
    var first: T? {
        return array.first
    }
    
    var count: Int {
        return array.count //- head
    }
    /// 添加队头
    mutating func pushFront(_ element: T) {
        array.insert(element, at: 0)
    }
    /// 添加队尾
    mutating func enqueue(_ element: T) {
        array.append(element)
    }
    
    mutating func popFront() {
        array.removeFirst()
    }
    
    mutating func popLast() {
        array.removeLast()
    }
    
    
    
//    mutating func dequeue() -> T? {
//        guard head < array.count, let element = array[head] else { return nil }
//
//        array[head] = nil
//        head += 1
//
//        let percentage = Double(head)/Double(array.count)
//        if array.count > 50 && percentage > 0.25 {
//            array.removeFirst(head)
//            head = 0
//        }
//
//        return element
//    }
    
    mutating func clear() {
        array = []
    }
    
//    var front: T? {
//        if isEmpty {
//            return nil
//        } else {
//            return array[head]
//        }
//    }
}

