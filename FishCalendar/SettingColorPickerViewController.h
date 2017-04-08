//
//  ColorPickerViewController.h
//  参数设置-颜色设置
//
//  Created by Hydra on 17/3/12.
//  Copyright © 2017年 Hydra. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Constant.h"

#pragma mark 实现代理
@protocol SettingParametersColorDelegate
-(void)checkin:(NSString *)colorStr for:(NSString *)pknum; // 更新指定颜色数据，以“R+G+B”形式字符串标识
@end

@interface SettingColorPickerViewController : UIViewController

extern CGRect viewBounds;
extern int kNavigationBarViewHigh;
extern CGRect kbtn1rect;
extern CGRect kbtn4rect;

@property(nonatomic,strong) UIColor *color;
@property(nonatomic,strong) NSString *pknum;
@property(nonatomic,strong) UIView *navigationBarView; // 栈导航栏
@property(nonatomic,strong) id<SettingParametersColorDelegate> colorDelegate; // color选择View代理

- (instancetype)initWithColor:(NSString *)color for:(NSString *)pknum;

@end
