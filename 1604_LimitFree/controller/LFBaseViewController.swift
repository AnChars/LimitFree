//
//  LFBaseViewController.swift
//  1604_LimitFree
//
//  Created by gaokunpeng on 16/9/28.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit

class LFBaseViewController: LFNavViewController {
    
    //表格
    var tbView: UITableView?
    
    //数据源数组
    lazy var dataArray = NSMutableArray()
    
    //当前页数
    var curPage: Int = 1

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //表格
        createTableView()
        
        //下载
        downloadData()

    }
    
    //创建表格
    func createTableView() {
        
        automaticallyAdjustsScrollViewInsets = false
        
        tbView = UITableView(frame: CGRectMake(0, 64, kScreenWidth, kScreenHeight-64-49), style: .Plain)
        tbView?.delegate = self
        tbView?.dataSource = self
        view.addSubview(tbView!)
        
        
    }
    
    //分页的功能
    func addRefresh() {
        //下拉刷新
        tbView?.headerView = XWRefreshNormalHeader(target: self, action: #selector(loadFirstPage))
        
        //上拉加载更多
        tbView?.footerView = XWRefreshAutoNormalFooter(target: self, action: #selector(loadNextPage))
    }
    
    
    //下载数据
    //子类重写(override)这个方法
    func downloadData(){
        print("子类必须重新实现这个方法,\(#function)")
    }
    
    //下拉刷新
    func loadFirstPage(){
        
        curPage = 1
        
        downloadData()
        
    }
    
    //上拉加载更多
    func loadNextPage(){
        
        curPage += 1
        downloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

//MARK: UITableView代理
extension LFBaseViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("子类必须实现这个方法,\(#function)")
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        print("子类必须实现这个方法,\(#function)")
        return UITableViewCell()
    }
    
}



