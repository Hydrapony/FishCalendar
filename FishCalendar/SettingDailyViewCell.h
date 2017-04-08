//
//  SettingDailyViewCell.h
//  FishCalendar
//
//  Created by Hydra on 17/3/21.
//  Copyright © 2017年 Hydra. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Constant.h"
#import "DailyLong+CoreDataProperties.h"
#import "Iconimg+CoreDataProperties.h"

@interface SettingDailyViewCell : UITableViewCell

extern int kTitleTextFontSize;
extern int kSecTitleTextFontSize;
extern int kInfoTextFontSize;
extern CGRect viewBounds;

@property (assign,nonatomic) CGFloat height; // 单元格高度

-(void)loadDaily:(DailyLong*)dailylong withInfo:(NSDictionary*)infoDic; // 加载数据和列表行组信息

@end
