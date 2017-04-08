//
//  HomeworkType+CoreDataClass.h
//  作业类型
//
//  Created by Hydra on 17/2/28.
//  Copyright © 2017年 Hydra. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ClassName;

NS_ASSUME_NONNULL_BEGIN

@interface HomeworkType : NSManagedObject

+(HomeworkType *)addWithDictionary:(NSDictionary *)dic withDbcx:(NSManagedObjectContext*)dbcx;
+(void)modifyHomeworkType:(HomeworkType *)theHomeworkType withDictionary:(NSDictionary *)dic withDbcx:(NSManagedObjectContext*)dbcx;

@end

NS_ASSUME_NONNULL_END

#import "HomeworkType+CoreDataProperties.h"
