//
//  Constant.h
//  布局变量 初始化方法
//
//  Created by Hydra on 17/3/1.
//  Copyright © 2017年 Hydra. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>

@interface Constant : NSObject

+ (void)getSetting; // 获取setting.plist数据
+ (void)saveplist:(NSMutableDictionary*)settings tofile:(NSString*)filename;// 保存plist数据
+ (NSManagedObjectContext *)createDbContext; // 创建数据库上下文
+ (NSManagedObjectContext *)updateDbContext:(NSManagedObjectContext *)dbcontext;
+ (void)initOriginData; // 源初的数据生成
+ (void)alertError:(UIView*)view;

@end
