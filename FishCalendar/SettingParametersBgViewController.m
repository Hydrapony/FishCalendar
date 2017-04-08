//
//  SettingParametersBgViewController.m
//  参数设置-背景设置
//
//  Created by Hydra on 17/3/9.
//  Copyright © 2017年 Hydra. All rights reserved.
//

#import "SettingParametersBgViewController.h"

#import "RootViewController.h"

#define kLightBGColor [UIColor colorWithRed:48/255.0 green:50/255.0 blue:86/255.0 alpha:1] // 浅色背景
#define kDarkBGColor [UIColor colorWithRed:23/255.0 green:23/255.0 blue:23/255.0 alpha:1]// 深色背景
#define kDarkCellColor [UIColor colorWithRed:38/255.0 green:38/255.0 blue:38/255.0 alpha:1]// 深色列背景
#define kLightTextColor [UIColor colorWithRed:221/255.0 green:221/255.0 blue:221/255.0 alpha:1]// 浅色列字体
#define kGreenTextColor [UIColor colorWithRed:12/255.0 green:180/255.0 blue:12/255.0 alpha:1] // 绿色内容字体

@interface SettingParametersBgViewController ()

@end

@implementation SettingParametersBgViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    bgStrs = @[@"黑色木纹",@"黑色花纹",@"自定义"];
    [self getPlistdata]; // 获取plist数据
    [self initNavigationBarView]; // 顶部栏设置
    [self initTableView]; // 列表设置
}

// 获取plist数据
-(void)getPlistdata{
    _settings = ksettingsAll[@"setting"][@"4"];
}

// 顶部栏设置
- (void)initNavigationBarView{
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
    titleL.text = @"背景设置";
    titleL.textColor = [UIColor whiteColor];
    titleL.font = [UIFont systemFontOfSize:17];
    CGSize infoSize=[titleL.text sizeWithAttributes:@{NSFontAttributeName:titleL.font}];
    [titleL setFrame:CGRectMake((viewBounds.size.width - infoSize.width)/2, 34, infoSize.width, infoSize.height)];
    [_navigationBarView addSubview:titleL];
    
    // 右侧返回主页按钮
    UIButton *btnHome = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [btnHome setBackgroundImage:[UIImage imageNamed:@"home.png"] forState:UIControlStateNormal];
    [btnHome setFrame:kbtn4rect];
    [btnHome addTarget:self action:@selector(btnReturnin) forControlEvents:UIControlEventTouchUpInside];
    [_navigationBarView addSubview:btnHome];
    
    [self.view addSubview:_navigationBarView];
}

// 列表设置
- (void)initTableView{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(viewBounds.origin.x, viewBounds.origin.y + kNavigationBarViewHigh, viewBounds.size.width, viewBounds.size.height - kNavigationBarViewHigh) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = kDarkBGColor;
    [_tableView setSeparatorColor:[UIColor darkGrayColor]];
    _tableView.showsVerticalScrollIndicator = NO; // 去掉横向滚动条
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
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
    static NSString *cellIdentifier=@"UITableViewCellStyleS4";
    // 首先根据标识去缓存池取
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    // 如果缓存池没有到则重新创建并放到缓存池中
    if(!cell){
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    
    if([_settings isEqualToString:cell.textLabel.text]){
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text=bgStrs[0];
            break;
        case 1:
            cell.textLabel.text=bgStrs[1];
            break;
        case 2:
            cell.textLabel.text=bgStrs[2];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        default:
            cell.textLabel.text=@"error";
            break;
    }
    
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.font = [UIFont systemFontOfSize:kTitleTextFontSize];
    cell.detailTextLabel.textColor = [UIColor grayColor];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:kSecTitleTextFontSize];
    cell.backgroundColor = kDarkCellColor;
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = [UIColor darkGrayColor];
    
    return cell;
}

// 选中行
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 2) {
        [_parDelegate switchPic]; // checkbg在其选完的回调里都做了
        [self btnBack];
    }else{
        _settings = bgStrs[indexPath.row];

        ksettingsAll[@"setting"][@"4"] = _settings;
        [Constant saveplist:ksettingsAll tofile:@"setting.plist"];
        
        [_parDelegate checkbg:_settings];
        [self btnBack];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    return;
}














#pragma mark 自定义方法

// 响应按钮：关闭模态窗口
-(void)btnReturnin{
    [Constant getSetting];
    RootViewController *rootctrl = self.navigationController.viewControllers[0];
    [rootctrl removeAllCtrls];
    [rootctrl drawCalendar];
    [rootctrl addBtns];
    [rootctrl updateSumTask];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)btnBack{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
