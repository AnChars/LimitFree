//
//  DetailViewController.swift
//  1604_LimitFree
//
//  Created by gaokunpeng on 16/9/27.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit
//定位
import CoreLocation

class DetailViewController: LFNavViewController {
    
    //应用的id
    var appId: String?

    @IBOutlet weak var appImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var lastPriceLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    
    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var favoriteBtn: UIButton!
    @IBOutlet weak var downloadBtn: UIButton!
    
    @IBOutlet weak var imageScrollView: UIScrollView!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var nearByScrollView: UIScrollView!
    
    //详情的数据
    private var detailModel: DetailModel?
    
    //定位对象
    private var manager: CLLocationManager?
    
    
    //下载详情是否成功
    private var detailSuccess: Bool?
    
    //下载附近是否成功
    private var nearBySuccess: Bool?
    
    //是否已经下载附近数据
    private var isNearbyDownload: Bool?
    
    //分享
    @IBAction func shareAction() {
    }
    
    //收藏
    @IBAction func favoriteAction() {
        
        //创建收藏的数据对象
        if appImageView.image != nil {
            
            //图片数据下载完成后才能收藏
            let model = CollectModel()
            model.applicationId = detailModel?.applicationId
            model.name = detailModel?.name
            model.headImage = appImageView.image
            
            let dbManager = LFDBManager()
            dbManager.addCollect(model,finishClosure: {
                flag in
                if flag == true {
                    MyUtil.showAlertMsg("收藏成功", onViewController: self)
                    
                    self.refreshAppState()
                    
                    
                }else{
                    MyUtil.showAlertMsg("收藏失败", onViewController: self)
                }
            })
            
        }else {
            
            MyUtil.showAlertMsg("数据正在下载，稍后再收藏", onViewController: self)
        }
        
    }
    
    //下载
    @IBAction func downloadAction() {
        
        //打开appstore
        if detailModel?.itunesUrl != nil {
            let url = NSURL(string: (detailModel?.itunesUrl)!)
            
            if UIApplication.sharedApplication().canOpenURL(url!) {
                UIApplication.sharedApplication().openURL(url!)
            }
            
        }
        
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ProgressHUD.showOnView(view)
 
        //下载详情数据
        downloadDetailData()
        
        //定位
        locate()
        
        //导航
        createMyNav()
        
        //判断是否已收藏
        verifyAppState()
    }
    
    //判断是否已收藏
    func verifyAppState () {
        
        let dbManager = LFDBManager()
        dbManager.isAppFavorite(appId!) { (flag) in
            
            //如果已收藏，不让用户再收藏
            if flag == true {
                self.refreshAppState()
            }
            
        }
        
    }
    
    //如果已收藏，修改收藏按钮的显示
    func refreshAppState() {
        dispatch_async(dispatch_get_main_queue()) {
            self.favoriteBtn.setTitle("已收藏", forState: .Normal)
            self.favoriteBtn.setTitleColor(UIColor.grayColor(), forState: .Normal)
            self.favoriteBtn.enabled = false
        }
        
    }
    
    //定位
    func locate() {
        
        manager = CLLocationManager()
        manager?.distanceFilter = 10
        manager?.desiredAccuracy = kCLLocationAccuracyBest
        
        //请求定位
        if manager?.respondsToSelector(#selector(CLLocationManager.requestWhenInUseAuthorization)) == true {
            manager?.requestWhenInUseAuthorization()
        }
        
        //代理
        manager?.delegate = self
        //开始定位
        manager?.startUpdatingLocation()
        
    }
    
    
    //导航
    func createMyNav() {
        
        addNavTitle("应用详情")
        
        //返回按钮
        addBackButton()
    }
    
    //下载详情数据
    func downloadDetailData() {
        
        let urlString = String(format: kDetailUrl, appId!)
        
        let d = LFDownloader()
        d.delegate = self
        //类型
        d.type = .Detail
        
        d.downloadWithURLString(urlString)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //显示详情数据
    func showDetail() {
        
        //1.图片
        let url = NSURL(string: (detailModel?.iconUrl)!)
        appImageView.kf_setImageWithURL(url!)
        
        
        //2.名字
        nameLabel.text = detailModel?.name
        
        //3.原价
        lastPriceLabel.text = "原价:"+(detailModel?.lastPrice)!
        
        //4.状态
//        print((detailModel?.priceTrend)!)
        if detailModel?.priceTrend == "limited" {
            statusLabel.text = "限免中"
        }else if detailModel?.priceTrend == "sales" {
            statusLabel.text = "降价中"
        }else if detailModel?.priceTrend == "free" {
            statusLabel.text = "免费中"
        }
        
        //5.大小
        sizeLabel.text = (detailModel?.fileSize)!+"MB"
        
        //6.类型
        categoryLabel.text = MyUtil.transferCateName((detailModel?.categoryName)!)
        
        //7.评分
        rateLabel.text = "评分:" + (detailModel?.starCurrent)!
        
        //8.app的截图
        let cnt = detailModel?.photos?.count
        
        
        let imageH: CGFloat = 80   //图片的高度
        let imageW: CGFloat = 80   //图片的宽度
        let marginX: CGFloat = 10  //图片的横向间距
        for i in 0..<cnt!{

            //循环创建图片，显示到滚动视图上面
            let frame = CGRectMake((imageW+marginX)*CGFloat(i), 0, imageW, imageH)
            let tmpImageView = UIImageView(frame: frame)
            //图片
            let pModel = detailModel?.photos![i]
            let url = NSURL(string: (pModel?.smallUrl)!)
            tmpImageView.kf_setImageWithURL(url!)
            
            //添加手势
            let g = UITapGestureRecognizer(target: self, action: #selector(tapImage(_:)))
            tmpImageView.userInteractionEnabled = true
            tmpImageView.addGestureRecognizer(g)
            //设置tag值
            tmpImageView.tag = 100+i
            
            
            imageScrollView.addSubview(tmpImageView)
        }
        
        //设置滚动范围
        imageScrollView.contentSize = CGSizeMake((imageW+marginX)*CGFloat(cnt!), 0)
        
        //9.描述文字
        descLabel.text = detailModel!.desc
        
    }
    
    
    func tapImage(g: UIGestureRecognizer) {
        
        let index = (g.view?.tag)! - 100
        
        //跳转到图片列表界面
        let photoCtrl = PhotoViewController()
        photoCtrl.modalTransitionStyle = .FlipHorizontal
        
        //点击图片的序号
        photoCtrl.photoIndex = index
        //所有图片的数据
        photoCtrl.photoArray = detailModel?.photos
        
        presentViewController(photoCtrl, animated: true, completion: nil)
        
    }
    
    //详情的解析
    func parseDetailData(data: NSData) {
        
//                let str = NSString(data: data, encoding: NSUTF8StringEncoding)
//                print(str!)
        //JSON解析
        let result = try! NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers)
        if result.isKindOfClass(NSDictionary) {
            
            let dict = result as! Dictionary<String,AnyObject>
            
            
            
            detailModel = DetailModel()
            detailModel?.setValuesForKeysWithDictionary(dict)
            //将photo里面的字典转换成对象
            var pArray = Array<PhotoModel>()
            
            for pDict in (dict["photos"] as! NSArray) {
                //字典转模型
                let model = PhotoModel()
                model.setValuesForKeysWithDictionary(pDict as! [String : AnyObject])
                pArray.append(model)
            }
            detailModel?.photos = pArray
            
            //回到主线程修改界面
            dispatch_async(dispatch_get_main_queue(), {
                self.showDetail()
            })
            
            
        }
    }
    
    //显示附近的数据
    func showNearData(array: Array<LimitModel>) {
        
        let btnW: CGFloat = 60  //按钮的宽度
        let btnH: CGFloat = 80  //按钮的高度
        let marginX: CGFloat = 10  //按钮横向的间距
        for i in 0..<array.count {
            
            let model = array[i]
            
            //创建按钮对象
            let btn = NearbyButton(frame: CGRectMake((btnW+marginX)*CGFloat(i), 0, btnW, btnH))
            
            //点击事件
            btn.addTarget(self, action: #selector(clickBtn(_:)), forControlEvents: .TouchUpInside)
            
            //显示数据
            btn.model = model
            nearByScrollView.addSubview(btn)
        }
        //设置滚动范围
        nearByScrollView.contentSize = CGSizeMake((btnW+marginX)*CGFloat(array.count), 0)
        
    }
    
    func clickBtn(btn: NearbyButton) {
        
        //跳转详情
        let detailCtrl = DetailViewController()
        detailCtrl.appId = btn.model?.applicationId
        
        hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(detailCtrl, animated: true)
    }
    
    
    //附近数据的解析
    func parseNearByData(data: NSData) {
        
        let result = try! NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers)
        if result.isKindOfClass(NSDictionary) {
            
            let dict = result as! Dictionary<String, AnyObject>

            let array = dict["applications"] as! Array<Dictionary<String, AnyObject>>
            
            var modelArray = Array<LimitModel>()
            for appDict in array {
                //字典转换成模型对象
                let model = LimitModel()
                model.setValuesForKeysWithDictionary(appDict)
                modelArray.append(model)
            }
            
            //显示数据
            dispatch_async(dispatch_get_main_queue(), {
                self.showNearData(modelArray)
            })
            
            
        }
        
        
        
    }

   
}


//MARK: LFDownloader代理
extension DetailViewController: LFDownloaderDelegate {
    
    func downloader(downloder: LFDownloader, didFailWithError error: NSError) {
        
        if downloder.type == .Detail {
            detailSuccess = false
        }else if downloder.type == .NearBy {
            nearBySuccess = false
        }
        
        //两个都失败，才算失败
        if detailSuccess == false && nearBySuccess == false {
            
            dispatch_async(dispatch_get_main_queue(), {
                ProgressHUD.hideAfterFailOnView(self.view)
            })
            
        }
        
    }
    
    
    
    func downloader(downloader: LFDownloader, didFinishWithData data: NSData) {

        if downloader.type == .Detail {
            //详情数据
            self.parseDetailData(data)
            
            detailSuccess = true
            
        }else if downloader.type == .NearBy {
            
            //附近的数据
            self.parseNearByData(data)
            
            nearBySuccess = true
        }
        
        //如果两个都是失败，就是失败
        if detailSuccess == false && nearBySuccess == false {
            
        }else{
            
            dispatch_async(dispatch_get_main_queue(), {
                //否则就算下载成功
                ProgressHUD.hideAfterSuccessOnView(self.view)
            })

            
        }
        
        
    }
    
}


//MARK: CLLocationManager代理
extension DetailViewController: CLLocationManagerDelegate {
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let loc = locations.last
        
        //如果经纬度有值，就可以获取附近数据
        if loc?.coordinate.latitude != nil && loc?.coordinate.longitude != nil &&  (isNearbyDownload != true) {
            
            //请求附近数据
            let urlString = String(format: kNearByUrl, (loc?.coordinate.longitude)!, (loc?.coordinate.latitude)!)
            let d = LFDownloader()
            d.delegate = self
            //类型
            d.type = .NearBy

            d.downloadWithURLString(urlString)
            
            //结束定位
            manager.stopUpdatingLocation()
            
            isNearbyDownload = true
        }
        
        
    }
    
}





