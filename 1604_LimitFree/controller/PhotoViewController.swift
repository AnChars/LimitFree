//
//  PhotoViewController.swift
//  1604_LimitFree
//
//  Created by gaokunpeng on 16/9/27.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController {
    
    //点击图片的序号
    var photoIndex: Int?
    
    //所有图片的网址信息
    var photoArray: Array<PhotoModel>?
    
    //标题文字
    private var titleLabel: UILabel?
    
    //滚动视图
    private var scrollView: UIScrollView?
    

    override func viewDidLoad() {
        super.viewDidLoad()

        //导航
        createMyNav()
        
        //显示图片
        createScrollView()
        
    }
    
    //显示图片
    func createScrollView() {
        
        scrollView = UIScrollView(frame: CGRectMake(0,200,kScreenWidth,300))
        //scrollView?.backgroundColor = UIColor.grayColor()
        view.addSubview(scrollView!)
        
        
        //进入下载状态
        ProgressHUD.showOnView(view)
        
        
        //循环添加图片
        let cnt = photoArray?.count
        let w = scrollView!.bounds.size.width
        let h = scrollView!.bounds.size.height
        for i in 0..<cnt! {
            
            let pModel = photoArray![i]
            
            //图片
            let tmpImageView = UIImageView(frame: CGRectMake(kScreenWidth*CGFloat(i), 0, w, h))
            let url = NSURL(string: pModel.originalUrl!)
            
            if i != photoIndex! {
                tmpImageView.kf_setImageWithURL(url!)
            }else{
                //进入时显示的那张图片
                tmpImageView.kf_setImageWithURL(url!, placeholderImage: nil, optionsInfo: nil, progressBlock: { (receivedSize, totalSize)   in
                        //下载进度
                    }, completionHandler: { (image, error, cacheType, imageURL) in
                        
                        //下载完成
                        ProgressHUD.hideOnView(self.view)
                })

            }
            
            
            
            scrollView?.addSubview(tmpImageView)
        }
        //设置滚动范围
        scrollView?.contentSize = CGSizeMake(w*CGFloat(cnt!), 0)
        
        //按页滚动
        scrollView?.pagingEnabled = true
        
        scrollView?.delegate = self
        
        //修改contentOffset值
        scrollView?.contentOffset = CGPointMake(w*CGFloat(photoIndex!), 0)
        
    }
    
    
    //自己加的类似导航的视图
    func createMyNav() {
        
        //背景图片
        let bgImageView = UIImageView(frame: CGRectMake(0, 20, kScreenWidth, 44))
        bgImageView.image = UIImage(named: "navigationbar")
        view.addSubview(bgImageView)
        
        //文字
        let title = "第\(photoIndex!+1)页,共\((photoArray?.count)!)页"
        titleLabel = UILabel.createLabelFrame(CGRectMake(80, 0, 215, 44), title: title, textAlignment: .Center)
        bgImageView.addSubview(titleLabel!)
        
        //按钮
        let btn = UIButton.createBtn(CGRectMake(290, 4, 60, 36), title: "Done", bgImageName: "buttonbar_action", target: self, action: #selector(doneAction))
        bgImageView.addSubview(btn)
        bgImageView.userInteractionEnabled = true
    }
    
    func doneAction() {
        dismissViewControllerAnimated(true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: 设置状态栏的样式
    //这种方式是只修改当前视图控制器的状态栏样式
    override func prefersStatusBarHidden() -> Bool {
        return false
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        //LightContent -> 黑底白字
        //Default->白底黑字
        
        return .LightContent
    }

}

//MARK: UIScrollView代理
extension PhotoViewController: UIScrollViewDelegate {

    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        
        let index = Int(scrollView.contentOffset.x / scrollView.bounds.size.width)
        
        let title = "第\(index+1)页,共\((photoArray?.count)!)页"
        titleLabel?.text = title
    }
    
}




