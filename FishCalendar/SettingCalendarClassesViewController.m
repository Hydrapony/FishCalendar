//
//  SettingCalendarClassesViewController.m
//  课程表设置-每日课程编辑
//
//  Created by Hydra on 17/3/19.
//  Copyright © 2017年 Hydra. All rights reserved.
//

#import "SettingCalendarClassesViewController.h"

#import "ClassName+CoreDataProperties.h"
#import "ChooseClassView.h"

#define kLightBGColor [UIColor colorWithRed:48/255.0 green:50/255.0 blue:86/255.0 alpha:1] // 浅色背景
#define kDarkBGColor [UIColor colorWithRed:23/255.0 green:23/255.0 blue:23/255.0 alpha:1]// 深色背景
#define kDarkCellColor [UIColor colorWithRed:38/255.0 green:38/255.0 blue:38/255.0 alpha:1]// 深色列背景
#define kLightTextColor [UIColor colorWithRed:221/255.0 green:221/255.0 blue:221/255.0 alpha:1]// 浅色列字体
#define kAdditionNavigationBarViewHigh 44 //次顶部栏高

@implementation SettingCalendarClassesViewController 

- (void)viewDidLoad {
    [super viewDidLoad];

    [Constant getSetting];
    [self getDateNow];// 获取当前日期时间
    [self getPlistdata]; // 获取plist数据
    [self initNavigationBarView]; // 顶部栏设置
    [self initTableView]; // 列表设置
}

// 获取当前日期时间
- (void)getDateNow{
    _dateNow = [NSDate date];
    NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [cal setTimeZone:[NSTimeZone timeZoneWithName:@"CCD"]];
    _dateNowComps = [cal components:NSCalendarUnitWeekOfMonth | NSCalendarUnitWeekOfYear | NSCalendarUnitWeekday fromDate:_dateNow];
    
    weekNow = 0;
    if (kdoubleWeekSetel) {
        // 计算实际weekOfYear，开头的周日调整为周一
        int weekOfYear = (int)_dateNowComps.weekOfYear;
        if(_dateNowComps.weekday == 1){
            ++weekOfYear;
        }
        if(weekOfYear % 2 == 0){
            weekNow = 1; // 双周
        }
    }
}

// 获取plist数据
-(void)getPlistdata{
    _classTime = ksettingsAll[@"classTime"];
    for (int i = 0; i < 4; ++i) {
        tempDic = _classTime[[NSString stringWithFormat:@"%i",i]];
        _segmentedClassCount[i] = (int)tempDic.count;
    }
    
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *plistPath1 = [paths objectAtIndex:0];
    NSString *plistPath=[plistPath1 stringByAppendingPathComponent:@"classInCale.plist"];
    _classInCaleAll = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    
    _classNameNameArray = [NSMutableArray new];
    NSFetchRequest *request=[NSFetchRequest fetchRequestWithEntityName:@"ClassName"];
    NSArray *classNames = [dbcontext executeFetchRequest:request error:nil];
    for (ClassName* clname in classNames) {
        [_classNameNameArray addObject:clname.name];
    }
}

// 顶部栏设置
- (void)initNavigationBarView{
    _navigationBarView=[[UIView alloc]initWithFrame:CGRectMake(viewBounds.origin.x, viewBounds.origin.y, viewBounds.size.width, kNavigationBarViewHigh + kAdditionNavigationBarViewHigh)];
    _navigationBarView.backgroundColor = kLightBGColor;
    
    // 左侧返回按钮
    UIButton *btnReturn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [btnReturn setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [btnReturn setFrame:CGRectMake(15, 28, 30, 30)];
    [btnReturn addTarget:self action:@selector(btnBack) forControlEvents:UIControlEventTouchUpInside];
    [_navigationBarView addSubview:btnReturn];
    
    // 中部标签
    UILabel *titleL = [UILabel new];
    titleL.text = @"每日课程编辑";
    titleL.textColor = [UIColor whiteColor];
    titleL.font = [UIFont systemFontOfSize:17];
    CGSize infoSize=[titleL.text sizeWithAttributes:@{NSFontAttributeName:titleL.font}];
    [titleL setFrame:CGRectMake((viewBounds.size.width - infoSize.width)/2, 34, infoSize.width, infoSize.height)];
    [_navigationBarView addSubview:titleL];
    
    // 下部分段按钮
    NSArray *segmentedArray = [[[NSArray alloc]initWithObjects:@"一",@"二",@"三",@"四",@"五",@"六",@"日",nil]subarrayWithRange:NSMakeRange(0,kwcells)];
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc]initWithItems:segmentedArray]; //初始化UISegmentedControl
    segmentedControl.frame = CGRectMake(viewBounds.size.width/18, kNavigationBarViewHigh + 4, viewBounds.size.width*8/9, 30);
    segmentedControlnum = 0;
    segmentedControl.selectedSegmentIndex = segmentedControlnum;
    segmentedControl.tintColor = [UIColor whiteColor];
    [segmentedControl addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    [_navigationBarView addSubview:segmentedControl];
    
    // 右侧切换单双周按钮
    if(kdoubleWeekSetel){
        _btnChangeWeek = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_btnChangeWeek setBackgroundImage:[UIImage imageNamed:@"btnDAN_w.png"] forState:UIControlStateNormal];
        [_btnChangeWeek setBackgroundImage:[UIImage imageNamed:@"btnSHUANG_w.png"] forState:UIControlStateSelected];
        [_btnChangeWeek setFrame:CGRectMake(viewBounds.size.width - 45, 28 ,30 ,30)];
        [_btnChangeWeek addTarget:self action:@selector(btnChangeWeekClick:) forControlEvents:UIControlEventTouchDown];
        _btnChangeWeek.selected = weekNow;
        [_navigationBarView addSubview:_btnChangeWeek];
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
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _segmentedClassCount[section];
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
    
    tempArray = _classInCaleAll[[NSString stringWithFormat:@"%i",weekNow]][[NSString stringWithFormat:@"%i",segmentedControlnum + 1]];

    /* 0320 改为固定科目
    int startClassInCale = 0;
    for (int i = 0; i < indexPath.section; ++i) {
        startClassInCale += _segmentedClassCount[i];
    }
    cell.textLabel.text = tempArray[startClassInCale + indexPath.row];
    */
    switch (indexPath.section) {
        case 0:
            cell.textLabel.text = tempArray[indexPath.row];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"晨间第 %i 节课",(int)indexPath.row + 1];
            break;
        case 1:
            cell.textLabel.text = tempArray[2 + indexPath.row];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"上午第 %i 节课",(int)indexPath.row + 1];;
            break;
        case 2:
            cell.textLabel.text = tempArray[8 + indexPath.row];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"下午第 %i 节课",(int)indexPath.row + 1];;
            break;
        case 3:
            cell.textLabel.text = tempArray[13 + indexPath.row];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"晚间第 %i 节课",(int)indexPath.row + 1];;
            break;
        default:
            break;
    }
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.font = [UIFont systemFontOfSize:kTitleTextFontSize];
    cell.detailTextLabel.textColor = [UIColor lightGrayColor];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:kInfoTextFontSize];
    cell.backgroundColor = kDarkCellColor;
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = [UIColor darkGrayColor];

    return cell;
}

// 选中行
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //[self showSelectviewIn:(int)indexPath.row];
    
    ChooseClassView *classpick = [[ChooseClassView alloc]initWithClasses:_classNameNameArray];
    [classpick show];
    classpick.selectClassBlock = ^(int classNamecu){
        tempArray = _classInCaleAll[[NSString stringWithFormat:@"%i",weekNow]][[NSString stringWithFormat:@"%i",segmentedControlnum + 1]];
        int startClassInCale = 0;
        switch (indexPath.section) {
            case 0:
                break;
            case 1:
                startClassInCale = 2;
                break;
            case 2:
                startClassInCale = 8;
                break;
            case 3:
                startClassInCale = 13;
                break;
            default:
                break;
        }
        
        tempArray[startClassInCale + indexPath.row] = classNamecu == -1?@"":_classNameNameArray[classNamecu];
        [self saveplist];
        [_tableView reloadData];
    };
    
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
    
    segmentedControlnum = (int)nindex;
    [_tableView reloadData];
}

// 封装方法 用于保存plist
-(void)saveplist{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *plistPath1 = [paths objectAtIndex:0];
    //得到完整的文件路径
    NSString *plistPath=[plistPath1 stringByAppendingPathComponent:@"classInCale.plist"];
    //写入
    [_classInCaleAll writeToFile:plistPath atomically:YES];
}

-(void)btnChangeWeekClick:(UIButton*)senderBtn{
    senderBtn.selected = !senderBtn.selected;
    weekNow = !weekNow;
    [_tableView reloadData];
}

-(void)btnBack{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
