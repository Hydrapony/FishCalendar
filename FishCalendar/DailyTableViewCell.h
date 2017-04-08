//
//  DailyTableViewCell.h
//  日常列表项
//
//  Created by Hydra on 17/2/11.
//  Copyright © 2017年 Hydra. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RingBtn.h"
#import "Constant.h"
#import "Daily+CoreDataProperties.h"
#import "DailyLong+CoreDataProperties.h"

@interface DailyTableViewCell : UITableViewCell

// 全局变量
extern int kTitleTextFontSize;
extern int kSecTitleTextFontSize;
extern int kInfoTextFontSize;
extern CGRect viewBounds;

@property (assign,nonatomic) CGFloat height; // 单元格高度

-(void)loadDaily:(Daily*)daily withInfo:(NSDictionary*)infoDic; // 加载数据和列表行组信息
-(void)setCellColor:(UIColor*)bgcolor; // 设置背景色（用于延期作业）

@end
