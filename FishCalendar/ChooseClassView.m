//
//  ChooseClassView.m
//  课程选择弹框
//
//  Created by Hydra on 17/3/19.
//  Copyright © 2017年 Hydra. All rights reserved.
//

#import "ChooseClassView.h"

#define mBlueColor [UIColor colorWithRed:50.0/255.0 green:162.0/255.0 blue:248.0/255.0 alpha:1.0]

@implementation ChooseClassView

// 初始化
- (instancetype)initWithClasses:(NSArray*)_classNameNameArray{
    self = [super init];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"ChooseClass" owner:self options:nil] lastObject];
        selectnow = 0;
        _classNameArr = _classNameNameArray;
        
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        self.frame = CGRectMake(0, viewBounds.size.height, viewBounds.size.width, 250);
        [window addSubview:self.bgView];
        [window addSubview:self];

        _cleanBtn.titleLabel.text = @"aaaa";
        UILabel *lb = [self viewWithTag:301];
        _cleanBtn.frame = CGRectMake(viewBounds.size.width - lb.frame.origin.x - _cleanBtn.frame.size.width, _cleanBtn.frame.origin.y, _cleanBtn.frame.size.width, _cleanBtn.frame.size.height);
    }
    return self;
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




# pragma mark 代理方法

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _classNameArr.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return _classNameArr[row];
}

// 当用户选中UIPickerViewDataSource中指定列和列表项时，激发该方法
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    selectnow = (int)row;
}










# pragma mark 自定义方法

// 点击确定事件
- (IBAction)okBtnClick:(id)sender {
    [self hide];
    if (self.selectClassBlock) {
        self.selectClassBlock(selectnow);
    }
}

- (IBAction)cleanBtnClick:(id)sender {
    [self hide];
    if (self.selectClassBlock) {
        self.selectClassBlock(-1);
    }
}

/** 显示 */
- (void)show {
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



@end
