//
//  InternalExtensions.swift
//  Sodium
//
//  Created by Frank Denis on 1/6/15.
//  Copyright (c) 2015 Frank Denis. All rights reserved.
//

import Foundation

public extension NSData {
    func bytesPtr<T>() -> UnsafePointer<T>{
        let rawBytes = (self).bytes
        return rawBytes.assumingMemoryBound(to: T.self);
    }
}

public extension NSMutableData {
    func mutableBytesPtr<T>() -> UnsafeMutablePointer<T>{
        let rawBytes = self.mutableBytes
        return rawBytes.assumingMemoryBound(to: T.self)
    }
}

public extension Data {
    func hexEncodedString() -> String {
        return map { String(format: "%02hhx", $0) }.joined()
    }
}



infix operator ^ : AdditionPrecedence

func ^(left: NSData, right: NSData) -> NSData {
    let result = left.mutableCopy() as! NSMutableData
    let resultPtr : UnsafeMutablePointer<UInt8>  = result.mutableBytesPtr()
    let rightPtr  : UnsafePointer<UInt8>  = right.bytesPtr()
    let leftPtr   : UnsafePointer<UInt8> = left.bytesPtr()
    
    for byte in 0..<left.length {
        resultPtr[byte] = rightPtr[byte] ^ leftPtr[byte]
    }
    
    return result as NSData
}

func ^(left: NSMutableData, right: NSMutableData) -> NSMutableData {
    let result    = left.mutableCopy() as! NSMutableData
    let resultPtr : UnsafeMutablePointer<UInt8>  = result.mutableBytesPtr()
    let rightPtr  : UnsafeMutablePointer<UInt8>  = right.mutableBytesPtr()
    let leftPtr   : UnsafeMutablePointer<UInt8> = left.mutableBytesPtr()
    
    for byte in 0..<left.length {
        resultPtr[byte] = rightPtr[byte] ^ leftPtr[byte]
    }
    
    return result as NSMutableData
}


func ^(left: Data, right: Data) -> Data {
    
    var result = Data(count:left.count)
    
    result.withUnsafeMutableBytes ({(bytes: UnsafeMutablePointer<UInt8>) -> Void in
        for byte in 0..<left.count {
            bytes[byte] = right[byte] ^ left[byte]
        }
    })
    return result
}

