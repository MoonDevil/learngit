//
//  main.swift
//  大声大声道
//
//  Created by moon on 15/3/7.
//  Copyright (c) 2015年 moon. All rights reserved.
//

import Foundation


var dict = ["name":"jack",
            "age":"21",
            "dizhi":"beijing",
            "gou":[     "sudu":"15",
                        "name":"豆豆1",
                        "age":"3",
                        "color":"绿色",
                        "food":[    "name":"牛肉",
                                     "zhongliang":"1"]],
    "yiqungou":[["sudu":"15",
        "name":"豆豆2",
        "age":"3",
        "color":"绿色",
        "food":[        "name":"牛肉",
            "zhongliang":"1"]],["sudu":"15",
                "name":"豆豆3",
                "age":"3",
                "color":"绿色",
                "food":[        "name":"牛肉",
                    "zhongliang":"1"]]]]

var xiaogou = ["sudu":"15",
                "name":"豆豆",
                "age":"3",
                "color":"绿色",
                "food":[        "name":"牛肉",
                                "zhongliang":"1"]]
var shiwu = ["name":"猪肉",
             "zhongliang":"2"]




func test1(){
    var tool = MoonSwiftModel.sharedManager
    var pensen1 = tool.objectWithDict(dict, persen.self) as? persen
    var gou1 = tool.objectWithDict(xiaogou, Dog.self) as? Dog
    var rou1 = tool.objectWithDict(shiwu, Rou.self) as? Rou
}


var time = NSDate().timeIntervalSince1970
for i in 0..<10000 {
test1()
}
var time2 = NSDate().timeIntervalSince1970
println(time2 - time)










