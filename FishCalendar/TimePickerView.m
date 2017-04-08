//
//  TimePickerView.m
//  日程时间选择弹框
//
//  Created by Hydra on 17/3/17. via 谭真
//  Copyright © 2017年 Hydra. All rights reserved.
//

#import "TimePickerView.h"

#define mBlueColor [UIColor colorWithRed:50.0/255.0 green:162.0/255.0 blue:248.0/255.0 alpha:1.0]
#define mGrayColor [UIColor colorWithRed:165/255.0 green:165/255.0 blue:165/255.0 alpha:1.0]

@implementation TimePickerView

#pragma mark 配置视图

// 初始化
- (instancetype)init{
    self = [super init];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"TimePickerView" owner:self options:nil] lastObject];
        // hy add
        _datePicker.datePickerMode = UIDatePickerModeTime;
        _datePicker.minuteInterval = 5;
        
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        self.frame = CGRectMake(0, viewBounds.size.height, viewBounds.size.width, 350);
        [window addSubview:self.bgView];
        [window addSubview:self];
    }
    return self;
}

// 初始化Date控件
- (void)setCTime:(NSString *)ctimeStr{
    NSArray *ctimeArr = [ctimeStr componentsSeparatedByString:@"-"];
    [self.datePicker setDate:[_formatter dateFromString:ctimeArr[0]] animated:YES];
}

- (UIView *)bgView {
    if (_bgView == nil) {
        _bgView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        _bgView.hidden = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
        [_bgView addGestureRecognizer:tap];
    }
    return _bgView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // 开始时间和结束时间按钮的UI
    self.beginDateBtn.layer.cornerRadius = self.beginDateBtn.frame.size.height * 0.5;
    self.beginDateBtn.clipsToBounds = YES;
    self.endDateBtn.layer.cornerRadius = self.endDateBtn.frame.size.height * 0.5;
    self.endDateBtn.clipsToBounds = YES;
    
    [self.beginDateBtn setBackgroundImage:[self createImageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [self.endDateBtn setBackgroundImage:[self createImageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [self.beginDateBtn setBackgroundImage:[self createImageWithColor:mBlueColor] forState:UIControlStateSelected];
    [self.endDateBtn setBackgroundImage:[self createImageWithColor:mBlueColor] forState:UIControlStateSelected];
    
    self.beginDateBtn.layer.borderWidth = 1;
    self.beginDateBtn.layer.borderColor = mBlueColor.CGColor;
    self.endDateBtn.layer.borderWidth = 1;
    self.endDateBtn.layer.borderColor = mBlueColor.CGColor;
    
    // 设置时间格式转换器
    self.formatter = [[NSDateFormatter alloc] init];
    self.formatter.dateFormat = @"HH:mm";
    
    // 选中开始时间按钮
    [self beginDateBtnClick:self.beginDateBtn];
    
    // 配置DatePicker
    //self.datePicker.maximumDate = [NSDate date];
    CGRect newFrame = self.datePicker.frame;
    newFrame.size.width = 375;
    self.datePicker.frame = newFrame;
    
    // 确定筛选按钮
    self.okBtnToSrceenOrder.backgroundColor = mBlueColor;
    [self.okBtnToSrceenOrder setBackgroundImage:[self createImageWithColor:[UIColor lightGrayColor]] forState:UIControlStateDisabled];
    self.okBtnToSrceenOrder.titleLabel.font = [UIFont systemFontOfSize:15];
    self.okBtnToSrceenOrder.enabled = NO;
    self.okBtnToSrceenOrder.layer.cornerRadius = 3;
    self.okBtnToSrceenOrder.clipsToBounds = YES;
}

/** 选择开始时间 */
- (IBAction)beginDateBtnClick:(id)sender {
    self.beginDateBtn.selected = YES;
    self.endDateBtn.selected = NO;
    
    self.tipLable.text = @"选择开始时间";
    [self.beginDateBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.endDateBtn setTitleColor:mBlueColor forState:UIControlStateNormal];
    
    if (![self.beginDateLable.text isEqualToString:@"请选择"]) {
        [self.datePicker setDate:[self.formatter dateFromString:self.beginDateLable.text] animated:YES];
    }
    
    [self refreshOkBtnEnableStatus];
}

/** 选择结束时间 */
- (IBAction)endDateBtnClick:(UIButton *)sender {
    self.endDateBtn.selected = YES;
    self.beginDateBtn.selected = NO;

    self.tipLable.text = @"选择结束时间";
    [self.endDateBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.beginDateBtn setTitleColor:mBlueColor forState:UIControlStateNormal];
    
    if (![self.endDateLable.text isEqualToString:@"请选择"]) {
        [self.datePicker setDate:[self.formatter dateFromString:self.endDateLable.text] animated:YES];
    }
    
    [self refreshOkBtnEnableStatus];
}

/** 确定按钮选择该时间 */
- (IBAction)okButtonClick:(UIButton *)sender {
    if (self.beginDateBtn.selected) {
        NSDate *begininCheck = self.datePicker.date;
        self.beginDateLable.text = [self.formatter stringFromDate:begininCheck];
        // 选择了开始时间，去选择结束时间
        // hyadd 增加默认课时制时长
        self.datePicker.date = [[NSDate alloc] initWithTimeInterval:_perclassLength*60 sinceDate:begininCheck];
        [self endDateBtnClick:self.endDateBtn];
    } else {
        self.endDateLable.text = [self.formatter stringFromDate:self.datePicker.date];
        // 选择了结束时间，去选择开始时间
        [self beginDateBtnClick:self.beginDateBtn];
    }
    
    [self refreshOkBtnEnableStatus];
}

/** 去筛选订单 */
- (IBAction)gotoSrceenOrderClick:(id)sender {
    [self hide];
    if (self.gotoSrceenOrderBlock) {
        self.gotoSrceenOrderBlock(self.beginDateLable.text,self.endDateLable.text);
    }
}

#pragma mark 功能方法

/** 显示 */
- (void)show {
    // 默认让先选择开始时间
    [self beginDateBtnClick:self.beginDateBtn];
    
    [UIView animateWithDuration:0.35 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0.8 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.bgView.hidden = NO;
        
        CGRect newFrame = self.frame;
        newFrame.origin.y = viewBounds.size.height - self.frame.size.height;
        self.frame = newFrame;
    } completion:nil];
}

/** 隐藏 */
- (void)hide {
    [UIView animateWithDuration:0.35 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0.5 options:0 animations:^{
        self.bgView.hidden = YES;
        
        CGRect newFrame = self.frame;
        newFrame.origin.y = viewBounds.size.height;
        self.frame = newFrame;
    } completion:nil];
}

#pragma mark 私有方法

/** 检查确定按钮是否可被点击*/
- (void)refreshOkBtnEnableStatus {
    
    self.okBtnToSrceenOrder.enabled = (![self.beginDateLable.text isEqualToString:@"请选择"] && ![self.endDateLable.text isEqualToString:@"请选择"]);
    
    // 检查数据
    if (self.okBtnToSrceenOrder.enabled) {
        
        NSString *beginDateStr = [self.beginDateLable.text stringByReplacingOccurrencesOfString:@":" withString:@""];
        NSString *endDateStr = [self.endDateLable.text stringByReplacingOccurrencesOfString:@":" withString:@""];
        
        if (beginDateStr.integerValue > endDateStr.integerValue) {
            [self.okBtnToSrceenOrder setTitle:@"开始时间须小于结束时间" forState:UIControlStateDisabled];
            self.okBtnToSrceenOrder.enabled = NO;
        } else {
            [self.okBtnToSrceenOrder setTitle:@"确定" forState:UIControlStateDisabled];
        }
        
    }
}

/** 用颜色生成一张图片 */
- (UIImage *)createImageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

@end
