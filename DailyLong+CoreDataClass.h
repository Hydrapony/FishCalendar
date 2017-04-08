//
//  DailyLong+CoreDataClass.h
//  FishCalendar
//
//  Created by Hydra on 17/3/3.
//  Copyright © 2017年 Hydra. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface DailyLong : NSManagedObject

/*
 @property (nullable, nonatomic, copy) NSDate *recentdate; // 预计将添加日期
 @property (nullable, nonatomic, copy) NSNumber *havedone;// 预计时间
 @property (nullable, nonatomic, copy) NSString *imgname;// 任务图像
 @property (nullable, nonatomic, copy) NSString *info;// 详细信息
 @property (nullable, nonatomic, copy) NSNumber *isvalid;// 是否有效
 @property (nullable, nonatomic, copy) NSString *name;// 任务名称
 @property (nullable, nonatomic, copy) NSDate *fromdate;// 计划开始日期
 @property (nullable, nonatomic, copy) NSDate *todate;// 计划结束日期
 */

+ (DailyLong *)addWithDictionary:(NSDictionary *)dic withDbcx:(NSManagedObjectContext*)dbcx;
+ (void)modifyDaily:(DailyLong *)theDaily withDictionary:(NSDictionary *)dic withDbcx:(NSManagedObjectContext*)dbcx;
+ (bool)removeDailyLong:(DailyLong *)dailylong withDbcx:(NSManagedObjectContext*)dbcx;
+ (void)pushRecentdateIn:(DailyLong *)theDaily WithDbcx:(NSManagedObjectContext*)dbcx;
+ (void)pushRecentdateIn:(DailyLong *)theDaily WithDbcx:(NSManagedObjectContext*)dbcx toDate:(NSDate*)todate;

@end

NS_ASSUME_NONNULL_END

#import "DailyLong+CoreDataProperties.h"
