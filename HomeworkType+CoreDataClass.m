//
//  HomeworkType+CoreDataClass.m
//  FishCalendar
//
//  Created by Hydra on 17/2/28.
//  Copyright © 2017年 Hydra. All rights reserved.
//

#import "HomeworkType+CoreDataClass.h"

@implementation HomeworkType

#pragma mark 根据字典增

+(HomeworkType *)addWithDictionary:(NSDictionary *)dic withDbcx:(NSManagedObjectContext*)dbcx{
    HomeworkType *theHomeworkType= [NSEntityDescription insertNewObjectForEntityForName:@"HomeworkType" inManagedObjectContext:dbcx];
    if (dic[@"typename"]) {
        theHomeworkType.typename=dic[@"typename"];
    }
    NSError *error;
    if (![dbcx save:&error]) {
        NSLog(@"添加过程中发生错误,错误信息：%@！",error.localizedDescription);
    }
    return theHomeworkType;
}

#pragma mark 根据字典改

+(void)modifyHomeworkType:(HomeworkType *)theHomeworkType withDictionary:(NSDictionary *)dic withDbcx:(NSManagedObjectContext*)dbcx{
    if (dic[@"typename"]) {
        theHomeworkType.typename=dic[@"typename"];
    }
    NSError *error;
    if (![dbcx save:&error]) {
        NSLog(@"修改过程中发生错误,错误信息：%@",error.localizedDescription);
    }
}

@end
