//
//  CategoryCell.swift
//  1604_LimitFree
//
//  Created by gaokunpeng on 16/9/28.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit

class CategoryCell: UITableViewCell {
    
    @IBOutlet weak var categoryImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var descLabel: UILabel!
    
    
    func configModel(model: CategoryModel,type: CategoryType) {
        
        //1.图片 (本地的图片)
        categoryImageView.image = UIImage(named: "category_"+(model.categoryName)!+".jpg")
        
        //2.标题
        nameLabel.text = MyUtil.transferCateName(model.categoryName!)
        
        //3.描述文字
        var typeStr = ""
        if type == .LimitFree {
            typeStr = "限免"
        }else if type == .Reduce {
            typeStr = "降价"
        }else if type == .Free {
            typeStr = "免费"
        }
        
        descLabel.text = "共有\(model.lessenPrice!)款应用,其中\(typeStr)\(model.count!)款"
        descLabel.font = UIFont.systemFontOfSize(14)
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
