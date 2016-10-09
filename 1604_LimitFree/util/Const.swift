//
//  Const.swift
//  1604_LimitFree
//
//  Created by gaokunpeng on 16/9/26.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit

//这个文件用来存放一些常量
//包含网络请求地址等


//屏幕大小
public let kScreenWidth = UIScreen.mainScreen().bounds.size.width
public let kScreenHeight = UIScreen.mainScreen().bounds.size.height



//接口
//限免
public let kLimitUrl = "http://iappfree.candou.com:8080/free/applications/limited?currency=rmb&page=%ld"

//2.降价
public let kReduceUrl = "http://iappfree.candou.com:8080/free/applications/sales?currency=rmb&page=%ld"


//3.免费
public let kFreeUrl = "http://iappfree.candou.com:8080/free/applications/free?currency=rmb&page=%ld"

//4.专题
//#define kSubjectUrl (@"http://iappfree.candou.com:8080/free/special?page=%ld&limit=5")
public let kSubjectUrl = "http://1000phone.net:8088/app/iAppFree/api/topic.php?page=%ld&number=20"

//5.热榜
//#define kRankUrl (@"http://open.candou.com/mobile/hot/page/%ld")
public let kRankUrl = "http://1000phone.net:8088/app/iAppFree/api/hot.php?page=%ld&number=20"



//搜索
public let kLimitSearchUrl = "http://1000phone.net:8088/app/iAppFree/api/limited.php?page=%ld&number=20&search=%@"

public let KReduceSearchUrl = "http://1000phone.net:8088/app/iAppFree/api/reduce.php?page=%ld&number=20&search=%@"

public let kFreeSearchUrl = "http://1000phone.net:8088/app/iAppFree/api/free.php?page=%ld&number=20&search=%@"

public let kRankSearchUrl = "http://1000phone.net:8088/app/iAppFree/api/hot.php?page=%ld&number=20&search=%@"



//详情
//参数是appID
public let kDetailUrl = "http://iappfree.candou.com:8080/free/applications/%@?currency=rmb"

//周边
public let kNearByUrl = "http://iappfree.candou.com:8080/free/applications/recommend?longitude=%lf&latitude=%lf"


//分类
public let kCategoryLimitUrl = "http://iappfree.candou.com:8080/free/categories/limited"
public let kCategoryReduceUrl = "http://iappfree.candou.com:8080/free/categories/sales"
public let kCategoryFreeUrl = "http://iappfree.candou.com:8080/free/categories/free"
public let kCategoryRankUrl = "http://iappfree.candou.com:8080/free/categories/sales"




