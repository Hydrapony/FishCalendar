//
//  SettingCalendarViewController.m
//  课程表设置
//
//  Created by Hydra on 17/3/7.
//  Copyright © 2017年 Hydra. All rights reserved.
//

#import "SettingCalendarViewController.h"

#import "RootViewController.h"
#import "SettingCalendarClassViewController.h"
#import "SettingCalendarModelViewController.h"
#import "SettingCalendarClassesViewController.h"

#define kLightBGColor [UIColor colorWithRed:48/255.0 green:50/255.0 blue:86/255.0 alpha:1] // 浅色背景
#define kDarkBGColor [UIColor colorWithRed:23/255.0 green:23/255.0 blue:23/255.0 alpha:1]// 深色背景
#define kDarkCellColor [UIColor colorWithRed:38/255.0 green:38/255.0 blue:38/255.0 alpha:1]// 深色列背景
#define kLightTextColor [UIColor colorWithRed:221/255.0 green:221/255.0 blue:221/255.0 alpha:1]// 浅色列字体
#define kGreenTextColor [UIColor colorWithRed:12/255.0 green:180/255.0 blue:12/255.0 alpha:1]

@interface SettingCalendarViewController ()

@end

@implementation SettingCalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNavigationBarView]; // 顶部栏设置
    [self getPlistdata]; // 获取plist数据
    [self addTableCellView]; // 列表预设置
    [self initTableView]; // 列表设置

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
    titleL.text = @"课程表设置";
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

// 获取plist数据
-(void)getPlistdata{
    _settings = ksettingsAll[@"calendar"]; // plist-calendar 内的数据存入_settings中
}

// 列表预设置
- (void)addTableCellView{
    _label1_1 = [UILabel new];
    _label1_1.textColor = kGreenTextColor;
    [self setUILabel:_label1_1 withText:_settings[@"1_1"][_settings[@"1_1"][@"0"]]];
    _label1_2 = [UILabel new];
    _label1_2.textColor = kGreenTextColor;
    [self setUILabel:_label1_2 withText:_settings[@"1_2"][_settings[@"1_2"][@"0"]]];
    _label1_3 = [UILabel new];
    _label1_3.textColor = kGreenTextColor;
    [self setUILabel:_label1_3 withText:_settings[@"1_3"][_settings[@"1_3"][@"0"]]];
    _label2_0 = [UILabel new];
    _label2_0.textColor = kGreenTextColor;
    [self setUILabel:_label2_0 withText:_settings[@"2_0"][_settings[@"2_0"][@"0"]]];
    _label2_1 = [UILabel new];
    _label2_1.textColor = kGreenTextColor;
    [self setUILabel:_label2_1 withText:_settings[@"2_1"][_settings[@"2_1"][@"0"]]];
    _label2_2 = [UILabel new];
    _label2_2.textColor = kGreenTextColor;
    [self setUILabel:_label2_2 withText:_settings[@"2_2"][_settings[@"2_2"][@"0"]]];
    _label2_3 = [UILabel new];
    _label2_3.textColor = kGreenTextColor;
    [self setUILabel:_label2_3 withText:_settings[@"2_3"][_settings[@"2_3"][@"0"]]];
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
            return 1;
        case 1:
            return 5;
        case 2:
            return 4;
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
    static NSString *cellIdentifier=@"UITableViewCellStyleDefault";
    // 首先根据标识去缓存池取
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    // 如果缓存池没有到则重新创建并放到缓存池中
    if(!cell){
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    switch (indexPath.section) {
        case 0:
            cell.textLabel.text=@"课程管理";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        case 1:
            if(indexPath.row == 0){
                cell.textLabel.text=@"日程模板";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }else if(indexPath.row == 1){
                cell.textLabel.text=@"学时制";// 5/6
                cell.detailTextLabel.text = @"每周上课天数，从周一开始";
                cell.accessoryView = _label1_1;
            }else if(indexPath.row == 2){
                cell.textLabel.text=@"课时制"; // 30-150
                cell.detailTextLabel.text = @"每节课默认时长，用于日程模板设置";
                cell.accessoryView = _label1_2;
            }else if(indexPath.row == 3){
                cell.textLabel.text=@"复式课制"; // 默认 单双周
                cell.detailTextLabel.text = @"每周课程存在差异";
                cell.accessoryView = _label1_3;
            }else if(indexPath.row == 4){
                cell.textLabel.text=@"每日课程编辑";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            break;
        case 2:
            if(indexPath.row == 0){
                cell.textLabel.text=@"课程表默认展示方式"; // 一周课程/一天课程
                cell.accessoryView = _label2_0;
            }else if(indexPath.row == 1){
                cell.textLabel.text=@"长按功能"; // 无/添加对应作业/高亮相同课程
                cell.detailTextLabel.text = @"在课程表中长按某节课";
                cell.accessoryView = _label2_1;
            }else if(indexPath.row == 2){
                cell.textLabel.text=@"目前课程显示"; // 无 高亮 边框高亮 高亮蒙版
                cell.detailTextLabel.text = @"当前课程的特殊显示方式";
                cell.accessoryView = _label2_2;
            }else if(indexPath.row == 3){
                cell.textLabel.text=@"已完成课程显示"; // 无 暗色 暗色蒙版
                cell.detailTextLabel.text = @"已完成课程特殊显示方式";
                cell.accessoryView = _label2_3;
            }
            break;
        default:
            cell.textLabel.text=@"error";
            break;
    }
    
    cell.textLabel.font = [UIFont systemFontOfSize:kTitleTextFontSize];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:kSecTitleTextFontSize];
    cell.detailTextLabel.textColor = [UIColor grayColor];
    cell.backgroundColor = kDarkCellColor;
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = [UIColor darkGrayColor];
    
    return cell;
}

// 选中行
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:{
            SettingCalendarClassViewController *classnamectrl = [SettingCalendarClassViewController new];
            [self.navigationController pushViewController:classnamectrl animated:YES];
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            return;
        }
        case 1:
            if(indexPath.row == 0){
                SettingCalendarModelViewController *classModelctrl = [SettingCalendarModelViewController new];
                [self.navigationController pushViewController:classModelctrl animated:YES];
                [tableView deselectRowAtIndexPath:indexPath animated:YES];
                return;
            }else if(indexPath.row == 1){
                int _setting0 = [_settings[@"1_1"][@"0"] intValue];
                if(++_setting0 == [_settings[@"1_1"] count]){
                    _setting0 = 1;
                }
                _settings[@"1_1"][@"0"] = [NSString stringWithFormat:@"%i",_setting0];
                [self setUILabel:_label1_1 withText:(_settings[@"1_1"][_settings[@"1_1"][@"0"]])];
            }else if(indexPath.row == 2){
                int _setting0 = [_settings[@"1_2"][@"0"] intValue];
                if(++_setting0 == [_settings[@"1_2"] count]){
                    _setting0 = 1;
                }
                _settings[@"1_2"][@"0"] = [NSString stringWithFormat:@"%i",_setting0];
                [self setUILabel:_label1_2 withText:(_settings[@"1_2"][_settings[@"1_2"][@"0"]])];
            }else if(indexPath.row == 3){
                int _setting0 = [_settings[@"1_3"][@"0"] intValue];
                if(++_setting0 == [_settings[@"1_3"] count]){
                    _setting0 = 1;
                }
                _settings[@"1_3"][@"0"] = [NSString stringWithFormat:@"%i",_setting0];
                [self setUILabel:_label1_3 withText:(_settings[@"1_3"][_settings[@"1_3"][@"0"]])];
            }else if(indexPath.row == 4){
                SettingCalendarClassesViewController *classesctrl = [SettingCalendarClassesViewController new];
                [self.navigationController pushViewController:classesctrl animated:YES];
                [tableView deselectRowAtIndexPath:indexPath animated:YES];
                return;
            }
            break;
        case 2:
            if(indexPath.row == 0){
                int _setting0 = [_settings[@"2_0"][@"0"] intValue];
                if(++_setting0 == [_settings[@"2_0"] count]){
                    _setting0 = 1;
                }
                _settings[@"2_0"][@"0"] = [NSString stringWithFormat:@"%i",_setting0];
                [self setUILabel:_label2_0 withText:(_settings[@"2_0"][_settings[@"2_0"][@"0"]])];
            }else if(indexPath.row == 1){
                int _setting0 = [_settings[@"2_1"][@"0"] intValue];
                if(++_setting0 == [_settings[@"2_1"] count]){
                    _setting0 = 1;
                }
                _settings[@"2_1"][@"0"] = [NSString stringWithFormat:@"%i",_setting0];
                [self setUILabel:_label2_1 withText:(_settings[@"2_1"][_settings[@"2_1"][@"0"]])];
            }else if(indexPath.row == 2){
                int _setting0 = [_settings[@"2_2"][@"0"] intValue];
                if(++_setting0 == [_settings[@"2_2"] count]){
                    _setting0 = 1;
                }
                _settings[@"2_2"][@"0"] = [NSString stringWithFormat:@"%i",_setting0];
                [self setUILabel:_label2_2 withText:(_settings[@"2_2"][_settings[@"2_2"][@"0"]])];
            }else if(indexPath.row == 3){
                int _setting0 = [_settings[@"2_3"][@"0"] intValue];
                if(++_setting0 == [_settings[@"2_3"] count]){
                    _setting0 = 1;
                }
                _settings[@"2_3"][@"0"] = [NSString stringWithFormat:@"%i",_setting0];
                [self setUILabel:_label2_3 withText:(_settings[@"2_3"][_settings[@"2_3"][@"0"]])];
            }
            break;
    }
    ksettingsAll[@"calendar"] = _settings;
    [Constant saveplist:ksettingsAll tofile:@"setting.plist"];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    return;
}









#pragma mark 自定义方法

// 封装方法 用于初始化右侧accessoryView里的UILabel
-(UILabel*)setUILabel:(UILabel*)label withText:(NSString*)text{
    label.text = text;
    label.font = [UIFont systemFontOfSize:15];
    CGSize infoSize=[label.text sizeWithAttributes:@{NSFontAttributeName:label.font}];
    [label setFrame:CGRectMake(0,0, infoSize.width, infoSize.height)];
    return label;
}

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
    [Constant getSetting];
    RootViewController *rootctrl = self.navigationController.viewControllers[0];
    [rootctrl removeAllCtrls];
    [rootctrl drawCalendar];
    [rootctrl addBtns];
    [rootctrl updateSumTask];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
