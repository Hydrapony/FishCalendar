//
//  Constant.m
//  布局变量 初始化方法
//
//  Created by Hydra on 17/3/1.
//  Copyright © 2017年 Hydra. All rights reserved.
//

#import "Constant.h"

#import "Daily+CoreDataProperties.h"
#import "HomeworkType+CoreDataProperties.h"
#import "ClassName+CoreDataProperties.h"
#import "Iconimg+CoreDataProperties.h"

@implementation Constant

// 默认值伪iPhone7

int dayPerWeek = 5; // 每周上课天数（5/6）
int classInMorning = 0; // 晨间课程数（0-1）
int classInForenoon = 4; // 上午课程数（2-5）
int classInAfternoon = 3; // 下午课程数（2-4）
int classInNight = 0; // 晚间课程数（0-3）

CGRect viewBounds; // 屏幕大小
NSManagedObjectContext *dbcontext;// 数据库上下文
int kNavigationBarViewHigh; // 一般状态栏高
int kStatusBarHigh; // 系统状态栏高
int kCalendarxMargin; // 课程表View的边缝宽

CGRect kbtn1rect; // 导航栏最左按钮frame
CGRect kbtn2rect; // 导航栏次左按钮frame
CGRect kbtn3rect; // 导航栏次右按钮frame
CGRect kbtn4rect; // 导航栏最右按钮frame

// DailyTableViewCell / 一般Cell
int kTitleTextFontSize ; // 标题字号18' / textLabel字号
int kSecTitleTextFontSize; // 小标题字号13' / detailTextLabel字号
int kInfoTextFontSize; // 内容字号15' / 右侧自定义文字号

// DailyView
int kLabelTextFontSize; // 标题字号
int kLittleLabelTextFontSize; // 小字号
int kLeftX; // 左侧栏右端x坐标
int kRightX; // 右侧栏左端x坐标

// setting
int kcellFontsize = 16; // 字体设置中的字号

/* -------- setting内可以设置的参数 -------- */

bool isOrigin; // 第一次启动
    
NSMutableDictionary *ksettingsAll; // plist读取内容
NSString *kclassFontName; // 字体(名称)
NSString *kclassBgName; // 背景
NSString *kclassHeadType; // 表头展示方式
NSString *kRingBtnTime; // 环按钮延迟
NSString *kSlashTime; // 天的境界线
NSString *kDefaultHwType; // 默认展示课程类型
NSString *kProgressMM; // 进度条显示换算
NSString *kFontColorRGB; // 字体颜色
NSString *kLightFontColorRGB; // 字体高亮颜色
NSString *kFrameColorRGB; // 边框颜色

int kwcells; // 学时制（几天制）
bool kdoubleWeekSetel; // 复式课制
int khcellsMO; // 晨间课程数
int khcellsAM; // 上午课程数
int khcellsPM; // 下午课程数
int khcellsDN; // 晚间课程数
int kdefaultCanendarShow; // 课程表默认展示方式
int klongpressGes; // 长按事件
int knowClassShow; // 目前课程展示方式
int kdoneClassShow; // 完成课程展示方式






# pragma mark 自定义方法

// 获取setting.plist数据，用于返回时重设课程表
+ (void)getSetting{
    
    // 获取setting.plist文件 / 生成setting.plist文件
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *plistPath1 = [paths objectAtIndex:0];
    NSString *filePath=[plistPath1 stringByAppendingPathComponent:@"setting.plist"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:filePath isDirectory:false]) {
        // 初次使用，从Bundle中读出，写入NSDocumentDirectory指定路径
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"setting" ofType:@"plist"];
        NSMutableDictionary *settings = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
        [settings writeToFile:filePath atomically:YES];
    }
    
    // 获取setting.plist数据
    ksettingsAll = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
    isOrigin = [(NSString*)ksettingsAll[@"setting"][@"isorigin"] integerValue] > 0;
    
    kclassFontName = ksettingsAll[@"setting"][@"1"];
    kFontColorRGB = ksettingsAll[@"setting"][@"2"];
    kLightFontColorRGB = ksettingsAll[@"setting"][@"3"];
    kclassBgName = ksettingsAll[@"setting"][@"4"];
    kFrameColorRGB = ksettingsAll[@"setting"][@"5"];
    kclassHeadType = ksettingsAll[@"setting"][@"6"][@"0"];
    kRingBtnTime = ksettingsAll[@"setting"][@"7"][@"0"];
    kSlashTime = ksettingsAll[@"setting"][@"8"];
    kDefaultHwType = ksettingsAll[@"setting"][@"9"][@"0"];
    kProgressMM = ksettingsAll[@"setting"][@"10"][@"0"];
    
    kwcells = [ksettingsAll[@"calendar"][@"1_1"][@"0"] intValue] + 4;
    kdoubleWeekSetel = [ksettingsAll[@"calendar"][@"1_3"][@"0"]isEqualToString:@"2"];
    kdefaultCanendarShow = [ksettingsAll[@"calendar"][@"2_0"][@"0"] intValue];
    klongpressGes = [ksettingsAll[@"calendar"][@"2_1"][@"0"] intValue];
    knowClassShow = [ksettingsAll[@"calendar"][@"2_2"][@"0"] intValue];
    kdoneClassShow = [ksettingsAll[@"calendar"][@"2_3"][@"0"] intValue];
    
    NSDictionary *hcellsArr = ksettingsAll[@"classTime"];
    NSDictionary *hcellsArr4 = [NSDictionary new];
    hcellsArr4 = hcellsArr[@"0"];
    khcellsMO = (int)hcellsArr4.count;
    hcellsArr4 = hcellsArr[@"1"];
    khcellsAM = (int)hcellsArr4.count;
    hcellsArr4 = hcellsArr[@"2"];
    khcellsPM = (int)hcellsArr4.count;
    hcellsArr4 = hcellsArr[@"3"];
    khcellsDN = (int)hcellsArr4.count;
}

// 封装方法 用于保存plist数据
+ (void)saveplist:(NSMutableDictionary*)settings tofile:(NSString*)filename{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *plistPath1 = [paths objectAtIndex:0];
    NSString *plistPath=[plistPath1 stringByAppendingPathComponent:filename];
    [ksettingsAll writeToFile:plistPath atomically:YES];
}

// 创建数据库上下文
+ (NSManagedObjectContext *)createDbContext{
    NSManagedObjectContext *context;
    //打开模型文件，参数为nil则打开包中所有模型文件并合并成一个
    NSManagedObjectModel *model=[NSManagedObjectModel mergedModelFromBundles:nil];
    //创建解析器
    NSPersistentStoreCoordinator *storeCoordinator=[[NSPersistentStoreCoordinator alloc]initWithManagedObjectModel:model];
    //创建数据库保存路径
    NSString *dir=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSLog(@"Directory路径：%@",dir);
    NSString *path=[dir stringByAppendingPathComponent:@"myDatabase.db"];
    NSURL *url=[NSURL fileURLWithPath:path];
    //添加SQLite持久存储到解析器
    NSError *error;
    [storeCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:url options:nil error:&error];
    if(error){
        NSLog(@"数据库打开失败！错误:%@",error.localizedDescription);
    }else{
        // 创建管理对象上下方并指定存储
        context=[[NSManagedObjectContext alloc]initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        context.persistentStoreCoordinator=storeCoordinator;
        NSLog(@"数据库打开成功！");
    }
    return context;
}

// 移除存储器再重新添加
+ (NSManagedObjectContext *)updateDbContext:(NSManagedObjectContext *)dbcontext{
    NSString *dir=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *path=[dir stringByAppendingPathComponent:@"myDatabase.db"];
    NSURL *url=[NSURL fileURLWithPath:path];
    [dbcontext.persistentStoreCoordinator removePersistentStore:dbcontext.persistentStoreCoordinator.persistentStores[0] error:nil];
    [dbcontext.persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:url options:nil error:nil];
    return dbcontext;
}

// 源初的数据库数据生成
+ (void)initOriginData{
    NSDate *dateNow = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"CCD"]];
    formatter.dateFormat = @"yyyyMMdd";
    
    int daycutTime = [kSlashTime intValue];
    NSDate *tempDate = dateNow;
    NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [cal setTimeZone:[NSTimeZone timeZoneWithName:@"CCD"]];
    NSDateComponents *comps = [cal components:NSCalendarUnitHour fromDate:dateNow]; // 取数据（北京时间）
    if([comps hour] < daycutTime){
        tempDate = [[NSDate alloc] initWithTimeInterval:-60*60*24 sinceDate:dateNow];
    }
    NSString *dateNowStr = [formatter stringFromDate:tempDate];
    
    // 生成提示任务
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Daily"];
    NSArray *array = [dbcontext executeFetchRequest:request error:nil];
    if(array.count == 0){
        NSDictionary *csdailyDAa = @{@"name":@"第一项作业",
                                     @"info":@"此处是你今天预计完成的所有作业\n\n点击右上方按钮，在指定时间新建一项作业\n\n在新建作业时，可以将其设置为每日自动添加一次的日常作业\n\n长按右方按钮，完成你的第一项作业\n\n逾期未完成的作业将标示为褐色，其耗时不计入总进度\n\n右划屏幕回到课程表页面",
                                     @"imgname":@"shoucang.png",
                                     @"havedone":@1,
                                     @"enddate":dateNowStr,
                                     @"isvalid":@1};
        [Daily addWithDictionary:csdailyDAa withDbcx:dbcontext];
    }
    
    // 生成默认课程名
    request = [NSFetchRequest fetchRequestWithEntityName:@"ClassName"];
    array = [dbcontext executeFetchRequest:request error:nil];
    if(array.count == 0){
        HomeworkType *home1,*home2,*home3,*home4,*home5;
        
        home1 = [HomeworkType addWithDictionary:@{@"typename":@"语文试卷"} withDbcx:dbcontext];
        home2 = [HomeworkType addWithDictionary:@{@"typename":@"作业题"} withDbcx:dbcontext];
        home3 = [HomeworkType addWithDictionary:@{@"typename":@"整理语文笔记"} withDbcx:dbcontext];
        NSSet *homeworkSet = [[NSSet alloc] initWithObjects:home1,home2,home3, nil];
        [ClassName addWithDictionary:@{@"name":@"语文",@"homeworkname":@"语文作业",@"img":@"yuwen_d.png",@"havehomework":homeworkSet} withDbcx:dbcontext];
        
        home1 = [HomeworkType addWithDictionary:@{@"typename":@"数学试卷"} withDbcx:dbcontext];
        home2 = [HomeworkType addWithDictionary:@{@"typename":@"作业题"} withDbcx:dbcontext];
        home3 = [HomeworkType addWithDictionary:@{@"typename":@"整理数学笔记"} withDbcx:dbcontext];
        homeworkSet = [[NSSet alloc] initWithObjects:home1,home2,home3, nil];
        [ClassName addWithDictionary:@{@"name":@"数学",@"homeworkname":@"数学作业",@"img":@"shuxue_d.png",@"havehomework":homeworkSet} withDbcx:dbcontext];
        
        home1 = [HomeworkType addWithDictionary:@{@"typename":@"英语试卷"} withDbcx:dbcontext];
        home2 = [HomeworkType addWithDictionary:@{@"typename":@"作业题"} withDbcx:dbcontext];
        home3 = [HomeworkType addWithDictionary:@{@"typename":@"整理英语笔记"} withDbcx:dbcontext];
        home4 = [HomeworkType addWithDictionary:@{@"typename":@"背单词"} withDbcx:dbcontext];
        home5 = [HomeworkType addWithDictionary:@{@"typename":@"背课文"} withDbcx:dbcontext];
        homeworkSet = [[NSSet alloc] initWithObjects:home1,home2,home3,home4,home5, nil];
        [ClassName addWithDictionary:@{@"name":@"英语",@"homeworkname":@"英语作业",@"img":@"yingyu_d.png",@"havehomework":homeworkSet} withDbcx:dbcontext];
        
        home1 = [HomeworkType addWithDictionary:@{@"typename":@"物理试卷"} withDbcx:dbcontext];
        home2 = [HomeworkType addWithDictionary:@{@"typename":@"作业题"} withDbcx:dbcontext];
        home3 = [HomeworkType addWithDictionary:@{@"typename":@"整理物理笔记"} withDbcx:dbcontext];
        homeworkSet = [[NSSet alloc] initWithObjects:home1,home2,home3, nil];
        [ClassName addWithDictionary:@{@"name":@"物理",@"homeworkname":@"物理作业",@"img":@"wuli_d.png",@"havehomework":homeworkSet} withDbcx:dbcontext];
        
        home1 = [HomeworkType addWithDictionary:@{@"typename":@"化学试卷"} withDbcx:dbcontext];
        home2 = [HomeworkType addWithDictionary:@{@"typename":@"作业题"} withDbcx:dbcontext];
        home3 = [HomeworkType addWithDictionary:@{@"typename":@"整理化学笔记"} withDbcx:dbcontext];
        homeworkSet = [[NSSet alloc] initWithObjects:home1,home2,home3, nil];
        [ClassName addWithDictionary:@{@"name":@"化学",@"homeworkname":@"化学作业",@"img":@"huaxue_d.png",@"havehomework":homeworkSet} withDbcx:dbcontext];
        
        home1 = [HomeworkType addWithDictionary:@{@"typename":@"生物试卷"} withDbcx:dbcontext];
        home2 = [HomeworkType addWithDictionary:@{@"typename":@"作业题"} withDbcx:dbcontext];
        home3 = [HomeworkType addWithDictionary:@{@"typename":@"整理生物笔记"} withDbcx:dbcontext];
        homeworkSet = [[NSSet alloc] initWithObjects:home1,home2,home3, nil];
        [ClassName addWithDictionary:@{@"name":@"生物",@"homeworkname":@"生物作业",@"img":@"shengwu_d.png",@"havehomework":homeworkSet} withDbcx:dbcontext];
        
        home1 = [HomeworkType addWithDictionary:@{@"typename":@"历史试卷"} withDbcx:dbcontext];
        home2 = [HomeworkType addWithDictionary:@{@"typename":@"作业题"} withDbcx:dbcontext];
        home3 = [HomeworkType addWithDictionary:@{@"typename":@"整理历史笔记"} withDbcx:dbcontext];
        homeworkSet = [[NSSet alloc] initWithObjects:home1,home2,home3, nil];
        [ClassName addWithDictionary:@{@"name":@"历史",@"homeworkname":@"历史作业",@"img":@"lishi_d.png",@"havehomework":homeworkSet} withDbcx:dbcontext];
        
        home1 = [HomeworkType addWithDictionary:@{@"typename":@"地理试卷"} withDbcx:dbcontext];
        home2 = [HomeworkType addWithDictionary:@{@"typename":@"作业题"} withDbcx:dbcontext];
        home3 = [HomeworkType addWithDictionary:@{@"typename":@"整理地理笔记"} withDbcx:dbcontext];
        homeworkSet = [[NSSet alloc] initWithObjects:home1,home2,home3, nil];
        [ClassName addWithDictionary:@{@"name":@"地理",@"homeworkname":@"地理作业",@"img":@"dili_d.png",@"havehomework":homeworkSet} withDbcx:dbcontext];
        
        home1 = [HomeworkType addWithDictionary:@{@"typename":@"政治试卷"} withDbcx:dbcontext];
        home2 = [HomeworkType addWithDictionary:@{@"typename":@"作业题"} withDbcx:dbcontext];
        home3 = [HomeworkType addWithDictionary:@{@"typename":@"整理政治笔记"} withDbcx:dbcontext];
        homeworkSet = [[NSSet alloc] initWithObjects:home1,home2,home3, nil];
        [ClassName addWithDictionary:@{@"name":@"政治",@"homeworkname":@"政治作业",@"img":@"zhengzhi_d.png",@"havehomework":homeworkSet} withDbcx:dbcontext];
        
        home1 = [HomeworkType addWithDictionary:@{@"typename":@"乐器准备"} withDbcx:dbcontext];
        home2 = [HomeworkType addWithDictionary:@{@"typename":@"练习"} withDbcx:dbcontext];
        homeworkSet = [[NSSet alloc] initWithObjects:home1,home2, nil];
        [ClassName addWithDictionary:@{@"name":@"音乐",@"homeworkname":@"音乐作业",@"img":@"yinyue_d.png",@"havehomework":homeworkSet} withDbcx:dbcontext];
        
        home1 = [HomeworkType addWithDictionary:@{@"typename":@"美术用具准备"} withDbcx:dbcontext];
        home2 = [HomeworkType addWithDictionary:@{@"typename":@"练习"} withDbcx:dbcontext];
        homeworkSet = [[NSSet alloc] initWithObjects:home1,home2, nil];
        [ClassName addWithDictionary:@{@"name":@"美术",@"homeworkname":@"美术作业",@"img":@"meishu_d.png",@"havehomework":homeworkSet} withDbcx:dbcontext];
        
        home1 = [HomeworkType addWithDictionary:@{@"typename":@"器械准备"} withDbcx:dbcontext];
        home2 = [HomeworkType addWithDictionary:@{@"typename":@"练习"} withDbcx:dbcontext];
        homeworkSet = [[NSSet alloc] initWithObjects:home1,home2, nil];
        [ClassName addWithDictionary:@{@"name":@"体育",@"homeworkname":@"体育作业",@"img":@"tiyu_d.png",@"havehomework":homeworkSet} withDbcx:dbcontext];
        
        [ClassName addWithDictionary:@{@"name":@"计算机",@"homeworkname":@"计算机作业",@"img":@"jisuanji_d.png"} withDbcx:dbcontext];
        
        [ClassName addWithDictionary:@{@"name":@"健康教育",@"homeworkname":@"健康教育作业",@"img":@"jiankangjiaoyu_d.png"} withDbcx:dbcontext];
        
        home1 = [HomeworkType addWithDictionary:@{@"typename":@"论文"} withDbcx:dbcontext];
        [ClassName addWithDictionary:@{@"name":@"社会实践",@"homeworkname":@"社会实践作业",@"img":@"shehuishijian_d.png"} withDbcx:dbcontext];
        
        [ClassName addWithDictionary:@{@"name":@"自习",@"homeworkname":@"自习课作业",@"img":@"zixi_d.png"} withDbcx:dbcontext];
    }
    
    // 生成标示图名
    request = [NSFetchRequest fetchRequestWithEntityName:@"Iconimg"];
    array = [dbcontext executeFetchRequest:request error:nil];
    if(array.count == 0){
        NSArray *iconImgArray = [NSArray arrayWithObjects:
                                 @"yuwen_d.png",
                                 @"yuwen.png",
                                 @"shuxue_d.png",
                                 @"yingyu_d.png",
                                 
                                 @"wuli_d.png",
                                 @"huaxue_d.png",
                                 @"shengwu_d.png",
                                 @"shengwu.png",
                                 @"lishi_d.png",
                                 @"dili_d.png",
                                 @"zhengzhi_d.png",
                                 
                                 @"yinyue_d.png",
                                 @"meishu_d.png",
                                 @"tiyu_d.png",
                                 @"tiyu.png",
                                 @"tiyu2.png",
                                 @"jisuanji_d.png",
                                 @"jiankangjiaoyu_d.png",
                                 @"shehuishijian_d.png",
                                 @"zixi_d.png",
                                 
                                 @"gouwu.png",
                                 @"yuedu.png",
                                 @"laodongjishu.png",
                                 @"sheying.png",
                                 @"ziran.png",
                                 @"rest.png",
                                 @"qian.png",
                                 @"shoucang.png",
                                 nil];
        NSArray *iconImgTrArray = [iconImgArray sortedArrayUsingSelector:@selector(compare:)];
        int arrayCount = (int)iconImgTrArray.count;
        for (int i = 0; i < arrayCount; ++i) {
            [Iconimg addWithDictionary:@{@"imgname":iconImgTrArray[i]} withDbcx:dbcontext];
        }
    }
    // 设置初次启动标识
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *plistPath1 = [paths objectAtIndex:0];
    NSString *filePath=[plistPath1 stringByAppendingPathComponent:@"setting.plist"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:filePath isDirectory:false]) {
        ksettingsAll[@"setting"][@"isorigin"] = @"1";
        [self saveplist:ksettingsAll tofile:@"setting.plist"];
    }
}

// 一个数据保存错误弹框
+ (void)alertError:(UIViewController *)viewCtrl{
    UIAlertController *alertview=[UIAlertController alertControllerWithTitle:@"提示" message:@"数据保存出现错误，请重试" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *defult = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alertview addAction:defult];
    [viewCtrl presentViewController:alertview animated:YES completion:nil];
}

@end
