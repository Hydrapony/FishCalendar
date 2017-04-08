//
//  SettingParametersViewController.h
//  参数设置
//
//  Created by Hydra on 17/3/8.
//  Copyright © 2017年 Hydra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import <AssetsLibrary/ALAsset.h>

#import "Constant.h"
#import "SettingParametersFontViewController.h"
#import "SettingParametersBgViewController.h"
#import "SettingColorPickerViewController.h"

@interface SettingParametersViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,SettingParametersFontDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,SettingParametersBgDelegate,SettingParametersColorDelegate>{
    
    UIView *_switch0View; // 节能模式开关视图
    UISwitch *_switch0; // 节能模式
    NSString *_str1; // 字体
    UIImagePickerController *picker4; // 课程表背景选择
    NSString *_str4; // 课程表背景
    UILabel *_label6; // 表头显示方式
    UILabel *_label7; // 环按钮延迟时间
    UILabel *_label8; // 作业时段分割
    UILabel *_label9; // 默认打开作业标签
    UILabel *_label10; // 作业进度显示方式

    NSMutableDictionary *_settings; // plist具体读取内容

}

extern CGRect viewBounds;
extern NSMutableDictionary *ksettingsAll;
extern int kNavigationBarViewHigh;
extern CGRect kbtn1rect;
extern CGRect kbtn4rect;

@property(nonatomic,strong) UITableView *tableView; // 列表
@property(nonatomic,strong) UIView *navigationBarView; // 栈导航栏

@end
