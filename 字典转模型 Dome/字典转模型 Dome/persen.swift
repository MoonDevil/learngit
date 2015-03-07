//
//  persen.swift
//  test - model
//
//  Created by moon on 15/3/7.
//  Copyright (c) 2015年 moon. All rights reserved.
//

import Foundation

class persen: NSObject,MoonModelProtocol{
    var name:String?
    var age:Int = 0
    var dizhi:String?
    var gou:Dog?
    var yiqungou:NSArray?
    static func customAttributes() -> [String : String]? {
        return ["gou":"\(Dog.self)","yiqungou":"\(Dog.self)"]
    }
}
