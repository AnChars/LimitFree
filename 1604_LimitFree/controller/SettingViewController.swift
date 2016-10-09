//
//  SettingViewController.swift
//  1604_LimitFree
//
//  Created by gaokunpeng on 16/9/29.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit

class SettingViewController: LFNavViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //导航
        createMyNav()
        
        //按钮
        createBtns()
    }
    
    
    //导航
    func createMyNav() {
        
        //返回按钮
        addBackButton()
        //标题
        addNavTitle("设置")
    }
    
    //按钮
    func createBtns() {
        
        let imageArray =
    ["account_setting","account_favorite",
     "account_user","account_collect",
     "account_download","account_comment",
     "account_help","account_candou"]
        let titleArray =
            ["我的设置","我的关注",
             "我的账号","我的收藏",
             "我的下载","我的评论",
             "我的帮助","蚕豆应用"]
        
        //循环创建按钮
        let colNum = 3  //一共有几列
        let btnW: CGFloat = 60   //按钮宽度
        let btnH: CGFloat = 60   //按钮高度
        let titleH: CGFloat = 20 //文字的高度
        let offsetX: CGFloat = 50 //第一列按钮左边的间距
        let offsetY: CGFloat = 160 //第一行按钮的y值
        let spaceX: CGFloat = (kScreenWidth-offsetX*2-btnW*CGFloat(colNum))/(CGFloat(colNum)-1)
        let spaceY: CGFloat = 80 //按钮之间的行间距
        for i in 0..<imageArray.count {
            
           //计算行号和列号
            let row = i/colNum
            let col = i%colNum
            
            let btnX = offsetX + (btnW+spaceX)*CGFloat(col)
            let btnY = offsetY + (btnH+titleH+spaceY)*CGFloat(row)
            //1)按钮
            let btn = UIButton.createBtn(CGRectMake(btnX, btnY, btnW, btnH), title: nil, bgImageName: imageArray[i], target: self, action: #selector(clickBtn(_:)))
            btn.tag = 200+i
            view.addSubview(btn)
            
            //2)文字
            let label = UILabel.createLabelFrame(CGRectMake(btnX, btnY+btnH, btnW, titleH), title: titleArray[i], textAlignment: .Center)
            label.font = UIFont.systemFontOfSize(12)
            view.addSubview(label)
        }
    }
    
    func clickBtn(btn: UIButton) {
        let index = btn.tag - 200
//        print(index)
        
        if index == 3 {
            //收藏
            let collectCtrl = CollectViewController()
            navigationController?.pushViewController(collectCtrl, animated: true)
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
