//
//  TimePickerView.h
//  日程时间选择弹框
//
//  Created by Hydra on 17/3/17. via 谭真
//  Copyright © 2017年 Hydra. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Constant.h"

@interface TimePickerView : UIView

extern CGRect viewBounds;

@property (nonatomic, copy) void(^gotoSrceenOrderBlock)(NSString *,NSString *);/** 返回用户选择的开始时间和结束时间 */

@property (nonatomic, strong) UIView *bgView; // 背景遮罩View

/** 时间按钮和文本 */
@property (weak, nonatomic) IBOutlet UIButton *beginDateBtn;
@property (weak, nonatomic) IBOutlet UILabel *beginDateLable;
@property (weak, nonatomic) IBOutlet UIButton *endDateBtn;
@property (weak, nonatomic) IBOutlet UILabel *endDateLable;

@property (nonatomic) int perclassLength; // hyadd 默认课程长度

/** 提示lable */
@property (weak, nonatomic) IBOutlet UILabel *tipLable;
/** datePicker */
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
/** 时间格式转换器 */
@property (nonatomic, strong) NSDateFormatter *formatter;
/** 去筛选订单按钮 */
@property (weak, nonatomic) IBOutlet UIButton *okBtnToSrceenOrder;

/** 显示 */
- (void)show;
/** 隐藏 */
- (void)hide;

- (void)setCTime:(NSString *)ctimeStr; // hyadd 形如“8:00-9:00”的时间段串

@end
