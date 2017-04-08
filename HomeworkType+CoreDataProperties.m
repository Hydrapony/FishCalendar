//
//  HomeworkType+CoreDataProperties.m
//  FishCalendar
//
//  Created by Hydra on 17/2/28.
//  Copyright © 2017年 Hydra. All rights reserved.
//

#import "HomeworkType+CoreDataProperties.h"

@implementation HomeworkType (CoreDataProperties)

+ (NSFetchRequest<HomeworkType *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"HomeworkType"];
}

@dynamic typename;
@dynamic toclassname;

@end
