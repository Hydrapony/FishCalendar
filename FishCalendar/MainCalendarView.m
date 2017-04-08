//
//  MainCalendarView.m
//  课程表
//
//  Created by Hydra on 17/3/5.
//  Copyright © 2017年 Hydra. All rights reserved.
//

#import "MainCalendarView.h"

@implementation MainCalendarView

// 初始化
- (instancetype)initWithDateSource:(id<CalendarDataSource>)dataSource
{
    self = [super init];
    if (self) {
        _calendarDataSource = dataSource;
        [self initViewData];
    }
    return self;
}

// 数据初始化
- (void)initViewData{
    
    sevenWeekDayNames = @[@"一",@"二",@"三",@"四",@"五",@"六",@"日"];
    sevenWeekDayEngNames = @[@"Mon",@"Tues",@"Wed",@"Thur",@"Fri",@"Sat",@"Sun"];
    sevenWeekDayImgNames = @[@"Monday.png",@"Tuesday.png",@"Wednesday.png",@"Thursday.png",@"Friday.png",@"Saturday.png",@"Sunday.png"];
    
    // 时间获取
    NSDate *_dateNow = [NSDate date];
    NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [cal setTimeZone:[NSTimeZone timeZoneWithName:@"CCD"]];
    NSDateComponents *_dateNowComps = [cal components: NSCalendarUnitWeekOfYear | NSCalendarUnitWeekday | NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:_dateNow];
    weekNow = 0;
    if (kdoubleWeekSetel) {
        // 计算实际weekOfYear，开头的周日调整为周一
        int weekOfYear = (int)_dateNowComps.weekOfYear;
        if(_dateNowComps.weekday == 1){
            ++weekOfYear;
        }
        if(weekOfYear % 2 == 0){
            weekNow = 1;
        }
    }
    
    // 获取课程管理定义的时间
    nowClassOrder[0] = 0; // 周0-6
    nowClassOrder[1] = 0; // 时段0-3
    nowClassOrder[2] = 0; // 第几堂0-5
    nowClassOrder[3] = 2; // 现在与课程时间的前后位置0前1中2后
    NSUInteger datenowStrInt = _dateNowComps.hour * 100 + _dateNowComps.minute;
    nowClassOrder[0] = ((int)_dateNowComps.weekday + 5)%7;
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *plistPath1 = [paths objectAtIndex:0];
    NSString *plistPath=[plistPath1 stringByAppendingPathComponent:@"setting.plist"];
    _classInCaleAll = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath][@"classTime"];
    for (NSString *numstr in @[@"0",@"1",@"2",@"3"]) {
        NSDictionary *adic = _classInCaleAll[numstr];
        nowClassOrder[1] = [numstr intValue];
        for (int i = 0; i < adic.count; ++i) {
            nowClassOrder[2] = i;
            NSArray *array = [adic[[NSString stringWithFormat:@"%i",i]] componentsSeparatedByString:@"-"];
            NSString *beginDateStr = [array[0] stringByReplacingOccurrencesOfString:@":" withString:@""];
            NSString *endDateStr = [array[1] stringByReplacingOccurrencesOfString:@":" withString:@""];
            if (datenowStrInt < beginDateStr.integerValue){
                nowClassOrder[3] = 0;
                break;
            }else if (beginDateStr.integerValue <= datenowStrInt && datenowStrInt <= endDateStr.integerValue) {
                nowClassOrder[3] = 1;
                break;
            }else{
                nowClassOrder[3] = 2;
            }
        }
        if (nowClassOrder[3] < 2) {
            break;
        }
    }
    
    // 加载课程数据
    NSDictionary *classAll = [_calendarDataSource getCalendarData];
    NSMutableDictionary *classd = classAll[[NSString stringWithFormat:@"%i",weekNow]];
    // 取课程数据，分装为每天的array
    switch (classd.count) {
        case 5:
            _classes = [NSArray arrayWithObjects:classd[@"1"],classd[@"2"],classd[@"3"],classd[@"4"],classd[@"5"],nil];
            break;
        case 6:
            _classes = [NSArray arrayWithObjects:classd[@"1"],classd[@"2"],classd[@"3"],classd[@"4"],classd[@"5"],classd[@"6"],nil];
            break;
        case 7:
            _classes = [NSArray arrayWithObjects:classd[@"1"],classd[@"2"],classd[@"3"],classd[@"4"],classd[@"5"],classd[@"6"],classd[@"7"],nil];
            break;
        default:
            _classes = [NSArray arrayWithObjects:classd[@"1"],classd[@"2"],classd[@"3"],classd[@"4"],classd[@"5"],nil];
            break;
    }
    
    // 设置字体和高亮颜色
    NSArray *array = [kFontColorRGB componentsSeparatedByString:@"+"];
    kFontColor = [UIColor colorWithRed:[array[0] doubleValue] / 255.0f green:[array[1] doubleValue] / 255.0f blue:[array[2] doubleValue] / 255.0f alpha:1];
    array = [kLightFontColorRGB componentsSeparatedByString:@"+"];
    kLightFontColor = [UIColor colorWithRed:[array[0] doubleValue] / 255.0f green:[array[1] doubleValue] / 255.0f blue:[array[2] doubleValue] / 255.0f alpha:knowClassShow==4?0.4:1];
    array = [kFrameColorRGB componentsSeparatedByString:@"+"];
    kFrameColor = [UIColor colorWithRed:[array[0] doubleValue] / 255.0f green:[array[1] doubleValue] / 255.0f blue:[array[2] doubleValue] / 255.0f alpha:1];
    
    _fontsize = 16;
    
    [self setNeedsDisplay];
}

// 绘图
- (void)drawRect:(CGRect)rect {
    CGContextRef context=UIGraphicsGetCurrentContext();
    // 绘制课程表
    NSArray *array = [kFrameColorRGB componentsSeparatedByString:@"+"];
    CGContextSetLineWidth(context, 1);  //线宽
    CGContextSetRGBStrokeColor(context, [array[0] doubleValue] / 255.0f, [array[1] doubleValue] / 255.0f, [array[2] doubleValue] / 255.0f, 1);//设置笔触颜色, TODO 默认0.5, 0.5, 0.5
    CGContextSetLineJoin(context, kCGLineJoinRound);//设置连接点样式，(20,100)是连接点
    
    int wcells = kwcells; // 课制，即列数
    int hcellsMO = khcellsMO;
    int hcellsAM = khcellsAM;
    int hcellsPM = khcellsPM;
    int hcellsDN = khcellsDN;
    
    double allh = 0; // 总高度有几份
    allh += 3;
    allh += (hcellsMO + hcellsAM + hcellsPM + hcellsDN)*3 + 1;
    if(hcellsMO > 0){allh += 1;};
    if(hcellsDN > 0){allh += 1;};
    
    double cellh = rect.size.height/allh; // 每份高度，cell：3；间隔：1；表头：2
    double cellw = rect.size.width/wcells; // 每份宽度，cell：1

    CGSize infoSize=[@"字体测试" sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:kclassFontName size:_fontsize]}];
    double cellh_t = cellh; // 每份高度，UILabel用，因为画布用的cellh是按自己View比例绘画的
    // 格子太扁的情况
    while (cellh * 3 <= infoSize.height * 2) {
        infoSize=[@"字体测试" sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:kclassFontName size:--_fontsize]}];
    }
    // 格子太高的情况
    if(cellh - 2 > infoSize.height){
        [_calendarDataSource changeCalFrame:self]; // 调整课程表View的frame
        cellh_t = cellh * 5 / 6;
    };
    
    int nowh = 0; // 记录绘制到的高度
    int i = 0; // 绘图循环变量
    int j = 0; // 绘制文字循环变量
    int ck = 0; // 记录当前数组下标
    NSMutableArray *classj = [NSMutableArray new];
    
    // 绘制课程表表头
    CGPoint zongWeek[18];
    for (i = 1; i < wcells; ++i) {
        zongWeek[ck++] = CGPointMake(cellw * i, 0);
        zongWeek[ck++] = CGPointMake(cellw * i, cellh*2.5);
    };
    
    for(j = 0;j < wcells;++j){
        [self addTableTop:(j) inRect:CGRectMake(cellw*j + 1, 1, cellw-2, cellh_t*2.5-1)];
    }
    zongWeek[ck++] = CGPointMake(0, cellh*2.5);
    zongWeek[ck++] = CGPointMake(rect.size.width, cellh*2.5);
    zongWeek[ck++] = CGPointMake(0, cellh*3);
    zongWeek[ck++] = CGPointMake(rect.size.width, cellh*3);
    
    CGContextStrokeLineSegments(context, zongWeek, ck);
    nowh = 3;
    
    // 绘制晨间课程表
    if(hcellsMO > 0){
        CGPoint zongMO[16];
        for (i = 1,ck = 0; i < wcells; ++i) {
            zongMO[ck++] = CGPointMake(cellw * i, cellh*nowh);
            zongMO[ck++] = CGPointMake(cellw * i, cellh*(nowh + 3*hcellsMO));
        }
        for (i = 0; i < hcellsMO; ++i) {
            zongMO[ck++] = CGPointMake(0, cellh*(nowh + 3*(i+1)));
            zongMO[ck++] = CGPointMake(rect.size.width, cellh*(nowh + 3*(i+1)));
            for(j = 0;j < wcells;++j){
                classj = _classes[j];
                [self addText:classj[i] inRect:CGRectMake(cellw*j + 1, cellh_t*(nowh + 3*i) + 1, cellw-2, cellh_t*3-2) forWeekday:j inOrder:0 inRow:i];
            }
        }
        zongMO[ck++] = CGPointMake(0, cellh*(nowh + 3*i + 1));
        zongMO[ck++] = CGPointMake(rect.size.width, cellh*(nowh + 3*i + 1));
        CGContextStrokeLineSegments(context, zongMO, ck);
        nowh += 3*i + 1;
    }
    
    // 绘制上午课程表
    CGPoint zongAM[24];
    for (i = 1,ck = 0; i < wcells; ++i) {
        zongAM[ck++] = CGPointMake(cellw * i, cellh*nowh);
        zongAM[ck++] = CGPointMake(cellw * i, cellh*(nowh + 3*hcellsAM));
    }
    for (i = 0; i < hcellsAM; ++i) {
        zongAM[ck++] = CGPointMake(0, cellh*(nowh + 3*(i+1)));
        zongAM[ck++] = CGPointMake(rect.size.width, cellh*(nowh + 3*(i+1)));
        for(j = 0;j < wcells;++j){
            classj = _classes[j];
            [self addText:classj[2 + i] inRect:CGRectMake(cellw*j + 1, cellh_t*(nowh + 3*i) + 1, cellw - 2, cellh_t*3 - 2) forWeekday:j inOrder:1 inRow:i];
        }
    }
    zongAM[ck++] = CGPointMake(0, cellh*(nowh + 3*i + 1));
    zongAM[ck++] = CGPointMake(rect.size.width, cellh*(nowh + 3*i + 1));
    CGContextStrokeLineSegments(context, zongAM, ck);
    nowh += 3*i + 1;
    
    // 绘制下午课程表
    CGPoint zongPM[22];
    for (i = 1,ck = 0; i < wcells; ++i) {
        zongPM[ck++] = CGPointMake(cellw * i, cellh*nowh);
        zongPM[ck++] = CGPointMake(cellw * i, cellh*(nowh + 3*hcellsPM));
    }
    for (i = 0; i < hcellsPM; ++i) {
        zongPM[ck++] = CGPointMake(0, cellh*(nowh + 3*(i+1)));
        zongPM[ck++] = CGPointMake(rect.size.width, cellh*(nowh + 3*(i+1)));
        for(j = 0;j < wcells;++j){
            classj = _classes[j];
            [self addText:classj[8 + i] inRect:CGRectMake(cellw*j + 1, cellh_t*(nowh + 3*i) + 1, cellw-2, cellh_t*3-2) forWeekday:j inOrder:2 inRow:i];
        }
    }
    if(hcellsDN > 0){
        zongPM[ck++] = CGPointMake(0, cellh*(nowh + 3*i + 1));
        zongPM[ck++] = CGPointMake(rect.size.width, cellh*(nowh + 3*i + 1));
        nowh += 3*i + 1;
    }
    CGContextStrokeLineSegments(context, zongPM, ck);
    
    // 绘制晚间课程表
    if(hcellsDN > 0){
        CGPoint zongDN[18];
        for (i = 1,ck = 0; i < wcells; ++i) {
            zongDN[ck++] = CGPointMake(cellw * i, cellh*nowh);
            zongDN[ck++] = CGPointMake(cellw * i, cellh*(nowh + 3*hcellsDN));
        }
        for (i = 0; i < hcellsDN; ++i) {
            zongDN[ck++] = CGPointMake(0, cellh*(nowh + 3*(i+1)));
            zongDN[ck++] = CGPointMake(rect.size.width, cellh*(nowh + 3*(i+1)));
            for(j = 0;j < wcells;++j){
                classj = _classes[j];
                [self addText:classj[13 + i] inRect:CGRectMake(cellw*j + 1, cellh_t*(nowh + 3*i) + 1, cellw -2, cellh_t*3 - 2) forWeekday:j inOrder:3 inRow:i];
            }
        }
        CGContextStrokeLineSegments(context, zongDN, ck);
    }
 
    CGContextDrawPath(context, kCGPathFillStroke); //绘制
    
}


// 添加表头
-(void)addTableTop:(int)weekday inRect:(CGRect)rect{
    if([kclassHeadType isEqualToString:@"1"]){
        UILabel *textLabel = [UILabel new];
        textLabel.text = sevenWeekDayNames[weekday];
        textLabel.textColor = kFontColor;
        textLabel.textAlignment = NSTextAlignmentCenter;
        textLabel.numberOfLines = 0;
        textLabel.font = [UIFont fontWithName:kclassFontName size:_fontsize];
        textLabel.frame = rect;
        [self addSubview:textLabel];
    }else if([kclassHeadType isEqualToString:@"2"]){
        UILabel *textLabel = [UILabel new];
        textLabel.text = sevenWeekDayEngNames[weekday];
        textLabel.textColor = kFontColor;
        textLabel.textAlignment = NSTextAlignmentCenter;
        textLabel.numberOfLines = 0;
        textLabel.font = [UIFont fontWithName:kclassFontName size:_fontsize];
        textLabel.frame = rect;
        [self addSubview:textLabel];
    }else if([kclassHeadType isEqualToString:@"3"]){
        UIImageView *headimgView;
        headimgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:sevenWeekDayImgNames[weekday]]];
        headimgView.frame = CGRectMake(rect.origin.x + rect.size.width/2 - rect.size.height/2, rect.origin.y + 3, rect.size.height - 6, rect.size.height - 6);
        [self addSubview:headimgView];
    }

}

// 添加一个文字标签
-(void)addText:(NSString *)str inRect:(CGRect)rect forWeekday:(int)weekday inOrder:(int)order inRow:(int)row{
    UILabel *textLabel = [UILabel new];
    textLabel.text = str;
    textLabel.textColor = kFontColor;
    textLabel.textAlignment = NSTextAlignmentCenter; //对齐方式
    textLabel.font = [UIFont fontWithName:kclassFontName size:_fontsize]; //设置字体
    textLabel.numberOfLines = 0;
    textLabel.frame = rect;
    
    if (weekday < nowClassOrder[0] || (weekday == nowClassOrder[0] && order < nowClassOrder[1]) || (weekday == nowClassOrder[0] && order == nowClassOrder[1] && row < nowClassOrder[2])){
        switch (kdoneClassShow) {
            case 2:
                textLabel.textColor = [UIColor darkGrayColor];
                break;
            case 3:
                textLabel.backgroundColor =  [UIColor colorWithWhite:0.6 alpha:0.8];
                break;
            default:
                break;
        }
    }else if(weekday == nowClassOrder[0] && order == nowClassOrder[1] && row == nowClassOrder[2]){
        switch (nowClassOrder[3]) {
            case 1:
                switch (knowClassShow) {
                    case 2:
                        textLabel.textColor = kLightFontColor;
                        break;
                    case 3:
                        textLabel.layer.borderColor = [kLightFontColor CGColor];
                        textLabel.layer.borderWidth = 1;
                        break;
                    case 4:
                        textLabel.backgroundColor = kLightFontColor;
                        break;
                    default:
                        break;
                }
                break;
            case 2:
                switch (kdoneClassShow) {
                    case 2:
                        textLabel.textColor = [UIColor darkGrayColor];
                        break;
                    case 3:
                        textLabel.backgroundColor =  [UIColor colorWithWhite:0.3 alpha:0.8];
                        break;
                    default:
                        break;
                }
                break;
            default:
                break;
        }
    }
    
    textLabel.lineBreakMode = NSLineBreakByClipping;
    
    // 添加一个长按手势
    if (klongpressGes != 3) {
        textLabel.userInteractionEnabled = YES;
        UILongPressGestureRecognizer *longPressGesture=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressImage:)];
        longPressGesture.minimumPressDuration=0.5;
        [textLabel addGestureRecognizer:longPressGesture];
    }
    
    [self addSubview:textLabel];
}

// 长按响应
-(void)longPressImage:(UILongPressGestureRecognizer *)gesture{
    if (gesture.state==UIGestureRecognizerStateBegan) {
        if (klongpressGes == 2) {
            [_calendarDataSource addHwByCalendarData:((UILabel*)gesture.view).text];
        }else{
            NSMutableArray *lbarr = [NSMutableArray new];
            NSMutableArray *lbColorarr = [NSMutableArray new];
            for(UILabel* sview in self.subviews){
                /* 0324 所有子view都是UILabel，故不判断
                NSString *viewClass = NSStringFromClass([sview class]);
                NSLog(@"class类型：%@",viewClass);
                 */
                if([sview.text isEqualToString:((UILabel*)gesture.view).text]){
                    [lbColorarr addObject:sview.textColor];
                    [lbarr addObject:sview];
                    sview.textColor = kLightFontColor;
                }
            }
            if (lbarr.count > 0) {
                [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(diLname:) userInfo:@[lbarr,lbColorarr] repeats:NO];
            }
        }
    }
}

// 长按高亮后颜色还原
-(void)diLname:(NSTimer*)timer{
    NSArray *infoarr = [timer userInfo];
    NSArray *lbarr = infoarr[0];
    NSArray *lbColorarr = infoarr[1];
    UILabel *templb;
    int lbarrCount = (int)lbarr.count;
    for (int i = 0; i < lbarrCount; ++ i) {
        templb = lbarr[i];
        templb.textColor = lbColorarr[i];
    }
}

@end
