//
//  LimitCell.swift
//  1604_LimitFree
//
//  Created by gaokunpeng on 16/9/26.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit

class FreeCell: UITableViewCell {
    
    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var appImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var rateLabel: UILabel!
    
    @IBOutlet weak var lastPriceLabel: UILabel!
    @IBOutlet weak var myStarView: StarView!
    
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var shareLabel: UILabel!
    @IBOutlet weak var favoriteLabel: UILabel!
    
    @IBOutlet weak var downloadLabel: UILabel!
    
    //价格的横线
    private var lineView: UIView?
    
    
    //显示数据
    func config(model: LimitModel, atIndex index: Int) {
        
        //1.背景图片
        if index % 2 == 0 {
            bgImageView.image = UIImage(named: "cate_list_bg1")
        }else{
            bgImageView.image = UIImage(named: "cate_list_bg2")
        }
        
        //2.应用的图片
        let url = NSURL(string: model.iconUrl!)
        
        appImageView.kf_setImageWithURL(url!)
        
        
        //3.名字
        nameLabel.text = "\(index)."+model.name!
        
        //4.评分
        rateLabel.text = "评分:"+model.starCurrent!
        
        //5.原价
        let priceStr = "￥:"+model.lastPrice!
        
        let attrStr = NSMutableAttributedString(string: priceStr)
        attrStr.addAttributes([NSStrikethroughStyleAttributeName: NSNumber(int:1)], range: NSMakeRange(0, attrStr.length))
        
        //attrStr.addAttributes([NSFontAttributeName: UIFont.systemFontOfSize(30)], range: NSMakeRange(0, 2))
        
        lastPriceLabel.attributedText = attrStr

        //6.星级
        myStarView.setRating(model.starCurrent!)
        
        //7.类型        
        categoryLabel.text = MyUtil.transferCateName(model.categoryName!)
        
        //8.分享、收藏、下载
        shareLabel.text = "分享:"+model.shares!+"次"
        favoriteLabel.text = "收藏:"+model.favorites!+"次"
        downloadLabel.text = "下载:"+model.downloads!+"次"
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
