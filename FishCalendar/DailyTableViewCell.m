//
//  DailyTableViewCell.m
//  日常列表项
//
//  Created by Hydra on 17/2/11.
//  Copyright © 2017年 Hydra. All rights reserved.
//

#import "DailyTableViewCell.h"

#define kDarkCellColor [UIColor colorWithRed:38/255.0 green:38/255.0 blue:38/255.0 alpha:1]// 深色列背景
#define kLightTextColor [UIColor colorWithRed:221/255.0 green:221/255.0 blue:221/255.0 alpha:1]// 浅色列字
#define kDarkTextColor [UIColor colorWithRed:141/255.0 green:141/255.0 blue:141/255.0 alpha:1]// 深色列字

@interface DailyTableViewCell(){
    UIImageView *_nameimg; // 任务图像
    UILabel *_name; // 任务名称
    UILabel *_enddate; // 截止日期&耗时
    RingBtn *_ringbtn; // 完成按钮
    UITextView *_info; // 任务详细信息
}

@end

@implementation DailyTableViewCell

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
        _enddate = [UILabel new];
        [self.contentView addSubview:_enddate];
        _ringbtn = [[RingBtn alloc]initWithBlackColor:kDarkCellColor];
        [self.contentView addSubview:_ringbtn];
        _info = [UITextView new];
        [self.contentView addSubview:_info];
        // 防止单元格被持久选中(高亮)
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

// 控件设定、加载数据
-(void)loadDaily:(Daily*)daily withInfo:(NSDictionary*)infoDic{
    [_nameimg setImage:[UIImage imageNamed:daily.imgname]];
    [_nameimg setFrame:CGRectMake(4, 4, 30, 30)];
    
    _name.text = daily.name;
    _name.textColor = [UIColor whiteColor];
    _name.font = [UIFont systemFontOfSize:kTitleTextFontSize];
    CGSize infoSize=[_name.text sizeWithAttributes:@{NSFontAttributeName:_name.font}];
    [_name setFrame:CGRectMake(42, 10, infoSize.width, infoSize.height)];
    
    // TODO 改成计划完成时间
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM.dd"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    NSString *enddateText = [dateFormatter stringFromDate:daily.enddate];
    double havedone = [daily.havedone doubleValue];
    // 2017.3.2 决定隐去“截止”
    // _enddate.text = [NSString stringWithFormat:@"截止 %@ | 耗时 %.2f", enddateText, havedone];
    if(havedone == 0){
        _enddate.text = @"耗时未定";
    }else{
        int havedoneHour = (int)havedone / 60;
        int havedoneMinute = (int)havedone % 60;
        if(havedoneHour > 0){
            if(havedoneMinute != 0){
                _enddate.text = [NSString stringWithFormat:@"预计 %i 小时 %i 分钟", havedoneHour,havedoneMinute];
            }else{
                _enddate.text = [NSString stringWithFormat:@"预计 %i 小时", havedoneHour];
            }
        }else{
            _enddate.text = [NSString stringWithFormat:@"预计 %i 分钟", havedoneMinute];
        }
    }
    _enddate.textColor = kDarkTextColor;
    _enddate.font = [UIFont systemFontOfSize:kSecTitleTextFontSize];
    infoSize=[_enddate.text sizeWithAttributes:@{NSFontAttributeName:_enddate.font}];
    [_enddate setFrame:CGRectMake(47 + _name.frame.size.width,16, infoSize.width, infoSize.height)];
    
    [_ringbtn setFrame:CGRectMake(viewBounds.size.width - 66, 8, 60, 60)];
    _ringbtn.btnInfoDic = infoDic;
    _ringbtn.ringDelegate = infoDic[@"viewController"];
    if(daily.isvalid.integerValue == 0){
        [_ringbtn setRingDone];
    }
    
    _info.text = daily.info;
    _info.textColor = kLightTextColor;
    _info.backgroundColor = kDarkCellColor;
    _info.scrollEnabled = NO;
    _info.editable = NO; 
    _info.font = [UIFont systemFontOfSize:kInfoTextFontSize];
    
    CGRect rect = [_info.text boundingRectWithSize:CGSizeMake(viewBounds.size.width - 77,8000) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:_info.font} context:nil];
    [_info setFrame:CGRectMake(8, 38, rect.size.width, rect.size.height)];
    _info.textContainer.lineFragmentPadding = 0;
    _info.textContainerInset = UIEdgeInsetsZero;
    _height = (46 + rect.size.height)>78?(46 + rect.size.height):78;
    
}

// 设置背景色
-(void)setCellColor:(UIColor *)bgcolor{
    _ringbtn.backgroundColor = bgcolor;
    _info.backgroundColor = bgcolor;
}

@end
