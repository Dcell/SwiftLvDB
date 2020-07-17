# [SwiftLvDB](https://github.com/Dcell/SwiftLvDB)
![SwiftLvDB CI](https://github.com/Dcell/SwiftLvDB/workflows/SwiftLvDB%20CI/badge.svg)
## **A fast key-value storage library , Leveldb for swift.**
* [x] support basic types [int,float,double,bool,string...]
* [x] support Object [Object:NSCode]
* [x] support List
* [x] support HashMap
* [x] support memory cache(LRU)
* [x] support Codeable (V2.0.0)

## Installation with CocoaPods

```
pod 'SwiftLvDB'
```
## Usage
###Create SwiftLvDB Object
```
let sldb = SwiftLvDB.sharedInstance
or
let sldb = SwiftLvDB(subName: "sldb")
```
> If you use the same `init:subName` db in multiple threads, make sure that the `SwiftLvDB` instance is unique; invoke `close()` before `init:subName`

###Set value for key

```
let testValue:String = "hello"
let testKey = "testSaveString"
SwiftLvDB.sharedInstance.set(testValue, forKey: testKey)
```
###Get value for key

```
let testKey = "testSaveString"
let value = SwiftLvDB.sharedInstance.string(forKey: testKey)
```

###Save struct, ArrayList or HashMap,Suggest use `Codeable` protocol

```
struct TestStruct:Codable,Equatable{
    var a:Int
    var b:String
    
    static func == (lhs: Self, rhs: Self) -> Bool{
        return lhs.a == rhs.a && lhs.b == rhs.b
    }
}
let testKey = "testSaveCodeable"
let testvalue = TestStruct(a: 1, b: "hello")
try sldb.set(testvalue, forKey: testKey)
sldb.codeableObject(TestStruct.self, forKey: testKey)
```

```
let testValue:[Int] = [1,2,3,4,5]
let testKey = "testSaveList"
try sldb.set(testValue, forKey: testKey)
sldb.codeableObject([Int].self, forKey: testKey)
```

```
var testValue:[String:Int] = [:]
testValue["1"] = 1
testValue["2"] = 2
    
let testKey = "testSaveList"
try sldb.set(testValue, forKey: testKey)
sldb.codeableObject([String:Int].self, forKey: testKey)
```
-------

## MIT