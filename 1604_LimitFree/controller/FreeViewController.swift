//
//  FreeViewController.swift
//  1604_LimitFree
//
//  Created by gaokunpeng on 16/9/26.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit

/**
 免费界面
 */

class FreeViewController: LFBaseViewController {
    
    //分类ID
    private var cateId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //导航
        createMyNav()
        //分页
        addRefresh()
    }
    
    //导航
    func createMyNav() {
        //分类
        addNavButton("分类", target: self, action: #selector(gotoCategory), isLeft: true)
        //标题
        addNavTitle("免费")
        //设置
        addNavButton("设置", target: self, action: #selector(gotoSetPage), isLeft: false)
    }
    
    //分类
    func gotoCategory(){
        
        let cateCtrl = CategoryViewController()
        cateCtrl.delegate = self
        cateCtrl.type = .Free
        
        hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(cateCtrl, animated: true)
        hidesBottomBarWhenPushed = false
    }
    
    //设置
    func gotoSetPage(){
        
        let setCtrl = SettingViewController()
        
        hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(setCtrl, animated: true)
        hidesBottomBarWhenPushed = false
    }
    
    
    //下载
    override func downloadData() {
        
        ProgressHUD.showOnView(view)
        
        var urlString = String(format: kFreeUrl, curPage)
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
    

   

}


//MARK: LFDownloade代理
extension FreeViewController: LFDownloaderDelegate {
    
    func downloader(downloder: LFDownloader, didFailWithError error: NSError) {
        ProgressHUD.hideAfterFailOnView(view)
    }
    
    func downloader(downloader: LFDownloader, didFinishWithData data: NSData) {
        
        //如果是第一页，清空数组
        if curPage == 1 {
            dataArray.removeAllObjects()
        }
        
        let result = try! NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers)
        if result.isKindOfClass(NSDictionary) {
            let dict = result as! Dictionary<String, AnyObject>
            let array = dict["applications"] as! Array<Dictionary<String, AnyObject>>
            for appDict in array {
                let model = LimitModel()
                model.setValuesForKeysWithDictionary(appDict)
                dataArray.addObject(model)
            }
            
            //回到主线程刷新
            dispatch_async(dispatch_get_main_queue(), {
                self.tbView?.reloadData()
                
                //结束刷新
                self.tbView?.headerView?.endRefreshing()
                self.tbView?.footerView?.endRefreshing()
                ProgressHUD.hideAfterSuccessOnView(self.view)
            })
        }
        
    }
    
}

//MARK: CategoryViewController代理
extension FreeViewController: CategoryViewControllerDelegate {
    
    func didClickCate(cateId: String, cateName: String) {
        
        //1.标题
        var titleStr = "免费-"+cateName
        if cateName == "全部" {
            titleStr = "免费"
        }
        addNavTitle(titleStr)
        
        //2.下载
        self.cateId = cateId
        
        curPage = 1
        downloadData()
    }
    
}

//MARK: UITableView代理
extension FreeViewController {
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellId = "freeCellId"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellId) as? FreeCell
        if nil == cell {
            cell = NSBundle.mainBundle().loadNibNamed("FreeCell", owner: nil, options: nil).last as? FreeCell
        }
        
        //显示数据
        let model = dataArray[indexPath.row] as! LimitModel
        cell?.config(model, atIndex: indexPath.row+1)
        return cell!
    }
    
    //点击进入详情
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let model = dataArray[indexPath.row] as! LimitModel
        
        let detailCtrl = DetailViewController()
        detailCtrl.appId = model.applicationId
        
        hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(detailCtrl, animated: true)
        hidesBottomBarWhenPushed = false
    }
    
}




