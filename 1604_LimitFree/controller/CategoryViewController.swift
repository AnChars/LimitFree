//
//  CategoryViewController.swift
//  1604_LimitFree
//
//  Created by gaokunpeng on 16/9/28.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit

/**
 
 cateCtrl.delegate = LimitCtrl
 
 */

protocol CategoryViewControllerDelegate: NSObjectProtocol {
    
    //cateId:分类的categoryId
    //cateName: 分类的categoryName
    func didClickCate(cateId: String,cateName: String)

}

//分类的类型
public enum CategoryType: Int {
    case LimitFree   //限免
    case Reduce      //降价
    case Free        //免费
}


class CategoryViewController: LFBaseViewController {
    
    //类型
    var type: CategoryType?
    
    //代理属性 (weak)
    weak var delegate: CategoryViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //修改表格的高度
        tbView?.frame.size.height = kScreenHeight-64
        
        //导航
        createMyNav()
    }
    
    //导航
    func createMyNav() {
        //返回按钮
        addBackButton()
        
        //标题文字
        var titleStr = ""
        if type == .LimitFree {
            titleStr = "限免-分类"
        }else if type == .Reduce {
            titleStr = "降价-分类"
        }else if type == .Free {
            titleStr = "免费-分类"
        }
        addNavTitle(titleStr)
    }
    
    override func downloadData() {
        //加载条
        ProgressHUD.showOnView(view)
        
        var urlString: String? = nil
        if type == .LimitFree {
            //限免
            urlString = kCategoryLimitUrl
        }else if type == .Reduce {
            //降价
            urlString = kCategoryReduceUrl
        }else if type == .Free {
            //免费
            urlString = kCategoryFreeUrl
        }
        
        if urlString != nil {
            let d = LFDownloader()
            d.delegate = self
            d.downloadWithURLString(urlString!)
        }
        
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
extension CategoryViewController: LFDownloaderDelegate {
    
    func downloader(downloder: LFDownloader, didFailWithError error: NSError) {
        ProgressHUD.hideAfterFailOnView(view)
    }
    
    func downloader(downloader: LFDownloader, didFinishWithData data: NSData) {
        
        //JSON解析
        let result = try! NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers)
        if result.isKindOfClass(NSDictionary) {
            
            let dict = result as! Dictionary<String, AnyObject>
            let array = dict["category"] as! Array<Dictionary<String,AnyObject>>
            for cateDict in array {
                //转换成模型对象
                
                let cateId = cateDict["categoryId"]
                let cateIdStr = "\(cateId!)"
                if cateIdStr == "0" {
                    continue
                }
                
                
                let model = CategoryModel()
                model.setValuesForKeysWithDictionary(cateDict)
                dataArray.addObject(model)
            }
            
            //刷新表格
            dispatch_async(dispatch_get_main_queue(), {
                
                self.tbView?.reloadData()
                
                ProgressHUD.hideAfterSuccessOnView(self.view)
            })
            
        }
        
    }
    
}

//MARK: UITableView代理
extension CategoryViewController {
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellId = "categoryCellId"
        
        var cell = tableView.dequeueReusableCellWithIdentifier(cellId) as? CategoryCell
        if nil == cell {
            cell = NSBundle.mainBundle().loadNibNamed("CategoryCell", owner: nil, options: nil).last as? CategoryCell
        }
        //显示数据
        let model = dataArray[indexPath.row] as! CategoryModel
        
        cell?.configModel(model, type: type!)
        
        return cell!        
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let model = dataArray[indexPath.row] as! CategoryModel
        
        let cateId = "\(model.categoryId!)"
        let cateName = MyUtil.transferCateName(model.categoryName!)
        
        delegate?.didClickCate(cateId, cateName: cateName)
        //退回前面的界面
        navigationController?.popViewControllerAnimated(true)
        
    }
    
    
}



