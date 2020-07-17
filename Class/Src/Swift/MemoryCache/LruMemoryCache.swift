//
//  MemoryCache.swift
//  SwiftLvDB
//
//  Created by Dcell on 2018/7/11.
//

import UIKit


/// MemoryCacheProtocol
protocol MemoryCacheProtocol {
    associatedtype Value
    associatedtype Key:Hashable
    
    /// 添加Key Value对
    ///
    /// - Parameters:
    ///   - value: 需要缓存的对象
    ///   - key: 关键字
    /// - Returns: NULL
    func setValue(_ value:Value,_ key:Key)
    
    /// 通过Key获取对象
    ///
    /// - Parameter key: 关键字
    /// - Returns: Value
    func getValue(_ key:Key) ->Value?
    
    
    /// 删除某个对象
    /// - Parameter key:关键字
    func remove(_ key:Key)
}


/// 实现了Lru策略的内存缓存对象
final class LruMemoryCache: NSObject {
    private let countLimit: Int //最大内存个数限制
    private var nodesDict:[Key:LinkedMapNode<(Key,Value)>]
    private let linkedList:LinkedList<(Key,Value)>
    private var mutex:pthread_mutex_t //why not [osspinlock] https://mjtsai.com/blog/2015/12/16/osspinlock-is-unsafe/
    init(maxCount: Int) {
        self.countLimit = max(0, maxCount)
        self.mutex = pthread_mutex_t()
        pthread_mutex_init(&self.mutex,nil)
        self.linkedList = LinkedList()
        self.nodesDict = [:]
    }
}
//mark LruMemoryCache extends MemoryCacheProtocol
extension LruMemoryCache:MemoryCacheProtocol{

    
    
    typealias Value = Any
    typealias Key = String
    
    func setValue(_ value: Any, _ key: String) {
        let notePayload = (key,value)
        pthread_mutex_lock(&self.mutex)
        if let node = self.nodesDict[key] {
            node.payload = notePayload
            self.linkedList.moveToHead(node)
        }else{
            let node = self.linkedList.addHead(notePayload)
            self.nodesDict[key] = node
        }
        if self.linkedList.count > self.countLimit {
            if let node = self.linkedList.removeLast(){
                self.nodesDict[node.payload.0] = nil
            }
        }
        pthread_mutex_unlock(&self.mutex)
    }
    
    func getValue(_ key: String) -> Any? {
        var node:LinkedMapNode<(Key,Value)>?
        pthread_mutex_lock(&self.mutex)
        node = self.nodesDict[key]
        if let node = node{
            self.linkedList.moveToHead(node)
        }
        pthread_mutex_unlock(&self.mutex)
        return node?.payload.1
    }
    
    func remove(_ key: String) {
        pthread_mutex_lock(&self.mutex)
        let node = self.nodesDict[key]
        if let node = node{
            self.linkedList.remove(node)
        }
        pthread_mutex_unlock(&self.mutex)
    }
}

