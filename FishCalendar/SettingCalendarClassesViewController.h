//
//  SettingCalendarClassesViewController.h
//  课程表设置-每日课程编辑
//
//  Created by Hydra on 17/3/19.
//  Copyright © 2017年 Hydra. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Constant.h"

@interface SettingCalendarClassesViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    
    NSDate *_dateNow; // 当前日期时间
    NSDateComponents *_dateNowComps; // 当前周信息
    int weekNow; // 当前选择单双周

    NSMutableDictionary *_calendars; // plist读取内容（calendar）
    NSMutableDictionary *_classTime; // plist读取内容（classTime）
    int _segmentedClassCount[4];
    
    NSMutableDictionary *_classInCaleAll; // plist读取课程信息
    
    UIButton *_btnChangeWeek;
    
    NSMutableArray *_classNameNameArray;
    NSMutableDictionary *tempDic;
    NSMutableArray *tempArray;
    int segmentedControlnum;
}

extern CGRect viewBounds;
extern NSMutableDictionary *ksettingsAll;
extern bool kdoubleWeekSetel;
extern int kwcells;
extern NSManagedObjectContext* dbcontext;
extern int kNavigationBarViewHigh;
extern int kTitleTextFontSize;
extern int kSecTitleTextFontSize;
extern int kInfoTextFontSize;

@property(nonatomic,strong) UITableView *tableView; // 列表
@property(nonatomic,strong) UIView *navigationBarView; // 栈导航栏

@end
