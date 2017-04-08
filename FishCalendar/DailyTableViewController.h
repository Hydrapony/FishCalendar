//
//  DailyTableViewController.h
//  日常作业页面
//
//  Created by Hydra on 17/2/9.
//  Copyright © 2017年 Hydra. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Constant.h"
#import "DailyTableViewCell.h"
#import "DailyView.h"

#pragma mark 实现代理

@protocol UpdateSumTaskDelegate
    
-(void)updateSumTask:(int)num; // 更新右上角标
    
@end

@interface DailyTableViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,RingBtnDelegate,DailyViewDelegate>{
    int segmentedControlnum; // 分段按钮值
    double havedoneSum; // 计划时间合计
    double doneSum; // 已完成的时间合记
}

// 全局变量
extern NSString *kSlashTime;
extern CGRect viewBounds;
extern NSManagedObjectContext* dbcontext; // 数据库上下文
extern NSString *kDefaultHwType;
extern NSString *kProgressMM;
extern CGRect kbtn1rect;
extern CGRect kbtn4rect;

@property(nonatomic,strong) NSMutableArray *dailys;// 存储所有今日任务
@property(nonatomic,strong) NSMutableArray *dailysAndOld;// 存储所有未完成任务
@property(nonatomic,strong) NSMutableArray *dailysHd;// 存储未完成今日任务
@property(nonatomic,strong) NSMutableArray *dailysD;// 存储已完成今日任务
@property(nonatomic,strong) NSMutableArray *dailyCells;// 存储cell
@property(nonatomic,strong) NSMutableArray *dailyCellsAndOld;// 存储所有未完成任务
@property(nonatomic,strong) NSMutableArray *dailyCellsHd;// 存储未完成cell
@property(nonatomic,strong) NSMutableArray *dailyCellsD;// 存储已完成cell
@property(nonatomic,strong) UITableView *tableView; // 列表
@property(nonatomic,strong) UIView *navigationBarView; // 栈导航栏
@property(nonatomic,strong) id<UpdateSumTaskDelegate> sumtaskDelegate;

-(void)btnReturnin; // 响应按钮：关闭模态窗口
-(void)btnnew; // 响应按钮：新增任务
-(void)segmentAction:(UISegmentedControl *)Seg; // 响应分段按钮


@end
