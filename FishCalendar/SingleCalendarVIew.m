//
//  SingleCalendarVIew.m
//  单日课程表
//
//  Created by Hydra on 17/3/25.
//  Copyright © 2017年 Hydra. All rights reserved.
//

#import "SingleCalendarView.h"

@implementation SingleCalendarView

// 初始化
- (instancetype)initWithMainView:(MainCalendarView*)mView
{
    self = [super init];
    if (self) {
        _mainCalendarView = mView;
        [self initViewData];
    }
    return self;
}

- (void)initViewData{
    [self setFrame:_mainCalendarView.frame];
    // 时间获取
    NSDate *_dateNow = [NSDate date];
    NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [cal setTimeZone:[NSTimeZone timeZoneWithName:@"CCD"]];
    NSDateComponents *_dateNowComps = [cal components: NSCalendarUnitWeekOfYear | NSCalendarUnitWeekday | NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:_dateNow];
    
    int hcellsMO = khcellsMO;
    int hcellsAM = khcellsAM;
    int hcellsPM = khcellsPM;
    int hcellsDN = khcellsDN;
    
    NSArray *_classesToday = _mainCalendarView->_classes[((int)_dateNowComps.weekday + 5)%7];
    
    double allh = 0; // 总高度有几份
    allh += (hcellsMO + hcellsAM + hcellsPM + hcellsDN)*3 + 1;
    if(hcellsMO > 0){allh += 1;};
    if(hcellsDN > 0){allh += 1;};
    
    double cellh = self.frame.size.height/allh; // 每份高度，cell：3；间隔：1
    int oneCellHigh = cellh * 3;
    int oneCellWeigth = self.frame.size.width;
    
    int i = 0; // 循环变量
    int ck = 0; // 记录当前高度（几份）
    if (hcellsMO > 0) {
        for(i = 0 ;i < hcellsMO ;++i){
            [self addLabel:_classesToday[i] inRect:CGRectMake(0, oneCellHigh * i, oneCellWeigth, oneCellHigh) inOrder:0 inRow:i];
        }
        ck += 3*i+1;
    }
    for(i = 0 ;i < hcellsAM ;++i){
        [self addLabel:_classesToday[2+i] inRect:CGRectMake(0, ck * cellh + oneCellHigh * i, oneCellWeigth, oneCellHigh) inOrder:1 inRow:i];
    }
    ck += 3*i + 1;
    for(i = 0 ;i < hcellsPM ;++i){
        [self addLabel:_classesToday[8+i] inRect:CGRectMake(0, ck * cellh + oneCellHigh * i, oneCellWeigth, oneCellHigh) inOrder:2 inRow:i];
    }
    ck += 3*i + 1;
    for(i = 0 ;i < hcellsDN ;++i){
        [self addLabel:_classesToday[13+i] inRect:CGRectMake(0, ck * cellh + oneCellHigh * i, oneCellWeigth, oneCellHigh) inOrder:3 inRow:i];
    }
}







#pragma mark 自定义方法

// 增加一行Label
- (void)addLabel:(NSString*)str inRect:(CGRect)rect inOrder:(int)order inRow:(int)row{
    SingleCalendarLabel *textLabel = [[SingleCalendarLabel alloc]initWithClassName:str inColor:_mainCalendarView->kFontColor andTime:_mainCalendarView->_classInCaleAll[[NSString stringWithFormat:@"%i",order]][[NSString stringWithFormat:@"%i",row]] inRect:rect];
    textLabel.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.5];
    
    if (order < _mainCalendarView->nowClassOrder[1] || (order == _mainCalendarView->nowClassOrder[1] && row < _mainCalendarView->nowClassOrder[2])){
        switch (kdoneClassShow) {
            case 2:
                [textLabel setTColor:[UIColor darkGrayColor]];
                break;
            case 3:
                textLabel.backgroundColor =  [UIColor colorWithWhite:0.6 alpha:0.8];
                break;
            default:
                break;
        }
    }else if(order == _mainCalendarView->nowClassOrder[1] && row == _mainCalendarView->nowClassOrder[2]){
        switch (_mainCalendarView->nowClassOrder[3]) {
            case 1:
                switch (knowClassShow) {
                    case 2:
                        [textLabel setTColor:_mainCalendarView->kLightFontColor];
                        break;
                    case 3:
                        textLabel.layer.borderColor = [_mainCalendarView->kLightFontColor CGColor];
                        textLabel.layer.borderWidth = 1;
                        break;
                    case 4:
                        textLabel.backgroundColor = _mainCalendarView->kLightFontColor;
                        break;
                    default:
                        break;
                }
                break;
            case 2:
                switch (kdoneClassShow) {
                    case 2:
                        [textLabel setTColor:[UIColor darkGrayColor]];
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
    
    // 添加一个长按手势
    if (klongpressGes != 3) {
        textLabel.userInteractionEnabled = YES;
        UILongPressGestureRecognizer *longPressGesture=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressImage:)];
        longPressGesture.minimumPressDuration=0.5;
        [textLabel addGestureRecognizer:longPressGesture];
    }
    
    [self addSubview:textLabel];
    
}


// 长按响应(仅仅响应作业增加)
-(void)longPressImage:(UILongPressGestureRecognizer *)gesture{
    if (gesture.state==UIGestureRecognizerStateBegan) {
        if (klongpressGes == 2) {
            [_mainCalendarView.calendarDataSource addHwByCalendarData:((SingleCalendarLabel*)gesture.view).nameLabel.text];
        }
    }
}

@end
