//
//  SettingCalendarViewController.h
//  课程表设置
//
//  Created by Hydra on 17/3/7.
//  Copyright © 2017年 Hydra. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Constant.h"

@interface SettingCalendarViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    UILabel *_label1_1; // 学时制
    UILabel *_label1_2; // 课时制
    UILabel *_label1_3; // 复式课制
    UILabel *_label2_0; // 课程表默认展示方式
    UILabel *_label2_1; // 长按功能
    UILabel *_label2_2; // 目前课程显示方式
    UILabel *_label2_3; // 已完成课程显示方式
    NSMutableDictionary *_settings; // plist读取内容
}

extern CGRect viewBounds;
extern NSMutableDictionary *ksettingsAll;
extern int kNavigationBarViewHigh;
extern CGRect kbtn1rect;
extern CGRect kbtn4rect;

@property(nonatomic,strong) UITableView *tableView; // 列表
@property(nonatomic,strong) UIView *navigationBarView; // 栈导航栏

@end
