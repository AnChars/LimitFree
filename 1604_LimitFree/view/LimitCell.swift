//
//  LimitCell.swift
//  1604_LimitFree
//
//  Created by gaokunpeng on 16/9/26.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit

class LimitCell: UITableViewCell {
    
    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var appImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
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
        
        //4.日期
        let index = model.expireDatetime?.endIndex.advancedBy(-2)
        let expireDateStr = model.expireDatetime?.substringToIndex(index!)
        
        //字符串转对象
        let df = NSDateFormatter()
        //MM: 月
        //mm: 分钟
        //HH: 24小时制
        //hh: 12小时制
        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let expireDate = df.dateFromString(expireDateStr!)
        
        //日历对象
        let cal = NSCalendar.currentCalendar()
        /*
         计算两个日期时间的时间差
         第一个参数:需要的时间差包含的单元(年/月/日/时/分/秒)
         第二个参数:开始时间
         第三个参数:结束时间
         第四个参数:选项
         */
        let unit = NSCalendarUnit(rawValue: NSCalendarUnit.Hour.rawValue | NSCalendarUnit.Minute.rawValue | NSCalendarUnit.Second.rawValue)
        
        let dateComps = cal.components(unit, fromDate: NSDate(), toDate: expireDate!, options: NSCalendarOptions.MatchStrictly)
        
        timeLabel.text = String(format: "剩余:%02ld:%02ld:%02ld", dateComps.hour, dateComps.minute, dateComps.second)
        
        //5.原价
        let priceStr = "￥:"+model.lastPrice!
        lastPriceLabel.text = priceStr
        
        //横线
        if lineView == nil {
            lineView = UIView(frame: CGRectMake(0,10,60,1))
            lineView!.backgroundColor = UIColor.blackColor()
            lastPriceLabel.addSubview(lineView!)
        }
        
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
