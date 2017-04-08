//
//  RootViewController.m
//  根视图（课程表和按钮）
//
//  Created by Hydra on 17/2/9.
//  Copyright © 2017年 Hydra. All rights reserved.
//

#import "RootViewController.h"

#import <objc/runtime.h>

#define kLightBGColor [UIColor colorWithRed:38/255.0 green:50/255.0 blue:56/255.0 alpha:1] // 浅色背景
#define kDarkBGColor [UIColor colorWithRed:23/255.0 green:23/255.0 blue:23/255.0 alpha:1]// 深色背景
#define kDarkCellColor [UIColor colorWithRed:38/255.0 green:38/255.0 blue:38/255.0 alpha:1]// 深色列背景
#define kLightTextColor [UIColor colorWithRed:221/255.0 green:221/255.0 blue:221/255.0 alpha:1]// 浅色列字体

@interface RootViewController ()
@end

@implementation RootViewController

#pragma mark 初始化

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
    // 添加日常任务
    [self addDailyLong];
    // 绘制课程表
    [self drawCalendar];
    // 下部按钮
    [self updateSumTask];
    [self addBtns];
}

// 状态栏改为亮色样式
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}








#pragma mark CalendarDataSource课程表类数据源方法

// 调整课程表大小
-(void)changeCalFrame:(UIView*)calview{
    [calview setFrame:CGRectMake(kCalendarxMargin, 34, viewBounds.size.width - kCalendarxMargin*2, viewBounds.size.height*5/7)];
}

// 获取课程表数据
-(NSMutableDictionary*)getCalendarData{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *plistPath1 = [paths objectAtIndex:0];
    NSString *filePath=[plistPath1 stringByAppendingPathComponent:@"classInCale.plist"];
    NSMutableDictionary *pdata = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:filePath isDirectory:false]) {
        // 初次使用，从Bundle中读出，写入NSDocumentDirectory指定路径
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"classInCale" ofType:@"plist"];
        pdata = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
        [pdata writeToFile:filePath atomically:YES];
    }
    return pdata;
}

// 新增任务 via DailyTableViewCell 用于课程表长按课程增加作业
-(void)addHwByCalendarData:(NSString*)classname{
    // 定义毛玻璃效果
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *effe = [[UIVisualEffectView alloc]initWithEffect:blur];
    effe.frame = viewBounds;
    
    // 转场动画
    CATransition *btnLoadNewView =[CATransition animation];
    [btnLoadNewView setDuration:0.5];
    [btnLoadNewView setType:kCATransitionReveal];
    [btnLoadNewView setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];// 逐渐变慢
    [[effe layer]addAnimation:btnLoadNewView forKey:@"btnLoadNewView_C"];
    
    // 编辑视图
    DailyCView *dailyView;
    dailyView = [[DailyCView alloc]initWithDelegate:self andClassName:classname]; // 因为初始化前不能设置代理，所以不用init
    dailyView.frame = CGRectMake(0, 0, viewBounds.size.width, viewBounds.size.height * 7 / 8);
    [effe addSubview:dailyView];
    
    // 按钮视图
    UIView *bottomBtnView = [UIView new];
    [bottomBtnView setFrame:CGRectMake(0, viewBounds.size.height*7/8, viewBounds.size.width, viewBounds.size.height/8)];
    [bottomBtnView setBackgroundColor:kLightBGColor];
    // 保存按钮
    UIButton *_saveBtn = [UIButton buttonWithType:(UIButtonTypeRoundedRect)];
    [_saveBtn setFrame:CGRectMake(bottomBtnView.frame.size.width/13, bottomBtnView.frame.size.height/9, viewBounds.size.width*3/13, bottomBtnView.frame.size.height*7/9)];
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
    [_cancelBtn setFrame:CGRectMake(bottomBtnView.frame.size.width*9/13, bottomBtnView.frame.size.height/9, viewBounds.size.width*3/13, bottomBtnView.frame.size.height*7/9)];
    [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [_cancelBtn setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];
    [_cancelBtn addTarget:dailyView action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    [bottomBtnView addSubview:_cancelBtn];
    
    [effe addSubview:bottomBtnView];
    
    [self.view addSubview:effe];
}








#pragma mark DailyCViewDelegate代理方法

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

#pragma mark UpdateSumTaskDelegate代理方法
    
// 更新角标+-1
-(void)updateSumTask:(int)num{
    sumTask += num;
    [UIApplication sharedApplication].applicationIconBadgeNumber = sumTask;
    badgeView.badgeText = [NSString stringWithFormat:@"%i",sumTask];
    if (sumTask == 0) {
        [badgeView setHidden:YES];
    }else{
        [badgeView setHidden:NO];
    }
}












#pragma mark 自定义方法

// 添加每日日常任务
- (void)addDailyLong{
    // 取“下一天（recentdate）”位于当日6:00~明日6:00 所有日常任务(由kSlashTime决定)
    // 参考DailyTableViewController的initData方法
    // 例如今天2月5日，取属于2月5日6点-2月6日6点段的，也即recentdate = “2月6日0点”的
    int daycutTime = [kSlashTime intValue];
    NSDate *nowDate = [NSDate date];
    NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian]; // UTC时间
    [cal setTimeZone:[NSTimeZone timeZoneWithName:@"CCD"]];
    NSDateComponents *comps = [cal components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour fromDate:nowDate]; // 取数据（北京时间）
    if([comps hour] < daycutTime){
        nowDate = [[NSDate alloc] initWithTimeInterval:-3600*24 sinceDate:nowDate];
    }
    NSDate *nextDate = [[NSDate alloc] initWithTimeInterval:3600*24 sinceDate:nowDate];
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
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"DailyLong"];
    // 0330 改为超期没生成的每日任务，只在登录时生成一次，不再补之前的
    //request.predicate=[NSPredicate predicateWithFormat:@"recentdate >= %@ AND recentdate <= %@",nowDate_6am,nextDate_6am];
    request.predicate=[NSPredicate predicateWithFormat:@"recentdate <= %@",nextDate_6am];
    NSArray *array = [dbcontext executeFetchRequest:request error:nil];
    
    for (DailyLong* dailylong in array) {
        dailylong.recentdate = nowDate_6am;
        [Daily addWithDailyLong:dailylong withDbcx:dbcontext];
        //[DailyLong pushRecentdateIn:dailylong WithDbcx:dbcontext];
        [DailyLong pushRecentdateIn:dailylong WithDbcx:dbcontext toDate:nextDate_6am];
    }
}

// 移除课程表面板
- (void)removeAllCtrls{
    NSArray *allViews = [self.view subviews];
    for (UIView* view in allViews) {
        [view removeFromSuperview];
    }
    [badgeView removeFromSuperview];
}

// 绘制课程表
- (void)drawCalendar{
    // 设置背景图片
    bgImgView = [[UIImageView alloc]initWithFrame:viewBounds];
    if([kclassBgName isEqualToString:@"黑色木纹"]){
        bgImgView.image = [UIImage imageNamed:@"blackwood_bg.jpg"];
    }else if([kclassBgName isEqualToString:@"黑色花纹"]){
        bgImgView.image = [UIImage imageNamed:@"blackss_bg.jpg"];
    }else{
        // 其他自定义背景图
        NSURL *url=[NSURL URLWithString:kclassBgName];
        NSData *imageData=[NSData dataWithContentsOfURL:url];
        UIImage *image=[UIImage imageWithData:imageData];
        bgImgView.image =image;
        ALAssetsLibrary *lib = [[ALAssetsLibrary alloc] init];
        [lib assetForURL:[NSURL URLWithString:kclassBgName] resultBlock:^(ALAsset *asset){
            ALAssetRepresentation *assetRep = [asset defaultRepresentation];
            CGImageRef imgRef = [assetRep fullResolutionImage];
            UIImage *img = [UIImage imageWithCGImage:imgRef scale:assetRep.scale orientation:(UIImageOrientation)assetRep.orientation];
            bgImgView.image = img;
        }
            failureBlock:^(NSError *error){
            }
        ];
    }
    [self.view addSubview:bgImgView];
    
    showtype = kdefaultCanendarShow == 1; // 是否显示一周课程

    calendar = [[MainCalendarView alloc]initWithDateSource:self];
    [calendar setFrame:CGRectMake(kCalendarxMargin, kCalendarxMargin + 10, viewBounds.size.width - kCalendarxMargin*2, viewBounds.size.height*6/7)];
    calendar.backgroundColor = [UIColor colorWithRed:18/255.0 green:18/255.0 blue:18/255.0 alpha:0.7];
    calendar.layer.borderWidth = 1;
    NSArray *array = [kFrameColorRGB componentsSeparatedByString:@"+"];
    calendar.layer.borderColor = [[UIColor colorWithRed:[array[0] doubleValue] / 255.0f green:[array[1] doubleValue] / 255.0f blue:[array[2] doubleValue] / 255.0f alpha:1] CGColor];
    calendar.tag = 11;
    if(!showtype){[calendar setHidden:YES];}
    [self.view addSubview:calendar];
    
    scalendar = [[SingleCalendarView alloc]initWithMainView:calendar];
    scalendar.backgroundColor = [UIColor colorWithRed:18/255.0 green:18/255.0 blue:18/255.0 alpha:0.7];
    scalendar.layer.borderWidth = 1;
    scalendar.layer.borderColor = [[UIColor colorWithRed:[array[0] doubleValue] / 255.0f green:[array[1] doubleValue] / 255.0f blue:[array[2] doubleValue] / 255.0f alpha:1] CGColor];
    scalendar.tag = 12;
    if(showtype){[scalendar setHidden:YES];}
    [self.view addSubview:scalendar];
}


// 下部按钮
-(void)addBtns{
    double btnsY = viewBounds.size.height*6/7 + 34;
    double btnsWH = (viewBounds.size.height/7 - 34)*3/5;
    
    // 交换显示形式按钮
    exchangeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [exchangeBtn setFrame:CGRectMake(viewBounds.size.width/5 - btnsWH/2,btnsY + btnsWH/3,btnsWH,btnsWH)];
    [exchangeBtn setImage:[UIImage imageNamed:@"showB.png"]forState:UIControlStateNormal];
    [exchangeBtn addTarget:self action:@selector(exchangeShowType) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:exchangeBtn];
    
    // 日常页入口按钮
    dailyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [dailyBtn setFrame:CGRectMake(viewBounds.size.width/2 - btnsWH/2,btnsY + btnsWH/3,btnsWH,btnsWH)];
    [dailyBtn setImage:[UIImage imageNamed:@"timetable.png"]forState:UIControlStateNormal];
    [dailyBtn addTarget:self action:@selector(toDaily) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:dailyBtn];
    badgeView = [[JSBadgeView alloc]initWithParentView:dailyBtn alignment:JSBadgeViewAlignmentTopRight];
    badgeView.badgeText = [NSString stringWithFormat:@"%i",sumTask];
    if (sumTask == 0) {
        [badgeView setHidden:YES];
    }else{
        [badgeView setHidden:NO];
    }
    
    // 设置页入口按钮
    settingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [settingBtn setFrame:CGRectMake(viewBounds.size.width*4/5 - btnsWH/2,btnsY + btnsWH/3,btnsWH,btnsWH)];
    [settingBtn setImage:[UIImage imageNamed:@"settings3.png"]forState:UIControlStateNormal];
    [settingBtn addTarget:self action:@selector(toSetting) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:settingBtn];
}

// 交换显示形式
- (void)exchangeShowType{
    showtype = !showtype;
    if(showtype){
        [[self.view viewWithTag:11] setHidden:NO];
        [[self.view viewWithTag:12] setHidden:YES];
    }else{
        [[self.view viewWithTag:11] setHidden:YES];
        [[self.view viewWithTag:12] setHidden:NO];
    }
}

// 日常页入口响应方法
- (DailyTableViewController*)toDaily{
    DailyTableViewController *dailycontroller = [[DailyTableViewController alloc]init];
    dailycontroller.sumtaskDelegate = self;
    // 170304 先将模态框改为navigationController形式
    //[dailycontroller setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    //[self presentViewController:dailycontroller animated:YES completion:nil];
    [self.navigationController pushViewController:dailycontroller animated:YES];
    return dailycontroller;
}

- (DailyTableViewController*)toDailyView{
    DailyTableViewController *dailycontroller = [[DailyTableViewController alloc]init];
    //[dailycontroller.view setHidden:YES];
    [self.navigationController pushViewController:dailycontroller animated:NO];
    return dailycontroller;
}

// 角标设置为1
-(void)updateSumTaskto1{
    sumTask = 1;
    [UIApplication sharedApplication].applicationIconBadgeNumber = sumTask;
    badgeView.badgeText = [NSString stringWithFormat:@"%i",sumTask];
    [badgeView setHidden:NO];
}

// 角标更新到正常
-(void)updateSumTask{
    NSDate *slDate = [NSDate date];
    // Daily实体只存储年月日，enddate都是0点，如2016-01-25 12:00，取所有enddate < 2016-01-25 6:00前的数据
    // 但凌晨时，如2016-01-25 1:00，需要取的是enddate < 2016-01-24 6:00前的数据，因为分割点前还是上一天
    int daycutTime = [kSlashTime intValue];
    // 获取需要取的时间
    NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian]; // UTC时间
    [cal setTimeZone:[NSTimeZone timeZoneWithName:@"CCD"]];
    NSDateComponents *comps = [cal components:NSCalendarUnitHour fromDate:slDate]; // 取数据（北京时间）
    if([comps hour] < daycutTime){
        slDate = [[NSDate alloc] initWithTimeInterval:-60*60*24 sinceDate:slDate];
    }
    // 取年月日
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"CCD"]];
    df.dateFormat = @"yyyy/MM/dd";
    // 时分秒改为中午12点
    NSString *dateStr = [df stringFromDate:slDate];
    dateStr = [dateStr stringByAppendingString:@" 12:00:00"];
    df.dateFormat = @"yyyy/MM/dd HH:mm:ss";
    slDate = [df dateFromString: dateStr];
    // 查询
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Daily"];
    request.predicate=[NSPredicate predicateWithFormat:@"isvalid = true AND enddate <= %@",slDate];
    NSArray *array = [dbcontext executeFetchRequest:request error:nil];
    sumTask = (int)array.count;
    badgeView.badgeText = [NSString stringWithFormat:@"%i",sumTask];
    if (sumTask == 0) {
        [badgeView setHidden:YES];
    }else{
        [badgeView setHidden:NO];
    }
    if ([[UIApplication sharedApplication]currentUserNotificationSettings].types!=UIUserNotificationTypeNone) {
        [UIApplication sharedApplication].applicationIconBadgeNumber = sumTask; // 总任务数量角标
    }else{
        [[UIApplication sharedApplication]registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
    }
}

// 设置页入口按钮响应方法
-(void)toSetting{
    SettingViewController *settingcontroller = [[SettingViewController alloc]init];
    [self.navigationController pushViewController:settingcontroller animated:YES];
}





@end
