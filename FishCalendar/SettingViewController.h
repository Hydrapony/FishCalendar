//
//  SettingViewController.h
//  根设置页
//
//  Created by Hydra on 17/3/7.
//  Copyright © 2017年 Hydra. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Constant.h"
#import "SettingCalendarViewController.h"
#import "SettingDailyViewController.h"
#import "SettingParametersViewController.h"
#import "SettingFeedbackViewController.h"

@interface SettingViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

extern CGRect viewBounds;
extern NSManagedObjectContext* dbcontext;
extern int kNavigationBarViewHigh;

extern int kTitleTextFontSize;
extern int kSecTitleTextFontSize;
extern int kInfoTextFontSize;
extern CGRect kbtn1rect;

@property(nonatomic,strong) UITableView *tableView; // 列表
@property(nonatomic,strong) UIView *navigationBarView; // 栈导航栏

@end
