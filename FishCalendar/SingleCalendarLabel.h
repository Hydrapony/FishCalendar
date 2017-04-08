//
//  SingleCalendarLabel.h
//  一日课程表中的一行课程
//
//  Created by Hydra on 17/3/25.
//  Copyright © 2017年 Hydra. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Constant.h"

@interface SingleCalendarLabel : UIView

extern NSString *kclassFontName;

@property(nonatomic,strong) UILabel *nameLabel;
@property(nonatomic,strong) UILabel *timeLabel;

- (instancetype)initWithClassName:(NSString*)classname inColor:(UIColor*)fontColor andTime:(NSString*)timeStr inRect:(CGRect)rect;
- (void)setTColor:(UIColor*)color;

@end
