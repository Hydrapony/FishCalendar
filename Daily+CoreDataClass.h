//
//  Daily+CoreDataClass.h
//  任务
//
//  Created by Hydra on 17/2/21.
//  Copyright © 2017年 Hydra. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#import "DailyLong+CoreDataClass.h"

NS_ASSUME_NONNULL_BEGIN

@interface Daily : NSManagedObject

/*
 @property (nullable, nonatomic, copy) NSDate *enddate; // 日期
 @property (nullable, nonatomic, copy) NSNumber *havedone;// 预计时间
 @property (nullable, nonatomic, copy) NSString *imgname;// 任务图像
 @property (nullable, nonatomic, copy) NSString *info;// 详细信息
 @property (nullable, nonatomic, copy) NSNumber *isvalid;// 是否有效
 @property (nullable, nonatomic, copy) NSString *name;// 任务名称
 @property (nullable, nonatomic, copy) NSDate *fromdate;// 计划开始日期
 @property (nullable, nonatomic, copy) NSDate *todate;// 计划结束日期
 @property (nullable, nonatomic, copy) NSNumber *isdaily; // 是否日常
 */

+(Daily *)addWithDictionary:(NSDictionary *)dic withDbcx:(NSManagedObjectContext*)dbcx;
+(void)modifyDaily:(Daily *)theDaily withDictionary:(NSDictionary *)dic withDbcx:(NSManagedObjectContext*)dbcx;
+(Daily *)addWithDailyLong:(DailyLong *)dic withDbcx:(NSManagedObjectContext*)dbcx;

@end

NS_ASSUME_NONNULL_END

#import "Daily+CoreDataProperties.h"
