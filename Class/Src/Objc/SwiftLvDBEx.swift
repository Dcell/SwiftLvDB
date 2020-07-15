//
//  SwiftLvDBEx.swift
//  SwiftLvDB
//
//  Created by Dcell on 2018/8/6.
//

import UIKit


// MARK: - just for objc functions
public extension SwiftLvDB {
    /// -setData:forKey: is equivalent to -setObject:forKey: except that the value is converted from a Data
    @objc public func setData(_ value: Data, forKey defaultName: String){
        self.set(value, forKey: defaultName)
    }
    
    
    /// -setInteger:forKey: is equivalent to -setObject:forKey: except that the value is converted from an NSInteger to an NSNumber.
    @objc public func setInt(_ value: Int, forKey defaultName: String){
        self.set(value, forKey: defaultName)
    }
    
    
    /// -setFloat:forKey: is equivalent to -setObject:forKey: except that the value is converted from a float to an NSNumber.
    @objc public func setFloat(_ value: Float, forKey defaultName: String){
        self.set(value, forKey: defaultName)
    }
    
    
    /// -setDouble:forKey: is equivalent to -setObject:forKey: except that the value is converted from a double to an NSNumber.
    @objc public func setDouble(_ value: Double, forKey defaultName: String){
        self.set(value, forKey: defaultName)
    }
    
    
    /// -setBool:forKey: is equivalent to -setObject:forKey: except that the value is converted from a BOOL to an NSNumber.
    @objc public func setBool(_ value: Bool, forKey defaultName: String){
        self.set(value, forKey: defaultName)
    }
    
    /// -setBool:forKey: is equivalent to -setObject:forKey: except that the value is converted from a NSString
    @objc public func setString(_ value: String, forKey defaultName: String){
        self.set(value, forKey: defaultName)
    }
    
    /// -setData:forKey: is equivalent to -setObject:forKey: except that the value is converted from a NSString
    @objc public func setObject(_ value: NSCoding, forKey defaultName: String){
        self.set(value, forKey: defaultName)
    }
    
    /// -setArray:forKey: is equivalent to -setObject:forKey: except that the value is converted from a NSString
    @objc public func setArray(_ value: [NSCoding], forKey defaultName: String){
        self.set(value, forKey: defaultName)
    }
    
    /// -setDictionary:forKey: is equivalent to -setObject:forKey: except that the value is converted from a NSString
    @objc public func setDictionary(_ value: [String:NSCoding], forKey defaultName: String){
        self.set(value, forKey: defaultName)
    }
}
