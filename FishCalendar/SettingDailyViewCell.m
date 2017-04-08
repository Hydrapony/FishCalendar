//
//  SettingDailyViewCell.m
//  FishCalendar
//
//  Created by Hydra on 17/3/21.
//  Copyright © 2017年 Hydra. All rights reserved.
//

#import "SettingDailyViewCell.h"

#define kDarkCellColor [UIColor colorWithRed:38/255.0 green:38/255.0 blue:38/255.0 alpha:1]// 深色列背景
#define kLightTextColor [UIColor colorWithRed:221/255.0 green:221/255.0 blue:221/255.0 alpha:1]// 浅色列字
#define kDarkTextColor [UIColor colorWithRed:141/255.0 green:141/255.0 blue:141/255.0 alpha:1]// 深色列字

@implementation SettingDailyViewCell{
    UIImageView *_nameimg; // 任务图像
    UILabel *_name; // 任务名称
    UILabel *_recentdate; // 开始日期
    UITextView *_info; // 任务详细信息
}


// 初始化
- (instancetype)init
{
    self = [super init];
    if (self) {
        // 初始化控件
        _nameimg = [UIImageView new];
        [self.contentView addSubview:_nameimg];
        _name = [UILabel new];
        [self.contentView addSubview:_name];
        _recentdate = [UILabel new];
        [self.contentView addSubview:_recentdate];
        _info = [UITextView new];
        [self.contentView addSubview:_info];
        // 防止单元格被持久选中(高亮)
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

// 控件设定、加载数据
-(void)loadDaily:(DailyLong*)dailylong withInfo:(NSDictionary*)infoDic{
    
    [_nameimg setImage:[UIImage imageNamed:dailylong.imgname]];
    [_nameimg setFrame:CGRectMake(4, 4, 30, 30)];
    
    _name.text = dailylong.name;
    _name.textColor = [UIColor whiteColor];
    _name.font = [UIFont systemFontOfSize:kTitleTextFontSize];
    CGSize infoSize=[_name.text sizeWithAttributes:@{NSFontAttributeName:_name.font}];
    [_name setFrame:CGRectMake(42, 10, infoSize.width, infoSize.height)];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy.MM.dd"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    double havedone = [dailylong.havedone doubleValue];
    NSString *havedoneStr;
    if(havedone == 0){
        havedoneStr = @"耗时未定";
    }else{
        int havedoneHour = (int)havedone / 60;
        int havedoneMinute = (int)havedone % 60;
        if(havedoneHour > 0){
            if(havedoneMinute != 0){
                havedoneStr = [NSString stringWithFormat:@"预计 %i 小时 %i 分钟", havedoneHour,havedoneMinute];
            }else{
                havedoneStr = [NSString stringWithFormat:@"预计 %i 小时", havedoneHour];
            }
        }else{
            havedoneStr = [NSString stringWithFormat:@"预计 %i 分钟", havedoneMinute];
        }
    }
    _recentdate.text = [NSString stringWithFormat:@"%@ | 自 %@ 开始", havedoneStr,[dateFormatter stringFromDate:dailylong.fromdate]];
    _recentdate.textColor = kDarkTextColor;
    _recentdate.font = [UIFont systemFontOfSize:kSecTitleTextFontSize];
    infoSize=[_recentdate.text sizeWithAttributes:@{NSFontAttributeName:_recentdate.font}];
    [_recentdate setFrame:CGRectMake(47 + _name.frame.size.width,16, infoSize.width, infoSize.height)];
    
    _info.text = dailylong.info;
    _info.textColor = kLightTextColor;
    _info.backgroundColor = kDarkCellColor;
    _info.scrollEnabled = NO;
    _info.editable = NO;
    _info.font = [UIFont systemFontOfSize:kInfoTextFontSize];
    
    CGRect rect = [_info.text boundingRectWithSize:CGSizeMake(viewBounds.size.width - 55,8000) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:_info.font} context:nil];
    [_info setFrame:CGRectMake(8, 38, rect.size.width, rect.size.height)];
    _info.textContainer.lineFragmentPadding = 0;
    _info.textContainerInset = UIEdgeInsetsZero;
    _height = (46 + rect.size.height)>78?(46 + rect.size.height):78;
    
    self.backgroundColor = kDarkCellColor;
}


@end
