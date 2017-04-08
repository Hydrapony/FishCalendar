//
//  SettingCalendarModelViewController.h
//  课程表设置-日程模板
//
//  Created by Hydra on 17/3/17.
//  Copyright © 2017年 Hydra. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Constant.h"
#import "SettingCalendarViewController.h"
#import "SettingParametersViewController.h"

@interface SettingCalendarModelViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{

    NSMutableDictionary *_calendars; // plist读取内容（calendar）
    NSMutableDictionary *_classTime; // plist读取内容（classTime）
    NSMutableDictionary *tempDic;
    
    UIButton *_btnAddClass;
    UIButton *_btnDelClass;
    int _segmentedClassCount[4]; // 存储各时段（section）的课程数
    int hperclassLength; // 课时制（长）
    int segmentedControlnum; // 分段按钮值
    int _segmentedMaxClassCount[4]; // 分段各时段最多课程数
}

extern CGRect viewBounds;
extern NSMutableDictionary *ksettingsAll;
extern int kNavigationBarViewHigh;
extern CGRect kbtn1rect;
extern CGRect kbtn3rect;
extern CGRect kbtn4rect;

@property(nonatomic,strong) UITableView *tableView; // 列表
@property(nonatomic,strong) UIView *navigationBarView; // 栈导航栏



@end
