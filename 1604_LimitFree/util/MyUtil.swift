//
//  MyUtil.swift
//  1604_LimitFree
//
//  Created by gaokunpeng on 16/9/26.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit

class MyUtil: NSObject {
    
    //将类型的英文转换成中文
    class func transferCateName(name: String) -> String {
        
        var result = ""
        if name == "Business" {
            result = "商业"
        }else if name == "Weather" {
            result = "天气"
        }else if name == "Tool" {
            result = "工具"
        }else if name == "Travel" {
            result = "旅行"
        }else if name == "Sports" {
            result = "体育"
        }else if name == "Social" {
            result = "社交"
        }else if name == "Refer" {
            result = "参考"
        }else if name == "Ability" {
            result = "效率"
        }else if name == "Photography" {
            result = "摄影"
        }else if name == "News" {
            result = "新闻"
        }else if name == "Gps" {
            result = "导航"
        }else if name == "Music" {
            result = "音乐"
        }else if name == "Life" {
            result = "生活"
        }else if name == "Health" {
            result = "健康"
        }else if name == "Finance" {
            result = "财务"
        }else if name == "Pastime" {
            result = "娱乐"
        }else if name == "Education" {
            result = "教育"
        }else if name == "Book" {
            result = "书籍"
        }else if name == "Medical" {
            result = "医疗"
        }else if name == "Catalogs" {
            result = "商品指南"
        }else if name == "FoodDrink" {
            result = "美食"
        }else if name == "Game" {
            result = "游戏"
        }else if name == "All" {
            result = "全部"
        }
        
        return result
    }
    
    
    //弹出Alert的方法
    class func showAlertMsg(msg: String, onViewController vc: UIViewController) {
    
        let alertCtrl = UIAlertController(title: "温馨提示", message: msg, preferredStyle: .Alert)
        
        let action = UIAlertAction(title: "确定", style: .Default, handler: nil)
        alertCtrl.addAction(action)
        
        dispatch_async(dispatch_get_main_queue()) {
            vc.presentViewController(alertCtrl, animated: true, completion: nil)
        }
        
    }
    
    
    
}
