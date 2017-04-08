//
//  SettingParametersBgViewController.h
//  参数设置-背景设置
//
//  Created by Hydra on 17/3/9.
//  Copyright © 2017年 Hydra. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Constant.h"

#pragma mark 实现代理
@protocol SettingParametersBgDelegate
-(void)checkbg:(NSString *)bgStr; // 选择背景
-(void)switchPic; // 打开照片库选择器
@end

@interface SettingParametersBgViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    NSArray *bgStrs;
    NSString *_settings; // plist具体读取内容
}

extern CGRect viewBounds;
extern NSMutableDictionary *ksettingsAll;
extern int kNavigationBarViewHigh;
extern CGRect kbtn1rect;
extern CGRect kbtn4rect;

@property(nonatomic,strong) UITableView *tableView; // 列表
@property(nonatomic,strong) UIView *navigationBarView; // 栈导航栏
@property(nonatomic,strong) id<SettingParametersBgDelegate> parDelegate; // 字体选择View代理

@end
