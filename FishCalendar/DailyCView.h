//
//  DailyCView.h
//  （课程表用）日常增加页
//
//  Created by Hydra on 17/3/7.
//  Copyright © 2017年 Hydra. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Constant.h"

#pragma mark 任务页代理
@protocol DailyCViewDelegate

-(NSMutableArray*)addData; // 获取备选数据
-(bool)saveData:(NSDictionary*)dailyDic; // 保存新数据
-(void)updateSumTask:(int)num;// 更新SumTask角标

@end

@interface DailyCView : UIScrollView <UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate>{
    
    UILabel *_nameL; // 科目名称标签
    UILabel *_nameimgL; // 标识图标签
    UILabel *_havedoneL; // 计划耗时标签
    UILabel *_enddateL; // 截止日期标签
    UILabel *_isInfoL; // 是否有详细信息
    UILabel *_infoL; // 详细信息
    
    UIPickerView *_name; // 科目名称
    UITextField *_nameE; // 科目名称(手写)
    UIImageView *_nameimg; // 标识图
    UIPickerView *_havedone; // 计划耗时
    UIPickerView *_enddate; // 截止日期
    UIButton *_isInfoCheckbox; // 是否有详细信息
    UIPickerView *_info; // 详细信息(选择)
    UIButton *_addInfoHomeworkBtn; // 详细信息(选择)添加
    UITextView *_infoE; // 详细信息
    
    NSDate *_dateNow; // 当前日期时间
    NSDate *_dateenddate; // 选中截止日期
    NSCalendar *_calendar; // 当前日历类实例
    NSDateComponents *_compsNow; // 当前日期表示类
    NSDateComponents *_compsenddate; // 当前日期表示类
    int _lastDayOfDate; // 截止日期选择器最后一天
    
    NSArray *_classNameArray; // 备选ClassName对象
    NSMutableArray *_iconArray; // 备选Icon名称数组
    int _iconCheck; // 记录选中的icon在_iconArray的下标
}

// 全局变量
extern int kLabelTextFontSize;
extern int kLittleLabelTextFontSize;
extern int kLeftX;
extern int kRightX;
extern CGRect viewBounds;
extern NSString *kSlashTime;

@property(nonatomic,strong) id<DailyCViewDelegate> dailyCViewDelegate; // 任务页代理

- (instancetype)initWithDelegate:(id<DailyCViewDelegate>)theDelegate andClassName:(NSString*)classname;

@end
