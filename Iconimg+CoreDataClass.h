//
//  Iconimg+CoreDataClass.h
//  图标名
//
//  Created by Hydra on 17/2/24.
//  Copyright © 2017年 Hydra. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ClassName;

NS_ASSUME_NONNULL_BEGIN

@interface Iconimg : NSManagedObject

+(Iconimg *)addWithDictionary:(NSDictionary *)dic withDbcx:(NSManagedObjectContext*)dbcx;
+(void)modifyIconimg:(Iconimg *)theDaily withDictionary:(NSDictionary *)dic withDbcx:(NSManagedObjectContext*)dbcx;

@end

NS_ASSUME_NONNULL_END

#import "Iconimg+CoreDataProperties.h"
