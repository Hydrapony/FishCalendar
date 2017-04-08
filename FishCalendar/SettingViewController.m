//
//  SettingViewController.m
//  根设置页
//
//  Created by Hydra on 17/3/7.
//  Copyright © 2017年 Hydra. All rights reserved.
//

#import "SettingViewController.h"

#import "RootViewController.h"

#define kLightBGColor [UIColor colorWithRed:48/255.0 green:50/255.0 blue:86/255.0 alpha:1] // 浅色背景
#define kDarkBGColor [UIColor colorWithRed:23/255.0 green:23/255.0 blue:23/255.0 alpha:1]// 深色背景
#define kDarkCellColor [UIColor colorWithRed:38/255.0 green:38/255.0 blue:38/255.0 alpha:1]// 深色列背景
#define kLightTextColor [UIColor colorWithRed:221/255.0 green:221/255.0 blue:221/255.0 alpha:1]// 浅色列字体

@interface SettingViewController ()

@end

@implementation SettingViewController

# pragma mark 初始化

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNavigationBarView]; // 顶部栏设置
    [self initTableView]; // 列表设置
}

// 顶部栏设置
- (void)initNavigationBarView{
    _navigationBarView=[[UIView alloc]initWithFrame:CGRectMake(viewBounds.origin.x, viewBounds.origin.y, viewBounds.size.width, kNavigationBarViewHigh)];
    _navigationBarView.backgroundColor = kLightBGColor;
    
    // 左侧返回主页按钮
    UIButton *btnReturn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [btnReturn setBackgroundImage:[UIImage imageNamed:@"home.png"] forState:UIControlStateNormal];
    [btnReturn setFrame:kbtn1rect];
    [btnReturn addTarget:self action:@selector(btnReturnin) forControlEvents:UIControlEventTouchUpInside];
    [_navigationBarView addSubview:btnReturn];
    
    // 中部标签
    UILabel *titleL = [UILabel new];
    titleL.text = @"设置";
    titleL.textColor = [UIColor whiteColor];
    titleL.font = [UIFont systemFontOfSize:17];
    CGSize infoSize=[titleL.text sizeWithAttributes:@{NSFontAttributeName:titleL.font}];
    [titleL setFrame:CGRectMake((viewBounds.size.width - infoSize.width)/2, 34, infoSize.width, infoSize.height)];
    [_navigationBarView addSubview:titleL];
    
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
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 2;
        case 1:
            return 2;
        case 2:
            return 1;
    }
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
    static NSString *cellIdentifier=@"UITableViewCellStyleDefault1";
    // 首先根据标识去缓存池取
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    // 如果缓存池没有到则重新创建并放到缓存池中
    if(!cell){
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    switch (indexPath.section) {
        case 0:
            if(indexPath.row == 0){
                cell.textLabel.text=@"课程表设置";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }else if(indexPath.row == 1){
                cell.textLabel.text=@"日常作业";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            break;
        case 1:
            if(indexPath.row == 0){
                cell.textLabel.text=@"参数设置";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }else if(indexPath.row == 1){
                cell.textLabel.text=@"重置系统";
            }
            break;
        case 2:
            cell.textLabel.text=@"帮助及反馈";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        default:
            cell.textLabel.text=@"error";
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
            if(indexPath.row == 0){
                SettingCalendarViewController *settingcontroller = [[SettingCalendarViewController alloc]init];
                [self.navigationController pushViewController:settingcontroller animated:YES];
                return;
            }else if(indexPath.row == 1){
                SettingDailyViewController *settingcontroller = [[SettingDailyViewController alloc]init];
                [self.navigationController pushViewController:settingcontroller animated:YES];
                return;
            }
            break;
        case 1:
            if(indexPath.row == 0){
                SettingParametersViewController *settingcontroller = [[SettingParametersViewController alloc]init];
                [self.navigationController pushViewController:settingcontroller animated:YES];
                return;
            }else if(indexPath.row == 1){
                [self resetSystem];
            }
            break;
        case 2:{
            SettingFeedbackViewController *settingcontroller = [SettingFeedbackViewController new];
            [self.navigationController pushViewController:settingcontroller animated:YES];
        }
            
        default:
            break;
    }

}








#pragma mark 自定义方法

// 响应重设系统
-(void)resetSystem{
    // 创建
    UIAlertController *alertview=[UIAlertController alertControllerWithTitle:@"提示" message:@"是否确认重置所有数据和设置？" preferredStyle:UIAlertControllerStyleActionSheet];
    // UIAlertControllerStyleActionSheet 是显示在屏幕底部 、UIAlertControllerStyleAlert 是显示在中间
    // 设置按钮
    UIAlertAction *cancel=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
    UIAlertAction *defult = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        // 删除数据库文件
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *kFileName = @"myDatabase";
        NSString *filePath1 = [documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.db",kFileName]];
        NSString *filePath2 = [documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.db-shm",kFileName]];
        NSString *filePath3 = [documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.db-wal",kFileName]];
        NSString *filePath4 = [documentsPath stringByAppendingPathComponent:@"setting.plist"];
        NSString *filePath5 = [documentsPath stringByAppendingPathComponent:@"classInCale.plist"];
        NSError *error;
        BOOL success = [fileManager removeItemAtPath:filePath1 error:&error];
        [fileManager removeItemAtPath:filePath2 error:nil];
        [fileManager removeItemAtPath:filePath3 error:nil];
        [fileManager removeItemAtPath:filePath4 error:nil];
        [fileManager removeItemAtPath:filePath5 error:nil];
        if (success) {
            NSLog(@"Remove fiel:%@ Success!",kFileName);
        }
        else
        {
            NSLog(@"Could not delete file -:%@ ",[error localizedDescription]);
        }
        // 移除存储器再重新添加
        [Constant updateDbContext:dbcontext];
        // 数据库初始数据
        [Constant initOriginData];
        // 初始setting.plist数据
        [Constant getSetting];
        // 初始课程表数据
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"classInCale" ofType:@"plist"];
        NSString *filePath=[documentsPath stringByAppendingPathComponent:@"classInCale.plist"];
        NSMutableDictionary *pdata = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
        pdata = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
        [pdata writeToFile:filePath atomically:YES];
        // 回到根视图
        RootViewController *rootctrl = self.navigationController.viewControllers[0];
        [rootctrl removeAllCtrls];
        [rootctrl drawCalendar];
        [rootctrl addBtns];
        [rootctrl updateSumTaskto1];
        [self.navigationController popToRootViewControllerAnimated:YES];

    }];
    //UIAlertAction *destructive = [UIAlertAction actionWithTitle:@"destructive" style:UIAlertActionStyleDestructive handler:nil];
    [alertview addAction:cancel];
    [alertview addAction:defult];
    //[alertview addAction:destructive];
    [self presentViewController:alertview animated:YES completion:nil];
}

// 响应按钮：关闭
-(void)btnReturnin{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
