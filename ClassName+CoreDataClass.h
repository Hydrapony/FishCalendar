//
//  ClassName+CoreDataClass.h
//  任务名
//
//  Created by Hydra on 17/2/24.
//  Copyright © 2017年 Hydra. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "HomeworkType+CoreDataClass.h"

NS_ASSUME_NONNULL_BEGIN

@interface ClassName : NSManagedObject

+(ClassName *)addWithDictionary:(NSDictionary *)dic withDbcx:(NSManagedObjectContext*)dbcx;
+(bool)modifyClassName:(ClassName *)theClassName withDictionary:(NSDictionary *)dic withDbcx:(NSManagedObjectContext*)dbcx;
+(bool)removeClassName:(ClassName *)classname withDbcx:(NSManagedObjectContext*)dbcx;

@end

NS_ASSUME_NONNULL_END

#import "ClassName+CoreDataProperties.h"
