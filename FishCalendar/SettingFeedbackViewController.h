//
//  SettingFeedbackViewController.h
//  反馈
//
//  Created by Hydra on 17/3/31.
//  Copyright © 2017年 Hydra. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Constant.h"

@interface SettingFeedbackViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

extern CGRect viewBounds;
extern int kNavigationBarViewHigh;
extern CGRect kbtn1rect;
extern CGRect kbtn4rect;
extern int kTitleTextFontSize;

@property(nonatomic,strong) UITableView *tableView; // 列表
@property(nonatomic,strong) UIView *navigationBarView; // 栈导航栏

@end
