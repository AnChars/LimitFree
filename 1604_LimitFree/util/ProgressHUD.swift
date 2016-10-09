//
//  ProgressHUD.swift
//  LimitFree1606
//
//  Created by gaokunpeng on 16/7/28.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit


public let kProgressImageName = "提示底.png"
public let kProgressHUDTag = 10000
public let kProgressActivityTag = 20000

class ProgressHUD: UIView {

    var textLabel: UILabel?
    
    init(center: CGPoint){
        
        super.init(frame: CGRectZero)
        
        let bgImage = UIImage(named: kProgressImageName)

        self.bounds = UIScreen.mainScreen().bounds
//        self.alpha=0
            //CGRectMake(0, 0, bgImage!.size.width, bgImage!.size.height)
        self.center = center
        let g = UIGestureRecognizer(target: self, action: #selector(dismissView))
        self.addGestureRecognizer(g)
        
        
        let imageView = UIImageView(image: bgImage)
        imageView.frame = CGRectMake(kScreenWidth/2-bgImage!.size.width/2, kScreenHeight/2-bgImage!.size.height/2, bgImage!.size.width, bgImage!.size.height)
        self.addSubview(imageView)
        
        //self.backgroundColor = UIColor.grayColor()
        self.layer.cornerRadius = 6
    }
    
    func dismissView(){
        print("12456")
        self.removeFromSuperview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    private func show(){
        
        let uaiView = UIActivityIndicatorView(activityIndicatorStyle: .White)
        uaiView.tag = kProgressActivityTag
        uaiView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2)
        uaiView.backgroundColor = UIColor.clearColor()
        uaiView.startAnimating()
        self.addSubview(uaiView)
        
        
        self.textLabel = UILabel(frame: CGRectZero)
        self.textLabel!.backgroundColor = UIColor.clearColor()
        self.textLabel!.textColor = UIColor.whiteColor()
        self.textLabel!.text = "加载中..."
        self.textLabel!.font = UIFont.systemFontOfSize(15)
        self.textLabel?.sizeToFit()
        
        self.textLabel!.center = CGPointMake(uaiView.center.x, uaiView.frame.origin.y+uaiView.frame.size.height+5+self.textLabel!.bounds.size.height/2)
        self.addSubview(self.textLabel!)
    
    }
    
    private func hideActivityView(){
        
        let tmpView = self.viewWithTag(kProgressActivityTag)
            
        if tmpView != nil {
            let uiaView = tmpView  as! UIActivityIndicatorView
            
            uiaView.stopAnimating()
            uiaView.removeFromSuperview()
        }
        
        
        
        UIView.animateWithDuration(0.5, animations: {
            self.alpha = 0
        }) { (finished) in
            self.superview?.userInteractionEnabled = true
            self.removeFromSuperview()
        }
        
    }
    
    
    private func hideAfterSuccess(){
        
        let successImage = UIImage(named: "保存成功.png")
        
        let successImageView = UIImageView(image: successImage)
        successImageView.sizeToFit()
        successImageView.center = CGPointMake(self.frame.size.width/2,
        self.frame.size.height/2)
        self.addSubview(successImageView)
        self.textLabel!.text = "加载成功"
        self.textLabel!.sizeToFit()
        
        self.hideActivityView()

    }
    
 
    private func hideAfterFail(){
        self.textLabel?.text = "加载失败"
        self.textLabel?.sizeToFit()
        
        self.hideActivityView()
    }
    

    class func showOnView(view: UIView){
        
        let oldHud = view.viewWithTag(kProgressHUDTag)
    
        if (oldHud != nil) {
            oldHud?.removeFromSuperview()
        }
        
        let hud = ProgressHUD(center: view.center)
        hud.tag = kProgressHUDTag
        
        hud.show()
        view.userInteractionEnabled = false
        view.addSubview(hud)
        
    }
    
    
   
    class func hideAfterSuccessOnView(view: UIView){
        
        let tmpView = view.viewWithTag(kProgressHUDTag)
            
        if tmpView != nil {
            let hud = tmpView as! ProgressHUD
            
            hud.hideAfterSuccess()
        }
        
        
        
    }
    

    class func hideAfterFailOnView(view: UIView){
        
        let tmpView = view.viewWithTag(kProgressHUDTag)
        
        if tmpView != nil {
            let hud = tmpView as! ProgressHUD
            
            hud.hideAfterFail()
        }
        
        
        
    }
    
   
    class func hideOnView(view: UIView){
        let tmpView = view.viewWithTag(kProgressHUDTag)
        
        if tmpView != nil {
            let hud = tmpView as! ProgressHUD
            
            hud.hideActivityView()
        }
        
    }
}
