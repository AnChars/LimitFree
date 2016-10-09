//
//  NearbyButton.swift
//  1604_LimitFree
//
//  Created by gaokunpeng on 16/9/27.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit

class NearbyButton: UIControl {

    //图片
    private var imageView: UIImageView?
    //文字
    private var textLabel: UILabel?
    
    //数据
    //可以通过getter方法获取数据值
    var model: LimitModel? {
        didSet {
            //显示数据
            //1.图片
            let url = NSURL(string: (model?.iconUrl)!)
            imageView?.kf_setImageWithURL(url!)
            
            //2.文字
            textLabel?.text = model?.name
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //文字的高度
        let titleH: CGFloat = 20
        let w = bounds.size.width
        let h = bounds.size.height
        
        //初始化子视图
        //1.图片
        imageView = UIImageView(frame: CGRectMake(0, 0, w, h-titleH))
        addSubview(imageView!)
        
        //2.文字
        textLabel = UILabel.createLabelFrame(CGRectMake(0, h-titleH, w, titleH), title: nil, textAlignment: .Center)
        textLabel?.font = UIFont.systemFontOfSize(12)
        addSubview(textLabel!)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    

}
