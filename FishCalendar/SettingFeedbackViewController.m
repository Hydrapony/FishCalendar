//
//  SettingFeedbackViewController.m
//  反馈
//
//  Created by Hydra on 17/3/31.
//  Copyright © 2017年 Hydra. All rights reserved.
//

#import "SettingFeedbackViewController.h"

#define kLightBGColor [UIColor colorWithRed:48/255.0 green:50/255.0 blue:86/255.0 alpha:1] // 浅色背景
#define kDarkBGColor [UIColor colorWithRed:23/255.0 green:23/255.0 blue:23/255.0 alpha:1]// 深色背景
#define kDarkCellColor [UIColor colorWithRed:38/255.0 green:38/255.0 blue:38/255.0 alpha:1]// 深色列背景
#define kLightTextColor [UIColor colorWithRed:221/255.0 green:221/255.0 blue:221/255.0 alpha:1]// 浅色列字体
#define kAdditionNavigationBarViewHigh 44 //次顶部栏高

@interface SettingFeedbackViewController ()

@end

@implementation SettingFeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNavigationBarView]; // 顶部栏设置
    [self initTableView]; // 列表设置
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
    titleL.text = @"帮助及反馈";
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
    return 3;
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
    static NSString *cellIdentifier=@"UITableViewCellStyleDefault7";
    // 首先根据标识去缓存池取
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    // 如果缓存池没有到则重新创建并放到缓存池中
    if(!cell){
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    switch (indexPath.section) {
        case 0:
            cell.textLabel.text=@"使用说明";
            break;
        case 1:
            cell.textLabel.text=@"AppStore留言";
            break;
        case 2:
            cell.textLabel.text=@"发送反馈邮件";
            break;
    }
    cell.textLabel.font = [UIFont systemFontOfSize:kTitleTextFontSize];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.backgroundColor = kDarkCellColor;
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = [UIColor darkGrayColor];
    return cell;
}

// 选中行
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.section) {
        case 0:
            [self showHelp];
            break;
        case 1:
            [self showAppstore];
            break;
        case 2:
            [self sendEmail];
            break;
    }
}











#pragma mark 自定义方法

// 展示帮助信息
-(void)showHelp{
    NSString *helpStr = @"";
}

// 展示Appstore
-(void)showAppstore{
    
}

// 发送电子邮件
-(void)sendEmail{
    NSString *email =@"mailto:hydrace@163.com?subject=使用反馈";
    email = [email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:email]];
}

-(void)btnBack{
    [self.navigationController popViewControllerAnimated:YES];
}

// 响应按钮：关闭模态窗口
-(void)btnReturnin{
    // 170304 先将模态框改为navigationController形式
    //[self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popToRootViewControllerAnimated:YES];
}


@end
