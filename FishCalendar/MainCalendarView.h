//
//  MainCalendarView.h
//  课程表
//
//  Created by Hydra on 17/3/5.
//  Copyright © 2017年 Hydra. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Constant.h"

#pragma mark 数据导入代理
@protocol CalendarDataSource

- (NSMutableDictionary*)getCalendarData; // 获取课程表数据
- (void)addHwByCalendarData:(NSString*)classname; // 增加作业
- (void)changeCalFrame:(UIView*)calview; // 调整课程表frame大小

@end

@interface MainCalendarView : UIView{
    @public
        NSArray *_classes; // plist存储的课程表内容
        int weekNow; // 单周/默认0、双周1
        int _fontsize; // 字体大小，默认16
        UIColor *kFontColor; // 字体颜色
        UIColor *kLightFontColor; // 字体高亮颜色
        UIColor *kFrameColor; // 边框颜色
        int nowClassOrder[4]; // 目前进行的周/时段/第几堂课/与课程位置关系
        NSMutableDictionary *_classInCaleAll; // 全部时间段
    @private
        NSArray *sevenWeekDayNames;
        NSArray *sevenWeekDayEngNames;
        NSArray *sevenWeekDayImgNames;
}

extern NSString *kclassFontName;
extern NSString *kclassHeadType;
extern NSString *kFontColorRGB; // 字体颜色RGB
extern NSString *kLightFontColorRGB; // 字体高亮颜色RGB
extern NSString *kFrameColorRGB; // 边框颜色RGB

extern int kwcells; 
extern int khcellsMO;
extern int khcellsAM;
extern int khcellsPM;
extern int khcellsDN;
extern bool kdoubleWeekSetel;
extern int kdefaultCanendarShow; // 课程表默认展示方式
extern int klongpressGes; // 长按事件
extern int knowClassShow; // 目前课程展示方式
extern int kdoneClassShow; // 完成课程展示方式

@property(nonatomic,strong) id<CalendarDataSource> calendarDataSource; // 课程表数据源代理

- (instancetype)initWithDateSource:(id<CalendarDataSource>)dataSource;
- (void)initViewData; // 加载数据 准备绘图

@end
