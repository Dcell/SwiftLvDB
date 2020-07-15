//
//  LinkedHashMap.swift
//  SwiftLvDB
//
//  Created by Dcell on 2018/7/11.
//

import UIKit

/// 内存缓存的节点对象
final class LinkedMapNode<T>: NSObject {
    var payload: T //当前节点的内容
    var previous: LinkedMapNode<T>? //上一个节点的地址
    var next: LinkedMapNode<T>? //下一个节点的地址
    var cost:Int64? //占有的成本大小
    
    init(payload: T) {
        self.payload = payload
    }
}

/// just like #{Java LinkedHashMap}
final class LinkedList<T>: NSObject {
    private(set) var count: Int = 0 //当前已经存储的个数
    private var head: LinkedMapNode<T>? //Linked 头节点
    private var tail: LinkedMapNode<T>? //Likend 尾节点
    
    /// 添加头节点
    ///
    /// - Parameter payload: 节点内容
    /// - Returns: 节点对象返回
    func addHead(_ payload: T) -> LinkedMapNode<T> {
        let node = LinkedMapNode(payload: payload)
        defer { //结束的时候，肯定是头节点，并且数量加1
            head = node
            count += 1
        }
        guard let head = head else {
            tail = node
            return node
        }
        head.previous = node
        node.previous = nil
        node.next = head
        return node
    }
    
    
    /// 移动某个节点到头
    ///
    /// - Parameter node: 需要移动的节点
    func moveToHead(_ node: LinkedMapNode<T>) {
        guard node !== head else { return }
        defer {
            self.head = node
        }
        let previous = node.previous
        let next = node.next
        
        previous?.next = next
        next?.previous = previous
        
        node.next = head
        node.previous = nil
        
        if node === tail {
            tail = previous
        }
    }
    
    
    /// 删除最后一个节点
    ///
    /// - Returns: 返回删除的节点
    func removeLast() -> LinkedMapNode<T>? {
        guard let tail = self.tail else { return nil }
        defer {
            count -= 1
        }
        let previous = tail.previous
        previous?.next = nil
        self.tail = previous
        if count == 1 {
            head = nil
        }
        return tail
    }
    
    
    /// 删除某个节点
    ///
    /// - Parameter node: 需要删除的节点
    func remove(_ node: LinkedMapNode<T>){
        defer {
            count -= 1
        }
        if node == head {
            if let next = node.next {
                next.previous = nil
                head = next
            }
        }else if node == tail {
            if let previous = node.previous {
                previous.next = nil
                tail = previous
            }
        }else{
            let previous = node.previous
            let next = node.next
            previous?.next = next
            next?.previous = previous
        }
    }
}
