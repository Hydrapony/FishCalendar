//
//  SettingParametersFontViewController.h
//  参数设置-字体设置
//
//  Created by Hydra on 17/3/8.
//  Copyright © 2017年 Hydra. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Constant.h"

#pragma mark 实现代理
@protocol SettingParametersFontDelegate
-(void)checkin:(NSString *)fontStr; // 选择字体
@end

@interface SettingParametersFontViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    NSArray *_fonts; // 用于装载所有系统字体
    NSString *_settings; // plist具体读取内容
}

extern CGRect viewBounds;
extern NSMutableDictionary *ksettingsAll;
extern int kcellFontsize;
extern int kNavigationBarViewHigh;
extern CGRect kbtn1rect;
extern CGRect kbtn4rect;

@property(nonatomic,strong) UITableView *tableView; // 列表
@property(nonatomic,strong) UIView *navigationBarView; // 栈导航栏
@property(nonatomic,strong) id<SettingParametersFontDelegate> parDelegate; // 字体选择View代理

@end
