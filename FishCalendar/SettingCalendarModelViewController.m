//
//  SettingCalendarModelViewController.m
//  课程表设置-日程模板
//
//  Created by Hydra on 17/3/17.
//  Copyright © 2017年 Hydra. All rights reserved.
//

#import "SettingCalendarModelViewController.h"

#import "RootViewController.h"
#import "TimePickerView.h"

#define kLightBGColor [UIColor colorWithRed:48/255.0 green:50/255.0 blue:86/255.0 alpha:1] // 浅色背景
#define kDarkBGColor [UIColor colorWithRed:23/255.0 green:23/255.0 blue:23/255.0 alpha:1]// 深色背景
#define kDarkCellColor [UIColor colorWithRed:38/255.0 green:38/255.0 blue:38/255.0 alpha:1]// 深色列背景
#define kLightTextColor [UIColor colorWithRed:221/255.0 green:221/255.0 blue:221/255.0 alpha:1]// 浅色列字体
#define kAdditionNavigationBarViewHigh 44 //次顶部栏高

@implementation SettingCalendarModelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getPlistdata]; // 获取plist数据
    [self initNavigationBarView]; // 顶部栏设置
    [self initTableView]; // 列表设置
    
}

// 获取plist数据
-(void)getPlistdata{
    _calendars = ksettingsAll[@"calendar"];
    hperclassLength = [_calendars[@"1_2"][_calendars[@"1_2"][@"0"]] intValue]; // 课时制（长）
    
    _classTime = ksettingsAll[@"classTime"];
    
    for (int i = 0; i < 4; ++i) {
        tempDic = _classTime[[NSString stringWithFormat:@"%i",i]];
        _segmentedClassCount[i] = (int)tempDic.count;
    }
    _segmentedMaxClassCount[0] = 2;
    _segmentedMaxClassCount[1] = 6;
    _segmentedMaxClassCount[2] = 5;
    _segmentedMaxClassCount[3] = 3;
}

// 顶部栏设置
- (void)initNavigationBarView{
    _navigationBarView=[[UIView alloc]initWithFrame:CGRectMake(viewBounds.origin.x, viewBounds.origin.y, viewBounds.size.width, kNavigationBarViewHigh + kAdditionNavigationBarViewHigh)];
    _navigationBarView.backgroundColor = kLightBGColor;
    
    // 左侧返回按钮
    UIButton *btnReturn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [btnReturn setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [btnReturn setFrame:kbtn1rect];
    [btnReturn addTarget:self action:@selector(btnBack) forControlEvents:UIControlEventTouchUpInside];
    [_navigationBarView addSubview:btnReturn];
    
    // 中部标签
    UILabel *titleL = [UILabel new];
    titleL.text = @"日程模板";
    titleL.textColor = [UIColor whiteColor];
    titleL.font = [UIFont systemFontOfSize:17];
    CGSize infoSize=[titleL.text sizeWithAttributes:@{NSFontAttributeName:titleL.font}];
    [titleL setFrame:CGRectMake((viewBounds.size.width - infoSize.width)/2, 34, infoSize.width, infoSize.height)];
    [_navigationBarView addSubview:titleL];
    
    // 下侧分段按钮
    NSArray *segmentedArray = [[NSArray alloc]initWithObjects:@"晨间",@"上午",@"下午",@"晚间",nil];
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc]initWithItems:segmentedArray]; //初始化UISegmentedControl
    segmentedControl.frame = CGRectMake(viewBounds.size.width/18, kNavigationBarViewHigh + 4, viewBounds.size.width*8/9, 30);
    segmentedControlnum = 0;
    segmentedControl.selectedSegmentIndex = segmentedControlnum;
    segmentedControl.tintColor = [UIColor whiteColor];
    [segmentedControl addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    [_navigationBarView addSubview:segmentedControl];
    
    // 右侧添加按钮
    _btnAddClass = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [_btnAddClass setBackgroundImage:[UIImage imageNamed:@"PlusMath.png"] forState:UIControlStateNormal];
    [_btnAddClass setFrame:kbtn3rect];
    [_btnAddClass addTarget:self action:@selector(btnAddCl) forControlEvents:UIControlEventTouchUpInside];
    [_navigationBarView addSubview:_btnAddClass];
    
    // 右侧删除按钮
    _btnDelClass = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [_btnDelClass setBackgroundImage:[UIImage imageNamed:@"MinusMath.png"] forState:UIControlStateNormal];
    [_btnDelClass setFrame:kbtn4rect];
    [_btnDelClass addTarget:self action:@selector(btnMnsCl) forControlEvents:UIControlEventTouchUpInside];
    [_navigationBarView addSubview:_btnDelClass];
    
    // 右侧按钮失效设置
    if(_segmentedClassCount[0] == 0){
        _btnAddClass.enabled = true;
        _btnDelClass.enabled = false;
    }else if (_segmentedClassCount[0] == 2){
        _btnAddClass.enabled = false;
        _btnDelClass.enabled = true;
    }else{
        _btnAddClass.enabled = true;
        _btnDelClass.enabled = true;
    }
    
    [self.view addSubview:_navigationBarView];
}

// 列表设置
- (void)initTableView{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(viewBounds.origin.x, viewBounds.origin.y + kNavigationBarViewHigh + kAdditionNavigationBarViewHigh, viewBounds.size.width, viewBounds.size.height - kNavigationBarViewHigh - kAdditionNavigationBarViewHigh) style:UITableViewStyleGrouped];
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
    if(_segmentedClassCount[segmentedControlnum] > 0){
        return 1;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    tempDic = _classTime[[NSString stringWithFormat:@"%i",segmentedControlnum]];
    return tempDic.count;
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
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"第 %i 节课",(int)indexPath.row + 1];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.font = [UIFont systemFontOfSize:kTitleTextFontSize];
    cell.detailTextLabel.text = _classTime[[NSString stringWithFormat:@"%i",segmentedControlnum]][[NSString stringWithFormat:@"%i",(int)indexPath.row]];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:kSecTitleTextFontSize];
    cell.detailTextLabel.textColor = [UIColor lightGrayColor];
    cell.backgroundColor = kDarkCellColor;
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = [UIColor darkGrayColor];
    
    return cell;
}

// 选中行
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self showSelectviewIn:(int)indexPath.row];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}









#pragma mark 自定义方法

// 响应分段按钮
-(void)segmentAction:(UISegmentedControl *)Seg{
    NSInteger nindex = Seg.selectedSegmentIndex;
    // 转场动画
    CATransition *transition=[[CATransition alloc]init];
    transition.type=@"push";
    if(segmentedControlnum < nindex){
        transition.subtype=kCATransitionFromRight;
    }else{
        transition.subtype=kCATransitionFromLeft;
    }
    transition.duration=0.3f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    [_tableView.layer addAnimation:transition forKey:@"KCTransitionAnimation"];
    
    // 设置目前栏参数/按钮状态
    segmentedControlnum = (int)nindex;
    if (_segmentedClassCount[segmentedControlnum] == 0 ||
        (_segmentedClassCount[segmentedControlnum] == 1 && (segmentedControlnum == 1 || segmentedControlnum == 2))) {
        _btnAddClass.enabled = true;
        _btnDelClass.enabled = false;
    }else if (_segmentedClassCount[segmentedControlnum] == _segmentedMaxClassCount[segmentedControlnum]){
        _btnAddClass.enabled = false;
        _btnDelClass.enabled = true;
    }else{
        _btnAddClass.enabled = true;
        _btnDelClass.enabled = true;
    }
    
    [_tableView reloadData];
}

// 时间选择弹框
-(void)showSelectviewIn:(int)row{
    NSString *cTimes = _classTime[[NSString stringWithFormat:@"%i",segmentedControlnum]][[NSString stringWithFormat:@"%i",row]];
    
    TimePickerView *tpick = [TimePickerView new];
    [tpick setCTime:cTimes];
    tpick.perclassLength = hperclassLength;
    [tpick show];
    tpick.gotoSrceenOrderBlock = ^(NSString *beginDateStr, NSString *endDateStr){
        NSString *cTimeBeginEnd = [NSString stringWithFormat:@"%@-%@",beginDateStr,endDateStr];
        _classTime[[NSString stringWithFormat:@"%i",segmentedControlnum]][[NSString stringWithFormat:@"%i",row]] = cTimeBeginEnd;
        ksettingsAll[@"classTime"] = _classTime;
        [Constant saveplist:ksettingsAll tofile:@"setting.plist"];
        [_tableView reloadData];
    };
    
}

// 响应按钮：加
-(void)btnAddCl{
    tempDic = _classTime[[NSString stringWithFormat:@"%i",segmentedControlnum]]; // 当时段的字典
    if (_segmentedClassCount[segmentedControlnum] == 0) {
        tempDic[@"0"] = @"0:00-0:00";
        ++_segmentedClassCount[segmentedControlnum];
        // 插入新组
        [_tableView insertSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationLeft];
        _btnDelClass.enabled = true;
    }
    else{
        tempDic[[NSString stringWithFormat:@"%i",_segmentedClassCount[segmentedControlnum]]] = @"0:00-0:00";
        ++_segmentedClassCount[segmentedControlnum];
        // 插入新行
        [_tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:(_segmentedClassCount[segmentedControlnum]-1) inSection:0]] withRowAnimation:UITableViewRowAnimationLeft];
        if(segmentedControlnum == 1||segmentedControlnum == 2){
            if (_segmentedClassCount[segmentedControlnum] == 2) {
                _btnDelClass.enabled = true;
            }
        }
    }
    ksettingsAll[@"classTime"] = _classTime;
    [Constant saveplist:ksettingsAll tofile:@"setting.plist"];
    
    if (_segmentedClassCount[segmentedControlnum] == _segmentedMaxClassCount[segmentedControlnum]) {
        _btnAddClass.enabled = false;
    }
}

// 响应按钮：减
-(void)btnMnsCl{
    tempDic = _classTime[[NSString stringWithFormat:@"%i",segmentedControlnum]];
    if (_segmentedClassCount[segmentedControlnum] == 1) {
        [tempDic removeObjectForKey:@"0"];
        _segmentedClassCount[segmentedControlnum] = 0;
        // 删除组
        [_tableView deleteSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationLeft];
    }
    else{
        [tempDic removeObjectForKey:[NSString stringWithFormat:@"%i",_segmentedClassCount[segmentedControlnum]-1]];
        // 删除行
        [_tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:(_segmentedClassCount[segmentedControlnum]-- - 1) inSection:0]] withRowAnimation:UITableViewRowAnimationLeft];
        if (_segmentedClassCount[segmentedControlnum] == _segmentedMaxClassCount[segmentedControlnum] - 1) {
            _btnAddClass.enabled = true;
        }
    }
    ksettingsAll[@"classTime"] = _classTime;
    [Constant saveplist:ksettingsAll tofile:@"setting.plist"];
    
    if(segmentedControlnum == 1||segmentedControlnum == 2){
        if (_segmentedClassCount[segmentedControlnum] == 1) {
            _btnDelClass.enabled = false;
        }
    }else if (_segmentedClassCount[segmentedControlnum] == 0) {
        _btnDelClass.enabled = false;
    }
}

-(void)btnBack{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
