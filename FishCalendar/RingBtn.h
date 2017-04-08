//
//  RingBtn.h
//  环形按钮（60×60）
//
//  Created by Hydra on 17/2/11.
//  Copyright © 2017年 Hydra. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Constant.h"

#pragma mark 环形按钮代理
@protocol RingBtnDelegate
    -(void)ringComplete:(NSDictionary *)infoDic; // 环形按钮完成
@end

@interface RingBtn : UIView{
    double numSlider; // 伪进度（0-1）
    UIButton *_btn;// 按钮
    double addSliderPerCe; // 按下后每次计时器触发增加的进度
    NSTimer *_btntimer; // 伪进度计时
}

extern NSString *kRingBtnTime;

@property(nonatomic,strong) NSDictionary *btnInfoDic; // 附加信息
@property(nonatomic,strong) id<RingBtnDelegate> ringDelegate; // 环形按钮代理

- (instancetype)initWithBlackColor:(UIColor*)backColor; // 初始化
- (void)setRingDone; // 设置已完成按钮状态

@end
