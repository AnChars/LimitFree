//
//  ReduceViewController.swift
//  1604_LimitFree
//
//  Created by gaokunpeng on 16/9/26.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit

/**
 降价界面
 */

class ReduceViewController: LFBaseViewController {
    
    //分类id
    private var cateId: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //添加分页的功能
        addRefresh()
        
        //导航
        createMyNav()
    }
    
    
    //导航
    func createMyNav() {
        //分类
        addNavButton("分类", target: self, action: #selector(gotoCategory), isLeft: true)
        //标题
        addNavTitle("降价")
        //设置
        addNavButton("设置", target: self, action: #selector(gotoSetPage), isLeft: false)
    }
    
    //分类
    func gotoCategory(){
        
        let cateCtrl = CategoryViewController()
        //设置代理
        cateCtrl.delegate = self
        //类型
        cateCtrl.type = .Reduce
        
        hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(cateCtrl, animated: true)
        hidesBottomBarWhenPushed = false
    }
    
    func gotoSetPage(){
        let setCtrl = SettingViewController()
        
        hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(setCtrl, animated: true)
        hidesBottomBarWhenPushed = false
    }
    
    
    
    //下载
    override func downloadData() {
        
        ProgressHUD.showOnView(view)
        
        var urlString = String(format: kReduceUrl, curPage)
        if cateId != nil {
            urlString = urlString.stringByAppendingString("&category_id=\(cateId!)")
        }
        
        let d = LFDownloader()
        d.delegate = self
        d.downloadWithURLString(urlString)
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

//MARK: LFDownloader代理
extension ReduceViewController: LFDownloaderDelegate {
    
    func downloader(downloder: LFDownloader, didFailWithError error: NSError) {
        ProgressHUD.hideAfterFailOnView(view)
    }
    
    func downloader(downloader: LFDownloader, didFinishWithData data: NSData) {
        
        //如果是下拉刷新，需要清空数据源数组
        if curPage == 1 {
            dataArray.removeAllObjects()
        }
        
        
        //JSON解析
        let result = try! NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers)
        if result.isKindOfClass(NSDictionary) {
            let dict = result as! Dictionary<String, AnyObject>
            let array = dict["applications"] as! Array<Dictionary<String, AnyObject>>
            for appDict in array {
                //字典转模型
                let model = LimitModel()
                model.setValuesForKeysWithDictionary(appDict)
                dataArray.addObject(model)
            }
            
            //回到主线程修改UI
            dispatch_async(dispatch_get_main_queue(), {
                self.tbView?.reloadData()
                
                self.tbView?.headerView?.endRefreshing()
                self.tbView?.footerView?.endRefreshing()
                
                ProgressHUD.hideAfterSuccessOnView(self.view)
            })
        }
        
        
    }
    
}

//MARK: UITableView代理
extension ReduceViewController {
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellId = "reduceCellId"
        
        var cell = tableView.dequeueReusableCellWithIdentifier(cellId) as? ReduceCell
        if nil == cell {
            cell = NSBundle.mainBundle().loadNibNamed("ReduceCell", owner: nil, options: nil).last as? ReduceCell
        }
        
        //显示数据
        let model = dataArray[indexPath.row] as! LimitModel
        cell?.config(model, atIndex: indexPath.row+1)
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //点击跳转详情页面
        let model = dataArray[indexPath.row] as! LimitModel
        
        let detailCtrl = DetailViewController()
        detailCtrl.appId = model.applicationId
        
        hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(detailCtrl, animated: true)
        hidesBottomBarWhenPushed = false
    }
    
}

//MARK: CategoryViewController代理
extension ReduceViewController: CategoryViewControllerDelegate {
    
    func didClickCate(cateId: String, cateName: String) {
        //1.标题
        var titleStr = "降价-"+cateName
        if cateName == "全部" {
            titleStr = "降价"
        }
        addNavTitle(titleStr)
        
        //2.请求数据
        self.cateId = cateId
        curPage = 1
        downloadData()
    }

    
}





