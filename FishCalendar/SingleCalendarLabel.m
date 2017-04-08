//
//  SingleCalendarLabel.m
//  一日课程表中的一行课程
//
//  Created by Hydra on 17/3/25.
//  Copyright © 2017年 Hydra. All rights reserved.
//

#import "SingleCalendarLabel.h"

@implementation SingleCalendarLabel

- (instancetype)initWithClassName:(NSString*)classname inColor:(UIColor*)fontColor andTime:(NSString*)timeStr inRect:(CGRect)rect
{
    self = [super init];
    if (self) {
        [self setFrame:rect];
        // 左侧名称
        _nameLabel = [UILabel new];
        _nameLabel.text = classname;
        _nameLabel.textColor = fontColor;
        _nameLabel.textAlignment = NSTextAlignmentCenter; //对齐方式
        _nameLabel.font = [UIFont fontWithName:kclassFontName size:16]; //设置字体
        CGSize infoSize=[_nameLabel.text sizeWithAttributes:@{NSFontAttributeName:_nameLabel.font}];
        [_nameLabel setFrame:CGRectMake(self.frame.origin.x + self.frame.size.width / 8, self.frame.size.height/2 - infoSize.height/2, infoSize.width, infoSize.height)];
        _nameLabel.numberOfLines = 0;
        [self addSubview:_nameLabel];
        
        // 中部作业概要 TODO
        
        // 右侧时间
        _timeLabel = [UILabel new];
        _timeLabel.text = timeStr;
        _timeLabel.textColor = fontColor;
        _timeLabel.textAlignment = NSTextAlignmentCenter; //对齐方式
        _timeLabel.font = [UIFont fontWithName:kclassFontName size:16]; //设置字体
        infoSize=[_timeLabel.text sizeWithAttributes:@{NSFontAttributeName:_timeLabel.font}];
        [_timeLabel setFrame:CGRectMake(self.frame.size.width * 7 / 8 - infoSize.width, self.frame.size.height/2 - infoSize.height/2, infoSize.width, infoSize.height)];
        _timeLabel.layer.borderColor = [[UIColor redColor]CGColor];
        
        [self addSubview:_timeLabel];
    }
    return self;
}

- (void)setTColor:(UIColor*)color{
    for (UILabel* lb in [self subviews]) {
        lb.textColor = color;
    }
}

@end
