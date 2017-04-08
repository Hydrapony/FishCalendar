//
//  DailyLong+CoreDataProperties.m
//  FishCalendar
//
//  Created by Hydra on 17/3/3.
//  Copyright © 2017年 Hydra. All rights reserved.
//

#import "DailyLong+CoreDataProperties.h"

@implementation DailyLong (CoreDataProperties)

+ (NSFetchRequest<DailyLong *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"DailyLong"];
}

@dynamic recentdate;
@dynamic havedone;
@dynamic imgname;
@dynamic info;
@dynamic isvalid;
@dynamic name;
@dynamic fromdate;
@dynamic todate;

@end
