//
//  Dog.swift
//  test - model
//
//  Created by moon on 15/3/7.
//  Copyright (c) 2015年 moon. All rights reserved.
//

import Foundation

class Dog: NSObject,MoonModelProtocol {
    var sudu:Int = 0
    var name:String?
    var age:Int = 0
    var color:String?
    var food:Rou?
    static func customAttributes() -> [String : String]? {
        return ["food":"\(Rou.self)"]
            }
}
