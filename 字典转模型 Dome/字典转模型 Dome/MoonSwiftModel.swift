//
//  MoonSwiftModel.swift
//  test - model
//
//  Created by moon on 15/3/6.
//  Copyright (c) 2015年 moon. All rights reserved.
//

import Foundation

/**
    1. 模型必须继承NSObject

    2. 自定属性实现MoonModelProtocol,返回属性对应的类

    3. 返回的必须为"\(Rou.self)"

*/

@objc public protocol MoonModelProtocol {
    ///  用户自定义属性,通过这个方法实现
    ///
    ///  :returns: 用户自定义属性字典
    static func customAttributes() -> [String: String]?
}

public class MoonSwiftModel: NSObject {
   
    private static let shared = MoonSwiftModel()
    //程序入口
    public class var sharedManager : MoonSwiftModel{
        return shared
    }
    
    ///  字典转模型
    ///
    ///  :param: dict 数据字典
    ///  :param: cls  模型类
    ///
    ///  :returns: 模型对象
    public func objectWithDict(dict:NSDictionary, _ clsName:AnyClass) ->AnyObject?
    {
        // 1. 获取模型属性信息
        let attributes = getModelAttributes(clsName)
        //如果获取不到模型的属性直接返回nil
        if attributes == nil{
           return nil
        }
        
        // 2. 实例化对象
        let model: AnyObject = clsName.alloc()
        
        // 3. 获取用户自定义属性
        let customAttribute = getCustomAttributes(clsName)
        
        // 4. 给模型赋值
        objSetValueWithDict(model, customAttribute, attributes!,dict)
        
        return model
    }
    
    ///  字典数组转模型数组
    ///
    ///  :param: dict 数据字典数组
    ///  :param: cls  模型类
    ///
    ///  :returns: 模型对象数组
    public func objectsWithDitcs(dicts:NSArray, _ clsName:AnyClass) -> [AnyObject]?
    {
        var tempArray = [AnyObject]()
        // 1. 遍历数组
        for value in dicts {
            var temp: AnyObject?
            
            //取出数组中元素类型
            let valueClass = "\(value.classForCoder)"
            
            // 2. 判断是否是字典
            if valueClass == "NSDictionary"{//字典
                temp = objectWithDict(value as! NSDictionary, clsName)
            } else if valueClass == "NSArray"{//数组
                temp = objectsWithDitcs(value as! NSArray, clsName)
            }
            
            if temp != nil {
                tempArray.append(temp!)
            }
        }
        // 3. 整合数据返回
        if tempArray.count < 1{
             return nil
        } else {
             return tempArray
        }
    }
    
    ///MARK:-----------------私有方法--------------------

    ///  给模型设置属性
    ///
    ///  :param: obj              要设置属性的模型
    ///  :param: customAttribute  自定义属性
    ///  :param: attributes       属性列表
    ///  :param: dict             数据字典
    ///
    private func objSetValueWithDict(obj:AnyObject,_ customAttribute:[String:String]?,_ attributes:[String], _ dict:NSDictionary){
        
        //遍历对象属性数组
        for att in attributes{
        
            // 1. 属性是否能从字典中取到值?
            let value: AnyObject? = dict[att]
            if value == nil {
                continue
            }
            
            // 2. 是否拥有自定义属性?若没有自定义属性,直接KVC
            if customAttribute == nil {
               obj.setValue(value, forKey: att)
                continue
            }
            
            // 3.属性att 是否属于自定义类?
            let type = customAttribute![att]
            if type == nil {//不是自定义属性
                obj.setValue(value, forKey: att)
                continue
            }
            
            // 4. 属于自定义属性,判断value是 数组 还是字典
            let valueClass = "\(value!.classForCoder)"
            // 字典
            if valueClass == "NSDictionary"{
               if let temp: AnyObject? = objectWithDict(value as! NSDictionary, NSClassFromString(type)){
                obj.setValue(temp, forKey: att)
                continue
                }
            }
            // 数组
            if valueClass == "NSArray"{
                if let temp: AnyObject? = objectsWithDitcs(value as! NSArray, NSClassFromString(type)) {
                    obj.setValue(temp, forKey: att)
                }
            }
        }
    }
    
    ///  获取类的完整属性
    ///
    ///  :param: clsName 类名
    ///
    ///  :returns: 属性字典(包括父类)
    private func getModelAttributes(clsName:AnyClass) -> [String]?{
        
        //先去缓存取
        if let temp: AnyObject = modelAttributesCache.objectForKey("\(clsName)"){
            return temp as? [String]
        }
        
        var tempArray = [String]()

        //记下当前类
        var currentClass:AnyClass = clsName
        //如果能取到父类,则说明这个类不是NSObject,需要继续取出属性
        while let tempfather: AnyClass = currentClass.superclass(){
            if let resultArray =  ModelAttribute(currentClass){
                 tempArray += resultArray
            }
            currentClass = tempfather
        }
        //如果有值,写入缓存
        if tempArray.count > 0 {
             modelAttributesCache.setObject(tempArray, forKey: "\(clsName)")
        }
        
      return tempArray
    }
    
    ///  获取类本身属性(不包括父类)
    ///
    ///  :param: clsName 类名
    ///
    ///  :returns: 属性字典(不包括父类)
    private func ModelAttribute(clsName:AnyClass) -> [String]?{
        
        //先去缓存中取
        if let temp:AnyObject = modelAttribute.objectForKey("\(clsName)"){
            return temp as? [String]
        }
        
        //动态获取类本身属性,不包含父类
        var attributeCount:UInt32 = 0
        var attributes = class_copyPropertyList(clsName, &attributeCount)
        var tempArray = [String]()
        
        //整合属性
        for i in 0..<attributeCount{
            //获取属性名称
            let cname = property_getName(attributes[Int(i)])
            //添加到临时数组
            tempArray.append(String.fromCString(cname)!)
        }
        //释放指针
        free(attributes)
        
        //写入缓存
        if tempArray.count > 0 {
            modelAttribute.setObject(tempArray, forKey: "\(clsName)")
        }
        
        return tempArray
    }
    
    ///  获取用户自定义的属性
    ///
    ///  :param: clsName 类名
    ///
    ///  :returns: 属性字典
    private func getCustomAttributes(clsName:AnyClass) -> [String:String]?{
        //去缓存中取
        if let attributes = customAttributesCache.objectForKey("\(clsName)") as? [String:String]{
            return attributes
        }
        //
        if clsName.respondsToSelector("customAttributes"){
            var temp = clsName.customAttributes()
            //如果有值添加到缓存(就怕脑子的某人,实现了方法,不返回值)
            if temp != nil {
            customAttributesCache.setObject(temp!, forKey: "\(clsName)")
            }
            return clsName.customAttributes()
        } else {
            return nil
        }
    }
    
    ///MARK:--------私有属性,用于缓存----------
    
    //用户自定义对象缓存
    var customAttributesCache = NSCache()
    //类属性缓存
    var modelAttributesCache = NSCache()
    //类属性缓存(不包括父类)
    var modelAttribute = NSCache()
}




























