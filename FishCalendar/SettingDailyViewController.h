//
//  SettingDailyViewController.h
//  日常任务管理
//
//  Created by Hydra on 17/3/21.
//  Copyright © 2017年 Hydra. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Constant.h"

@interface SettingDailyViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    NSManagedObjectContext *zdbcontext;// 私有数据库上下文
    NSMutableArray *_dailylongs; // 存储所有dailylong
    NSMutableArray *_dailylongCells; // 存储所有cells
}

extern CGRect viewBounds;
extern int kNavigationBarViewHigh;
extern CGRect kbtn1rect;
extern CGRect kbtn3rect;
extern CGRect kbtn4rect;

@property(nonatomic,strong) UITableView *tableView; // 列表
@property(nonatomic,strong) UIView *navigationBarView; // 栈导航栏

@end
