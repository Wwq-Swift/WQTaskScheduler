//
//  Queue.swift
//  WQTaskScheduler
//
//  Created by kris.wang on 2019/1/29.
//  Copyright © 2019年 kris.wang. All rights reserved.
//

import Foundation
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
