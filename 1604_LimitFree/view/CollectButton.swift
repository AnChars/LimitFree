//
//  CollectButton.swift
//  1604_LimitFree
//
//  Created by gaokunpeng on 16/9/29.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit

class CollectButton: UIControl {
    
    //图片
    private var imageView: UIImageView?
    //标题
    private var titleLabel: UILabel?
    //删除按钮
    private var deleteBtn: UIButton?
    
    //数据
    var model: CollectModel? {
        didSet {
            //显示数据
            //1.图片
            imageView?.image = model?.headImage
            //2.文字
            titleLabel?.text = model?.name
        }
    }

    override init(frame: CGRect) {
        
        var tmpFrame = frame
        tmpFrame.size = CGSizeMake(80, 100)
        super.init(frame: tmpFrame)
        
        //1.图片
        imageView = UIImageView(frame: CGRectMake(20, 20, 60, 60))
        addSubview(imageView!)
        
        //2.文字
        titleLabel = UILabel.createLabelFrame(CGRectMake(20, 80, 60, 20), title: nil, textAlignment: .Center)
        addSubview(titleLabel!)
        
        //3.删除按钮
        deleteBtn = UIButton.createBtn(CGRectMake(0, 0, 40, 40), title: nil, bgImageName: "close", target: self, action: #selector(deleteAction))
        addSubview(deleteBtn!)
    }
    
    func deleteAction(){}
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}


