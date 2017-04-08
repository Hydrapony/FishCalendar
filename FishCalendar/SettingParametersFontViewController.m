//
//  SettingParametersFontViewController.m
//  参数设置-字体设置
//
//  Created by Hydra on 17/3/8.
//  Copyright © 2017年 Hydra. All rights reserved.
//

#import "SettingParametersFontViewController.h"

#import "RootViewController.h"

#define kLightBGColor [UIColor colorWithRed:48/255.0 green:50/255.0 blue:86/255.0 alpha:1] // 浅色背景
#define kDarkBGColor [UIColor colorWithRed:23/255.0 green:23/255.0 blue:23/255.0 alpha:1]// 深色背景
#define kDarkCellColor [UIColor colorWithRed:38/255.0 green:38/255.0 blue:38/255.0 alpha:1]// 深色列背景
#define kLightTextColor [UIColor colorWithRed:221/255.0 green:221/255.0 blue:221/255.0 alpha:1]// 浅色列字体
#define kGreenTextColor [UIColor colorWithRed:12/255.0 green:180/255.0 blue:12/255.0 alpha:1]

@interface SettingParametersFontViewController ()

@end

@implementation SettingParametersFontViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *familyNames = [UIFont familyNames];
    NSMutableArray *fontNames = [NSMutableArray array];
    for (NSString *family in familyNames) {
        [fontNames addObjectsFromArray:[UIFont fontNamesForFamilyName:family]];
    }
    _fonts = [fontNames sortedArrayUsingSelector:@selector(compare:)];//对获取到的字体数字串按顺序排列，fonts 为一个NSArray。
    
    [self getPlistdata]; // 获取plist数据
    [self initNavigationBarView]; // 顶部栏设置
    [self initTableView]; // 列表设置
    
}

// 获取plist数据
-(void)getPlistdata{
    _settings = ksettingsAll[@"setting"][@"1"];
}

// 顶部栏设置
- (void)initNavigationBarView{
    _navigationBarView=[[UIView alloc]initWithFrame:CGRectMake(viewBounds.origin.x, viewBounds.origin.y, viewBounds.size.width, kNavigationBarViewHigh)];
    _navigationBarView.backgroundColor = kLightBGColor;
    
    // 左侧返回按钮
    UIButton *btnReturn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [btnReturn setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [btnReturn setFrame:kbtn1rect];//CGRectMake(15, 28, 30, 30)];
    [btnReturn addTarget:self action:@selector(btnBack) forControlEvents:UIControlEventTouchUpInside];
    [_navigationBarView addSubview:btnReturn];
    
    // 中部标签
    UILabel *titleL = [UILabel new];
    titleL.text = @"参数设置";
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
    return _fonts.count;
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
    static NSString *cellIdentifier=@"UITableViewCellStyleS1";
    // 首先根据标识去缓存池取
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    // 如果缓存池没有到则重新创建并放到缓存池中
    if(!cell){
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.text = _fonts[indexPath.row];
    cell.textLabel.font = [UIFont fontWithName:cell.textLabel.text size:kcellFontsize]; //设置字体

    if([_settings isEqualToString:cell.textLabel.text]){
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.backgroundColor = kDarkCellColor;
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = [UIColor darkGrayColor];
    
    return cell;
}

// 选中行
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _settings = _fonts[indexPath.row];
    ksettingsAll[@"setting"][@"1"] = _settings;
    [Constant saveplist:ksettingsAll tofile:@"setting.plist"];
    [_parDelegate checkin:_fonts[indexPath.row]];
    [self btnBack];
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
