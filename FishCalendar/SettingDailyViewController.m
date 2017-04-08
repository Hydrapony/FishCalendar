//
//  SettingDailyViewController.m
//  日常任务管理
//
//  Created by Hydra on 17/3/21.
//  Copyright © 2017年 Hydra. All rights reserved.
//

#import "SettingDailyViewController.h"
#import "DailyLong+CoreDataProperties.h"
#import "SettingDailyViewCell.h"

#define kLightBGColor [UIColor colorWithRed:48/255.0 green:50/255.0 blue:86/255.0 alpha:1] // 浅色背景
#define kDarkBGColor [UIColor colorWithRed:23/255.0 green:23/255.0 blue:23/255.0 alpha:1]// 深色背景
#define kDarkCellColor [UIColor colorWithRed:38/255.0 green:38/255.0 blue:38/255.0 alpha:1]// 深色列背景
#define kLightTextColor [UIColor colorWithRed:221/255.0 green:221/255.0 blue:221/255.0 alpha:1]// 浅色列字体

@interface SettingDailyViewController ()

@end

@implementation SettingDailyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    zdbcontext = [Constant createDbContext];
    [self initData]; // 查询备选数据
    [self initNavigationBarView]; // 顶部栏设置
    [self initTableView]; // 列表设置
}

// 加载数据
-(void)initData{
    NSFetchRequest *request=[NSFetchRequest fetchRequestWithEntityName:@"DailyLong"];  // 查询所有每日任务
    _dailylongs = [[zdbcontext executeFetchRequest:request error:nil] mutableCopy];
    _dailylongCells = [NSMutableArray new];
    for(int i=0;i<_dailylongs.count;++i){
        // 创建所有列
        SettingDailyViewCell *cell = [SettingDailyViewCell new];
        [cell loadDaily:_dailylongs[i] withInfo:nil];
        [_dailylongCells addObject:cell];
    }
}

// 顶部栏初始化
-(void)initNavigationBarView{
    _navigationBarView=[[UIView alloc]initWithFrame:CGRectMake(viewBounds.origin.x, viewBounds.origin.y, viewBounds.size.width, kNavigationBarViewHigh)];
    _navigationBarView.backgroundColor = kLightBGColor;
    
    // 左侧返回按钮
    UIButton *btnReturn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [btnReturn setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [btnReturn setFrame:kbtn1rect];
    [btnReturn addTarget:self action:@selector(btnBack) forControlEvents:UIControlEventTouchUpInside];
    [_navigationBarView addSubview:btnReturn];
    
    // 中部标签
    UILabel *titleL = [UILabel new];
    titleL.text = @"日常作业";
    titleL.textColor = [UIColor whiteColor];
    titleL.font = [UIFont systemFontOfSize:17];
    CGSize infoSize=[titleL.text sizeWithAttributes:@{NSFontAttributeName:titleL.font}];
    [titleL setFrame:CGRectMake((viewBounds.size.width - infoSize.width)/2, 34, infoSize.width, infoSize.height)];
    [_navigationBarView addSubview:titleL];
    
    // 右侧删除按钮
    UIButton *btnDelClass = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [btnDelClass setBackgroundImage:[UIImage imageNamed:@"Trash.png"] forState:UIControlStateNormal];
    [btnDelClass setFrame:kbtn4rect];
    [btnDelClass addTarget:self action:@selector(btnDelClass) forControlEvents:UIControlEventTouchUpInside];
    [_navigationBarView addSubview:btnDelClass];
    
    [self.view addSubview:_navigationBarView];
}

// 列表初始化
-(void)initTableView{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(viewBounds.origin.x, viewBounds.origin.y + kNavigationBarViewHigh, viewBounds.size.width, viewBounds.size.height - kNavigationBarViewHigh) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = kDarkBGColor;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
}

// 状态栏改为亮色样式
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
















#pragma mark Tableview 数据源方法

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dailylongs.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5;//section头部高度
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;//底部间距
}

// 返回列表行
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return _dailylongCells[indexPath.section];
}












#pragma mark TableView代理方法

// 设置行高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    SettingDailyViewCell *cell= _dailylongCells[indexPath.section];
    return cell.height;
}

// 改写删除按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

// 删除响应
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle==UITableViewCellEditingStyleDelete) {
        if ([DailyLong removeDailyLong:_dailylongs[indexPath.section] withDbcx:zdbcontext]) {
            [_tableView beginUpdates]; // 更新
            [_dailylongs removeObject:_dailylongs[indexPath.section]]; // 删除数据源
            [_dailylongCells removeObjectAtIndex:indexPath.section];
            [_tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationLeft];
            [_tableView endUpdates]; // 结束更新
        }
    }
}








#pragma mark 自定义方法

-(void)btnBack{
    [self.navigationController popViewControllerAnimated:YES];
}

// 设置删除状态
-(void)btnDelClass{
    [_tableView setEditing:!_tableView.editing animated:YES];
}

@end
