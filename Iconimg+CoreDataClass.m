//
//  Iconimg+CoreDataClass.m
//  FishCalendar
//
//  Created by Hydra on 17/2/24.
//  Copyright © 2017年 Hydra. All rights reserved.
//

#import "Iconimg+CoreDataClass.h"

@implementation Iconimg

#pragma mark 根据字典增

+(Iconimg *)addWithDictionary:(NSDictionary *)dic withDbcx:(NSManagedObjectContext*)dbcx{
    Iconimg *theIconimg= [NSEntityDescription insertNewObjectForEntityForName:@"Iconimg" inManagedObjectContext:dbcx];
    if (dic[@"imgname"]) {
        theIconimg.imgname=dic[@"imgname"];
    }
    NSError *error;
    if (![dbcx save:&error]) {
        NSLog(@"添加过程中发生错误,错误信息：%@！",error.localizedDescription);
    }
    return theIconimg;
}

#pragma mark 根据字典改

+(void)modifyIconimg:(Iconimg *)theIconimg withDictionary:(NSDictionary *)dic withDbcx:(NSManagedObjectContext*)dbcx{
    if (dic[@"imgname"]) {
        theIconimg.imgname=dic[@"imgname"];
    }
    NSError *error;
    if (![dbcx save:&error]) {
        NSLog(@"修改过程中发生错误,错误信息：%@",error.localizedDescription);
    }
}

@end
