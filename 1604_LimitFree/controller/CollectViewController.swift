//
//  CollectViewController.swift
//  1604_LimitFree
//
//  Created by gaokunpeng on 16/9/29.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit

class CollectViewController: LFNavViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        //导航
        createMyNav()
    }
    
    //导航
    func createMyNav() {
        //返回
        addBackButton()
        //标题
        addNavTitle("我的收藏")
        //编辑
        addNavButton("编辑", target: self, action: #selector(editAction(_:)), isLeft: false)
    }
    
    func editAction(btn: UIButton){
        
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
