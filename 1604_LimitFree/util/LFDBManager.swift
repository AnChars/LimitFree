//
//  LFDBManager.swift
//  1604_LimitFree
//
//  Created by gaokunpeng on 16/9/29.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit

/**
 1、导入FMDatabase第三方库
 2、不支持ARC，设置-fno-objc-arc
 3、导入系统依赖库  libsqlite3.tbd
 4、桥接头文件
 */

class LFDBManager: NSObject {
    
    //数据库操作队列
    private var myQueue: FMDatabaseQueue?
    
    //获取单例对象的方法
    class var sharedManager: LFDBManager? {
        
        struct Static {
            static var onceToken: dispatch_once_t = 0
            static var instance: LFDBManager? = nil
        }
        
        dispatch_once(&Static.onceToken) { 
            Static.instance = LFDBManager()
        }
        
        return Static.instance!
    }
    
    
    override init() {
        
        //初始化数据库
        
        //1.文件路径
        let cacheDir = NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true).last
        
        let path = cacheDir?.stringByAppendingString("/collect.db")
//        print(path!)
        
        //2.创建队列
        myQueue = FMDatabaseQueue(path: path)
        
        //3.创建表格
        myQueue?.inDatabase({
            (database) in
            
            let createSql = "create table if not exists collect (collectId integer primary key autoincrement,applicationId varchar(255), name varchar(255), headImage blob)"
            let flag = database.executeUpdate(createSql, withArgumentsInArray: nil)
            if flag != true {
                print(database.lastErrorMessage())
            }
            
        })
    }
    
    
    
    //收藏
    func addCollect(model: CollectModel, finishClosure: (Bool -> Void)) {
        
        myQueue?.inDatabase({
            (database) in
            
            let insertSql = "insert into collect (applicationId, name, headImage) values (?,?,?)"
            
            let data = UIImagePNGRepresentation(model.headImage!)
            
            let flag = database.executeUpdate(insertSql, withArgumentsInArray: [model.applicationId!, model.name!, data!])
            if flag != true {
                print(database.lastErrorMessage())
            }
            
            finishClosure(flag)
            
        })
        
    }
    
    //判断某个应用是否已收藏
    func isAppFavorite(appId: String, resultClosure: (Bool -> Void)) {
        
        myQueue?.inDatabase({
            (database) in
            
            //别名 as cnt
            let sql = "select count(*) as cnt from collect where applicationId = ?"
            let rs = database.executeQuery(sql, withArgumentsInArray: [appId])
            var cnt: Int32 = 0
            if rs.next() {
                cnt = rs.intForColumn("cnt")
            }
            
            if cnt > 0 {
                resultClosure(true)
            }else{
                resultClosure(false)
            }
            
            rs.close()
        })
        
    }

    
    /*
    func isAppFavorite(appId: String, resultClosure: (Bool -> Void)) {
        
        myQueue?.inDatabase({
            (database) in
            
            let sql = "select * from collect where applicationId = ?"
            let rs = database.executeQuery(sql, withArgumentsInArray: [appId])
            if rs.next() {
                //已经收藏了
                resultClosure(true)
                
            }else{
                //还没有收藏
                resultClosure(false)
            }
            
            rs.close()
        })
        
    }*/
    
    
    //查询数据的方法
    func searchAllCollectData(resultClosure: (Array<CollectModel> -> Void)) {
        
        myQueue?.inDatabase({
            (database) in
            let sql = "select * from collect"
            
            let rs = database.executeQuery(sql, withArgumentsInArray: nil)
            //数组
            var tmpArray = Array<CollectModel>()
            while rs.next() {
                let model = CollectModel()
                model.collectId = Int(rs.intForColumn("collectId"))
                model.applicationId = rs.stringForColumn("applicationId")
                model.name = rs.stringForColumn("name")
                let data = rs.dataForColumn("headImage")
                model.headImage = UIImage(data: data)
                tmpArray.append(model)
            }
            
            resultClosure(tmpArray)
            
            rs.close()
        })
        
    }
    
    
}



