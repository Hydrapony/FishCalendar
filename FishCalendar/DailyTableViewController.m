//
//  DailyTableViewController.m
//  日常作业页面
//
//  Created by Hydra on 17/2/9.
//  Copyright © 2017年 Hydra. All rights reserved.
//

#import "DailyTableViewController.h"

#define kLightBGColor [UIColor colorWithRed:38/255.0 green:50/255.0 blue:56/255.0 alpha:1] // 浅色背景
#define kDarkBGColor [UIColor colorWithRed:23/255.0 green:23/255.0 blue:23/255.0 alpha:1]// 深色背景
#define kDarkCellColor [UIColor colorWithRed:38/255.0 green:38/255.0 blue:38/255.0 alpha:1]// 深色列背景
#define kLightTextColor [UIColor colorWithRed:221/255.0 green:221/255.0 blue:221/255.0 alpha:1]// 浅色列字体
#define kDailyNavigationBarViewHigh 78 //顶部栏高
#define kOldCellColor [UIColor colorWithRed:100/255.0 green:60/255.0 blue:60/255.0 alpha:1] // 延期任务背景色

@implementation DailyTableViewController

#pragma mark 初始化

// 初始化
- (void)viewDidLoad {
    [super viewDidLoad];
    
    if(dbcontext){
        _dailys=[[NSMutableArray alloc]init];
        _dailysAndOld=[[NSMutableArray alloc]init];
        _dailysHd=[[NSMutableArray alloc]init];
        _dailysD=[[NSMutableArray alloc]init];
        _dailyCells=[[NSMutableArray alloc]init];
        _dailyCellsAndOld=[[NSMutableArray alloc]init];
        _dailyCellsHd=[[NSMutableArray alloc]init];
        _dailyCellsD=[[NSMutableArray alloc]init];
        [self initData]; //初始化数据
        [self initNavigationBarView]; // 顶部栏设置
        [self initTableView]; // 列表设置
    }else{
        ;
    }
}

// 加载数据
-(void)initData{
    // 取结束于当日6:00~明日6:00 所有任务
    // 以enddate为判断依据，enddate中只保存指定的日期，没有时间，也不考虑时区，但应看做是北京标准时
    // 在此取出当前时间所对应的时段（如2月5日23点、2月6日1点，都属于2月5日6点-2月6日6点段）作为条件
    int daycutTime = [kSlashTime intValue];
    NSDate *nowDate = [NSDate date];
    NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian]; // UTC时间
    [cal setTimeZone:[NSTimeZone timeZoneWithName:@"CCD"]];
    NSDateComponents *comps = [cal components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour fromDate:nowDate]; // 取数据（北京时间）
    if([comps hour] < daycutTime){
        nowDate = [[NSDate alloc] initWithTimeInterval:-60*60*24 sinceDate:nowDate];
    }
    NSDate *nextDate = [[NSDate alloc] initWithTimeInterval:60*60*24 sinceDate:nowDate];
    NSString *daycutTimeStr;
    if(daycutTime < 10){
        daycutTimeStr = [NSString stringWithFormat:@" 0%i:00:00",daycutTime];
    }else{
        daycutTimeStr = [NSString stringWithFormat:@" %i:00:00",daycutTime];
    }

    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"CCD"]];
    df.dateFormat = @"yyyy/MM/dd";
    
    NSString *nowDateStr = [df stringFromDate:nowDate]; // 当前时段的日期部分
    nowDateStr = [nowDateStr stringByAppendingString:daycutTimeStr]; //当日早晨6:00
    NSString *nextDateStr = [df stringFromDate:nextDate];
    nextDateStr = [nextDateStr stringByAppendingString:daycutTimeStr]; //明日早晨6:00
    df.dateFormat = @"yyyy/MM/dd HH:mm:ss";
    NSDate *nowDate_6am = [df dateFromString: nowDateStr];
    NSDate *nextDate_6am = [df dateFromString: nextDateStr];
    
    NSFetchRequest *request=[NSFetchRequest fetchRequestWithEntityName:@"Daily"];
    request.predicate=[NSPredicate predicateWithFormat:@"enddate >= %@ AND enddate <= %@",nowDate_6am,nextDate_6am];
    _dailys =[NSMutableArray arrayWithArray:[dbcontext executeFetchRequest:request error:nil]];
    
    request.predicate=[NSPredicate predicateWithFormat:@"enddate < %@ AND isvalid = true",nowDate_6am];
    _dailysAndOld =[NSMutableArray arrayWithArray:[dbcontext executeFetchRequest:request error:nil]];
    
    NSPredicate *PredicateHdd = [NSPredicate predicateWithFormat:@"isvalid = true"];
    _dailysHd = [NSMutableArray arrayWithArray:[_dailys filteredArrayUsingPredicate:PredicateHdd]];
    
    PredicateHdd = [NSPredicate predicateWithFormat:@"isvalid = false"];
    _dailysD = [NSMutableArray arrayWithArray:[_dailys filteredArrayUsingPredicate:PredicateHdd]];
    
    havedoneSum = 0;
    doneSum = 0;
    for(int i=0;i<_dailys.count;++i){
        // 计算计划时间总和
        Daily *csdaily = _dailys[i];
        havedoneSum += [csdaily.havedone doubleValue];
        if(csdaily.isvalid.integerValue == 0){
            doneSum += [csdaily.havedone doubleValue];
            DailyTableViewCell *cellD = [DailyTableViewCell new];
            [_dailyCellsD addObject:cellD];
        }else{
            DailyTableViewCell *cellHd = [DailyTableViewCell new];
            [_dailyCellsHd addObject:cellHd];
        }
        // 创建所有列
        DailyTableViewCell *cell = [DailyTableViewCell new];
        [_dailyCells addObject:cell];
    }
    for(int i=0;i<_dailysAndOld.count;++i){
        DailyTableViewCell *cellOld = [DailyTableViewCell new];
        [_dailyCellsAndOld addObject:cellOld];
    }
}

// 顶部栏初始化
-(void)initNavigationBarView{
    _navigationBarView=[[UIView alloc]initWithFrame:CGRectMake(viewBounds.origin.x, viewBounds.origin.y, viewBounds.size.width, kDailyNavigationBarViewHigh)];
    _navigationBarView.backgroundColor = kLightBGColor;

    // 左侧返回根视图按钮
    UIButton *btnReturn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [btnReturn setBackgroundImage:[UIImage imageNamed:@"home.png"] forState:UIControlStateNormal];
    [btnReturn setFrame:kbtn1rect];
    [btnReturn addTarget:self action:@selector(btnReturnin) forControlEvents:UIControlEventTouchUpInside];
    [_navigationBarView addSubview:btnReturn];
    
    // 中部分段按钮
    NSArray *segmentedArray = [[NSArray alloc]initWithObjects:@"未完成",@"已完成",@"全部",nil];
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc]initWithItems:segmentedArray]; //初始化UISegmentedControl
    segmentedControl.frame = CGRectMake((viewBounds.size.width - 200)/2, 30, 200, 30);
    segmentedControlnum = [kDefaultHwType intValue] - 1; // 设置默认选择项索引
    segmentedControl.selectedSegmentIndex = segmentedControlnum;
    segmentedControl.tintColor = [UIColor whiteColor];
    [segmentedControl addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    [_navigationBarView addSubview:segmentedControl];
    
    // 下部进度条
    UIProgressView *progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    progressView.backgroundColor = [UIColor blackColor];
    progressView.frame = CGRectMake(0, 73, viewBounds.size.width ,1);
    [progressView setProgress:(havedoneSum == 0?0:doneSum/havedoneSum) animated:NO]; // 设置当前进度，yes伴有动画效果
    progressView.trackTintColor = [UIColor blackColor];   //设置轨道颜色
    progressView.progressTintColor = [UIColor lightGrayColor];  //设置进度颜色
    progressView.tag = 101;
    [_navigationBarView addSubview:progressView];
    
    // 下部进度角标
    UILabel *progressViewLabel = [UILabel new];
    if([kProgressMM isEqualToString:@"1"]){
        progressViewLabel.text = [NSString stringWithFormat:@"%.0f / %.0f", doneSum, havedoneSum];
    }else{
        // 换算为时分
        int doneSumI = (int)doneSum;
        NSString *doneSumIstr;
        if (doneSumI%60 != 0) {
            doneSumIstr = [NSString stringWithFormat:@"%i时%i分", doneSumI/60, doneSumI%60];
        }else{
            doneSumIstr = [NSString stringWithFormat:@"%i时", doneSumI/60];
        }
        int havedoneSumI = (int)havedoneSum;
        NSString *havedoneSumIstr;
        if (havedoneSumI%60 != 0) {
            havedoneSumIstr = [NSString stringWithFormat:@"%i时%i分", havedoneSumI/60, havedoneSumI%60];
        }else{
            havedoneSumIstr = [NSString stringWithFormat:@"%i时", havedoneSumI/60];
        }
        progressViewLabel.text = [NSString stringWithFormat:@"%@ / %@", doneSumIstr, havedoneSumIstr];
    }
    progressViewLabel.textColor = [UIColor grayColor];
    progressViewLabel.font = [UIFont systemFontOfSize:12];
    CGSize infoSize=[progressViewLabel.text sizeWithAttributes:@{NSFontAttributeName:progressViewLabel.font}];
    [progressViewLabel setFrame:CGRectMake(viewBounds.size.width - infoSize.width - 2, 64, infoSize.width, infoSize.height)];
    progressViewLabel.tag = 100;
    if(![kProgressMM isEqualToString:@"3"]){
        [_navigationBarView addSubview:progressViewLabel];
    }
    
    // 右侧新增按钮
    UIButton *btnNew = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [btnNew setBackgroundImage:[UIImage imageNamed:@"new.png"] forState:UIControlStateNormal];
    [btnNew setFrame:kbtn4rect];
    [btnNew addTarget:self action:@selector(btnnew) forControlEvents:UIControlEventTouchUpInside];
    [_navigationBarView addSubview:btnNew];
    
    [self.view addSubview:_navigationBarView];
}

// 列表初始化
-(void)initTableView{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(viewBounds.origin.x, viewBounds.origin.y + kDailyNavigationBarViewHigh, viewBounds.size.width, viewBounds.size.height - kDailyNavigationBarViewHigh) style:UITableViewStyleGrouped];
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
    switch (segmentedControlnum) {
        case 0:
            // 取未完成的
            return _dailysHd.count + _dailysAndOld.count;
        case 1:
            // 取已完成的
            return _dailysD.count;
        case 2:
            // 全部
            return _dailys.count;
    }
    return _dailys.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1; // 每组仅有一条数据
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
    DailyTableViewCell *cell;
    if (segmentedControlnum == 0) {
        // 取未完成的
        if(indexPath.section < _dailysHd.count){
            cell = _dailyCellsHd[indexPath.section];
            Daily *csdaily = _dailysHd[indexPath.section];
            [cell loadDaily:csdaily withInfo:@{@"indexPath":indexPath,@"viewController":self}];
        }else{
            cell = _dailyCellsAndOld[indexPath.section - _dailysHd.count];
            Daily *csdaily = _dailysAndOld[indexPath.section - _dailysHd.count];
            [cell loadDaily:csdaily withInfo:@{@"indexPath":indexPath,@"viewController":self}];
            // 特殊背景色
            [cell setCellColor:kOldCellColor];
            cell.backgroundColor = kOldCellColor;
            return cell;
        }
    }else if (segmentedControlnum == 1){
        // 取已完成的
        cell = _dailyCellsD[indexPath.section];
        Daily *csdaily = _dailysD[indexPath.section];
        [cell loadDaily:csdaily withInfo:@{@"indexPath":indexPath,@"viewController":self}];
    }else{
        // 取全部
        cell = _dailyCells[indexPath.section];
        Daily *csdaily = _dailys[indexPath.section];
        [cell loadDaily:csdaily withInfo:@{@"indexPath":indexPath,@"viewController":self}];
    }
    
    cell.backgroundColor = kDarkCellColor;
    return cell;
}






#pragma mark TableView代理方法

// 设置行高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (segmentedControlnum == 0) {
        if (indexPath.section < _dailysHd.count) {
            DailyTableViewCell *cell= _dailyCellsHd[indexPath.section];
            return cell.height;
        }else{
            DailyTableViewCell *cell= _dailyCellsAndOld[indexPath.section - _dailysHd.count];
            return cell.height;
        }
    }else if (segmentedControlnum == 1) {
        DailyTableViewCell *cell= _dailyCellsD[indexPath.section];
        return cell.height;
    }else{
        DailyTableViewCell *cell= _dailyCells[indexPath.section];
        return cell.height;
    }
}





#pragma mark RingBtn代理方法 

// 环形按钮完成
-(void)ringComplete:(NSDictionary *)infoDic{
    NSIndexPath *indexPath = infoDic[@"indexPath"];
    Daily *thedaily;
    
    // 数据库更新为完成
    if (segmentedControlnum == 0){
        if(indexPath.section < _dailysHd.count){
            thedaily = _dailysHd[indexPath.section];
        }else{
            thedaily = _dailysAndOld[indexPath.section - _dailysHd.count];
        }
    }else{
        thedaily = _dailys[indexPath.section];
    }
    NSDictionary *dic = @{@"isvalid":@0};
    [Daily modifyDaily:thedaily withDictionary:dic withDbcx:dbcontext];
    
    // 更改下部进度、进度角标
    if (segmentedControlnum == 0 && indexPath.section < _dailysHd.count){
        doneSum += [thedaily.havedone doubleValue];
        UIProgressView *progressView = [_navigationBarView viewWithTag:101];
        [progressView setProgress:(havedoneSum == 0?0:doneSum/havedoneSum) animated:YES]; // 设置当前进度
        UILabel *progressViewLabel = [_navigationBarView viewWithTag:100];
        if([kProgressMM isEqualToString:@"1"]){
            progressViewLabel.text = [NSString stringWithFormat:@"%.0f / %.0f", doneSum, havedoneSum];
        }else{
            // 换算为时分
            int doneSumI = (int)doneSum;
            NSString *doneSumIstr;
            if (doneSumI%60 != 0) {
                doneSumIstr = [NSString stringWithFormat:@"%i时%i分", doneSumI/60, doneSumI%60];
            }else{
                doneSumIstr = [NSString stringWithFormat:@"%i时", doneSumI/60];
            }
            int havedoneSumI = (int)havedoneSum;
            NSString *havedoneSumIstr;
            if (havedoneSumI%60 != 0) {
                havedoneSumIstr = [NSString stringWithFormat:@"%i时%i分", havedoneSumI/60, havedoneSumI%60];
            }else{
                havedoneSumIstr = [NSString stringWithFormat:@"%i时", havedoneSumI/60];
            }
            progressViewLabel.text = [NSString stringWithFormat:@"%@ / %@", doneSumIstr, havedoneSumIstr];
        }
        CGSize infoSize=[progressViewLabel.text sizeWithAttributes:@{NSFontAttributeName:progressViewLabel.font}];
        [progressViewLabel setFrame:CGRectMake(viewBounds.size.width - infoSize.width - 2, 64, infoSize.width, infoSize.height)];
    }
    
    // 更新列表
    if (segmentedControlnum == 0){
        [_tableView beginUpdates];
        if(indexPath.section < _dailysHd.count){
            [_dailysD addObject:_dailysHd[indexPath.section]];
            [_dailysHd removeObjectAtIndex:indexPath.section];
            [_dailyCellsD addObject:_dailyCellsHd[indexPath.section]];
            [_dailyCellsHd removeObjectAtIndex:indexPath.section];
        }else{
            [_dailysAndOld removeObjectAtIndex:indexPath.section - _dailysHd.count];
            [_dailyCellsAndOld removeObjectAtIndex:indexPath.section - _dailysHd.count];
        }
        [_tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationLeft];
        [_tableView reloadData];
        [_tableView endUpdates];
    }else{
        [_dailysD addObject:_dailys[indexPath.section]];
        [_dailyCellsD addObject:_dailyCells[indexPath.section]];
        [_dailysHd removeObject:_dailys[indexPath.section]];
        [_dailyCellsHd removeObject:_dailyCells[indexPath.section]];
    }
    
    [_sumtaskDelegate updateSumTask:-1];
}



#pragma mark DailyViewDelegate代理方法

// 查询备选数据
-(NSMutableArray*)addData{
    NSMutableArray *dataArray = [NSMutableArray new];
    
    // 查询所有任务名
    NSFetchRequest *request=[NSFetchRequest fetchRequestWithEntityName:@"ClassName"];
    [dataArray addObject:[dbcontext executeFetchRequest:request error:nil]];
    
    // 查询所有图示名
    request=[NSFetchRequest fetchRequestWithEntityName:@"Iconimg"];
    [dataArray addObject:[dbcontext executeFetchRequest:request error:nil]];
    
    return dataArray;
}

// 保存新数据
-(bool)saveData:(NSDictionary*)dailyDic{
    NSString *saveType = dailyDic[@"saveType"];
    if([saveType isEqualToString:@"Daily"]){
        return [Daily addWithDictionary:dailyDic withDbcx:dbcontext] != nil;
    }
    if([saveType isEqualToString:@"DailyLong"]){
        return [DailyLong addWithDictionary:dailyDic withDbcx:dbcontext] != nil;
    }
    return false;
}

// 更新列表
-(void)updateList{
    [_sumtaskDelegate updateSumTask:1];
    [self initData];
    [_tableView reloadData];
}

// 更新列表 进度
-(void)updateListAndProgressView:(long)addMinute{
    // 更改下部进度、进度角标
    havedoneSum += addMinute;
    UIProgressView *progressView = [_navigationBarView viewWithTag:101];
    [progressView setProgress:(havedoneSum == 0?0:doneSum/havedoneSum) animated:YES]; // 设置当前进度
    UILabel *progressViewLabel = [_navigationBarView viewWithTag:100];
    if([kProgressMM isEqualToString:@"1"]){
        progressViewLabel.text = [NSString stringWithFormat:@"%.0f / %.0f", doneSum, havedoneSum];
    }else{
        // 换算为时分
        int doneSumI = (int)doneSum;
        NSString *doneSumIstr;
        if (doneSumI%60 != 0) {
            doneSumIstr = [NSString stringWithFormat:@"%i时%i分", doneSumI/60, doneSumI%60];
        }else{
            doneSumIstr = [NSString stringWithFormat:@"%i时", doneSumI/60];
        }
        int havedoneSumI = (int)havedoneSum;
        NSString *havedoneSumIstr;
        if (havedoneSumI%60 != 0) {
            havedoneSumIstr = [NSString stringWithFormat:@"%i时%i分", havedoneSumI/60, havedoneSumI%60];
        }else{
            havedoneSumIstr = [NSString stringWithFormat:@"%i时", havedoneSumI/60];
        }
        progressViewLabel.text = [NSString stringWithFormat:@"%@ / %@", doneSumIstr, havedoneSumIstr];
    }
    CGSize infoSize=[progressViewLabel.text sizeWithAttributes:@{NSFontAttributeName:progressViewLabel.font}];
    [progressViewLabel setFrame:CGRectMake(viewBounds.size.width - infoSize.width - 2, 64, infoSize.width, infoSize.height)];
    
    // 更改sumTask角标
    [_sumtaskDelegate updateSumTask:1];
    
    [self initData];
    [_tableView reloadData];
}









#pragma mark 自定义方法

// 响应按钮：关闭模态窗口
-(void)btnReturnin{
    // 170304 先将模态框改为navigationController形式
    //[self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

// 响应按钮：新增任务
-(void)btnnew{

    // 定义毛玻璃效果
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *effe = [[UIVisualEffectView alloc]initWithEffect:blur];
    effe.frame = viewBounds;
    
    // 转场动画
    CATransition *btnLoadNewView =[CATransition animation];
    [btnLoadNewView setDuration:0.5];
    [btnLoadNewView setType:kCATransitionReveal];
    [btnLoadNewView setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];// 逐渐变慢
    [[effe layer]addAnimation:btnLoadNewView forKey:@"btnLoadNewView_1"];
    
    // 编辑视图
    DailyView *dailyView;
    dailyView = [[DailyView alloc]initWithDelegate:self]; // 因为初始化前不能设置代理，所以不用init
    dailyView.frame = CGRectMake(0, 0, viewBounds.size.width, viewBounds.size.height * 7 / 8);
    [effe addSubview:dailyView];
    
    // 按钮视图
    UIView *bottomBtnView = [UIView new];
    [bottomBtnView setFrame:CGRectMake(0, viewBounds.size.height*7/8, viewBounds.size.width, viewBounds.size.height/8)];
    [bottomBtnView setBackgroundColor:kLightBGColor];
    // 保存按钮
    UIButton *_saveBtn = [UIButton buttonWithType:(UIButtonTypeRoundedRect)];
    [_saveBtn setFrame:CGRectMake(bottomBtnView.frame.size.width/16, bottomBtnView.frame.size.height/9, viewBounds.size.width/4, bottomBtnView.frame.size.height*7/9)];
    [_saveBtn setTitle:@"保存" forState:UIControlStateNormal];// 添加文字
    [_saveBtn setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];// 修改文字颜色
    [_saveBtn addTarget:dailyView action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
    [bottomBtnView addSubview:_saveBtn];
    // 保存为日常按钮
    UIButton *_saveDailyBtn = [UIButton buttonWithType:(UIButtonTypeRoundedRect)];
    [_saveDailyBtn setFrame:CGRectMake(bottomBtnView.frame.size.width*3/8, bottomBtnView.frame.size.height/9, viewBounds.size.width/4, bottomBtnView.frame.size.height*7/9)];
    [_saveDailyBtn setTitle:@"保存为日常" forState:UIControlStateNormal];
    [_saveDailyBtn setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];
    [_saveDailyBtn addTarget:dailyView action:@selector(saveDaily) forControlEvents:UIControlEventTouchUpInside];
    [bottomBtnView addSubview:_saveDailyBtn];
    // 取消按钮
    UIButton *_cancelBtn = [UIButton buttonWithType:(UIButtonTypeRoundedRect)];
    [_cancelBtn setFrame:CGRectMake(bottomBtnView.frame.size.width*11/16, bottomBtnView.frame.size.height/9, viewBounds.size.width/4, bottomBtnView.frame.size.height*7/9)];
    [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [_cancelBtn setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];
    [_cancelBtn addTarget:dailyView action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    [bottomBtnView addSubview:_cancelBtn];

    [effe addSubview:bottomBtnView];
    
    [self.view addSubview:effe];
}

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


@end
