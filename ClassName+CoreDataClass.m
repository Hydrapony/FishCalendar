//
//  ClassName+CoreDataClass.m
//  FishCalendar
//
//  Created by Hydra on 17/2/24.
//  Copyright © 2017年 Hydra. All rights reserved.
//

#import "ClassName+CoreDataClass.h"

@implementation ClassName

#pragma mark 根据字典增

+(ClassName *)addWithDictionary:(NSDictionary *)dic withDbcx:(NSManagedObjectContext*)dbcx{
    ClassName *theClassName= [NSEntityDescription insertNewObjectForEntityForName:@"ClassName" inManagedObjectContext:dbcx];
    //通过上面的代码可以得到Daily这个表的指定实例，然后可以使用这个实例去为表中的属性赋值
    if (dic[@"name"]) {
        theClassName.name=dic[@"name"];
    }
    if (dic[@"img"]){
        theClassName.img=dic[@"img"];
    }
    if (dic[@"homeworkname"]){
        theClassName.homeworkname=dic[@"homeworkname"];
    }
    if (dic[@"havehomework"]){
        NSSet *homeworkTypes = dic[@"havehomework"];
        [theClassName addHavehomework:homeworkTypes];
    }
    
    NSError *error;
    if (![dbcx save:&error]) {
        NSLog(@"添加过程中发生错误,错误信息：%@！",error.localizedDescription);
    }
    return theClassName;
}

#pragma mark 根据字典改

// 修改，字典中需要条件 TODO
+(bool)modifyClassName:(ClassName *)theClassName withDictionary:(NSDictionary *)dic withDbcx:(NSManagedObjectContext*)dbcx{
    if (dic[@"name"]) {
        theClassName.name=dic[@"name"];
    }
    if (dic[@"img"]){
        theClassName.img=dic[@"img"];
    }
    if (dic[@"homeworkname"]){
        theClassName.homeworkname=dic[@"homeworkname"];
    }
    if (dic[@"havehomework"]){
        [theClassName removeHavehomework:theClassName.havehomework];
        NSSet *homeworkTypes = dic[@"havehomework"];
        [theClassName addHavehomework:homeworkTypes];
    }
    
    NSError *error;
    if (![dbcx save:&error]) {
        NSLog(@"修改过程中发生错误,错误信息：%@",error.localizedDescription);
        return false;
    }
    return true;
}

#pragma mark 根据字典删除

+(bool)removeClassName:(ClassName *)classname withDbcx:(NSManagedObjectContext*)dbcx{
    [dbcx deleteObject:classname];
    NSError *error;
    if (![dbcx save:&error]) {
        NSLog(@"删除过程中发生错误，错误信息：%@!",error.localizedDescription);
        return false;
    }
    return true;
}

@end
