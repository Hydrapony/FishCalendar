//
//  SettingCalendarClassViewController.h
//  课程表设置-课程管理
//
//  Created by Hydra on 17/3/13.
//  Copyright © 2017年 Hydra. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Constant.h"
#import "SettingCalendarClassViewCell.h"
#import "blankView.h"

@interface SettingCalendarClassViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,SettingCalendarClassCellDelegate,UITextFieldDelegate>{
    
    NSManagedObjectContext *zdbcontext;// 私有数据库上下文
    NSMutableArray *_classes;// 存储所有ClassName
    NSArray *_icones;// 存储所有Icon
    NSMutableArray *_cells;
    NSMutableArray *_rowStates; // 组数和行数
    
    blankView *ablankView;
}

extern CGRect viewBounds;
extern int kNavigationBarViewHigh;
extern CGRect kbtn1rect;
extern CGRect kbtn3rect;
extern CGRect kbtn4rect;

@property(nonatomic,strong) UITableView *tableView; // 列表
@property(nonatomic,strong) UIView *navigationBarView; // 栈导航栏

@end
