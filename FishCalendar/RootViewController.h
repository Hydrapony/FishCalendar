//
//  RootViewController.h
//  根视图（课程表和按钮）
//
//  Created by Hydra on 17/2/9.
//  Copyright © 2017年 Hydra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/ALAsset.h>
#import <AssetsLibrary/ALAssetRepresentation.h>

#import "Constant.h"

#import "JSBadgeView.h"

#import "Daily+CoreDataProperties.h"
#import "HomeworkType+CoreDataProperties.h"
#import "ClassName+CoreDataProperties.h"
#import "Iconimg+CoreDataProperties.h"

#import "DailyTableViewController.h"
#import "SettingViewController.h"

#import "MainCalendarView.h"
#import "DailyCView.h"
#import "SingleCalendarView.h"

@interface RootViewController : UIViewController<CalendarDataSource,DailyCViewDelegate,UpdateSumTaskDelegate>{
    bool showtype;
    
    UIImageView *bgImgView;
    MainCalendarView *calendar;
    SingleCalendarView *scalendar;
    UIButton *exchangeBtn;
    UIButton *dailyBtn;
    UIButton *settingBtn;
    JSBadgeView *badgeView;
    int sumTask;
}

extern NSManagedObjectContext *dbcontext; // 数据库上下文
extern NSString *kclassFontName;
extern NSString *kclassBgName;
extern NSString *kSlashTime;
extern int kCalendarxMargin;
extern int kdefaultCanendarShow;

@property(nonatomic,strong) NSDate *_nowDate; // 当前时间

- (void)removeAllCtrls;// 移除课程表
- (void)drawCalendar; // 绘制课程表
- (void)addBtns; // 绘制下部按钮
- (void)updateSumTaskto1;// 角标设置为1
- (void)updateSumTask;// 角标更新

@end
