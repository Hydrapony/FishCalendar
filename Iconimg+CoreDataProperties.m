//
//  Iconimg+CoreDataProperties.m
//  FishCalendar
//
//  Created by Hydra on 17/2/25.
//  Copyright © 2017年 Hydra. All rights reserved.
//

#import "Iconimg+CoreDataProperties.h"

@implementation Iconimg (CoreDataProperties)

+ (NSFetchRequest<Iconimg *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Iconimg"];
}

@dynamic imgname;

@end
