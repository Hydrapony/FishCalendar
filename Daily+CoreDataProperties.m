//
//  Daily+CoreDataProperties.m
//  FishCalendar
//
//  Created by Hydra on 17/3/3.
//  Copyright © 2017年 Hydra. All rights reserved.
//

#import "Daily+CoreDataProperties.h"

@implementation Daily (CoreDataProperties)

+ (NSFetchRequest<Daily *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Daily"];
}

@dynamic enddate; 
@dynamic fromdate;
@dynamic havedone;
@dynamic imgname;
@dynamic info;
@dynamic isdaily;
@dynamic isvalid;
@dynamic name;
@dynamic todate;

@end
