//
//  UILabel+Util.swift
//  1604_LimitFree
//
//  Created by gaokunpeng on 16/9/26.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit


/**
 UILabel的类扩展
 */

extension UILabel {
    
    //创建UILabel的一个方法
    class func createLabelFrame(frame: CGRect, title: String?, textAlignment: NSTextAlignment?) -> UILabel {
        
        let label = UILabel(frame: frame)        
        label.text = title
        
        if let tmpAlignment = textAlignment {
            label.textAlignment = tmpAlignment
        }
        
        return label
    }
    
}






