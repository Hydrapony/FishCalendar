//
//  ClassName+CoreDataProperties.m
//  
//
//  Created by Hydra on 17/3/16.
//
//

#import "ClassName+CoreDataProperties.h"

@implementation ClassName (CoreDataProperties)

+ (NSFetchRequest<ClassName *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"ClassName"];
}

@dynamic homeworkname;
@dynamic img;
@dynamic name;
@dynamic attribute1;
@dynamic havehomework;

@end
