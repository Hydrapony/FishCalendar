//
//  SingleCalendarView.h
//  单日课程表
//
//  Created by Hydra on 17/3/25.
//  Copyright © 2017年 Hydra. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Constant.h"

#import "MainCalendarView.h"
#import "SingleCalendarLabel.h"

#pragma mark 数据导入代理

@interface SingleCalendarView : UIView{
    MainCalendarView *_mainCalendarView;
}

- (instancetype)initWithMainView:(MainCalendarView*)mView;
- (void)initViewData; // 加载数据 准备绘图

@end
