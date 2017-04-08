//
//  DailyLong+CoreDataClass.m
//  FishCalendar
//
//  Created by Hydra on 17/3/3.
//  Copyright © 2017年 Hydra. All rights reserved.
//

#import "DailyLong+CoreDataClass.h"

@implementation DailyLong

#pragma mark 根据字典增

+(DailyLong *)addWithDictionary:(NSDictionary *)dic withDbcx:(NSManagedObjectContext*)dbcx{
    DailyLong *theDaily= [NSEntityDescription insertNewObjectForEntityForName:@"DailyLong" inManagedObjectContext:dbcx];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    if (dic[@"name"]) {
        theDaily.name=dic[@"name"];
    }
    if (dic[@"imgname"]){
        theDaily.imgname=dic[@"imgname"];
    }
    if (dic[@"info"]){
        theDaily.info=dic[@"info"];
    }
    if (dic[@"havedone"]){
        theDaily.havedone= [NSNumber numberWithDouble:[dic[@"havedone"] doubleValue]];
    }
    if(dic[@"recentdate"]){
        theDaily.recentdate=[dateFormatter dateFromString:dic[@"recentdate"]];
    }
    if(dic[@"isvalid"] != nil){
        theDaily.isvalid= [NSNumber numberWithInt:[dic[@"isvalid"] intValue]];
    }else{
        theDaily.isvalid= @1;
    }
    if(dic[@"fromdate"]){
        theDaily.fromdate=[dateFormatter dateFromString:dic[@"fromdate"]];
    }else if(dic[@"recentdate"]){
        theDaily.fromdate = theDaily.recentdate; // 初始默认fromdate即recentdate
    }
    if(dic[@"todate"]){
        theDaily.todate=[dateFormatter dateFromString:dic[@"todate"]];
    }
    
    NSError *error;
    if (![dbcx save:&error]) {
        NSLog(@"添加过程中发生错误,错误信息：%@！",error.localizedDescription);
    }
    return theDaily;
}

#pragma mark 根据字典改

// 修改，字典中需要条件 TODO
+(void)modifyDaily:(DailyLong *)theDaily withDictionary:(NSDictionary *)dic withDbcx:(NSManagedObjectContext*)dbcx{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    if (dic[@"name"]) {
        theDaily.name=dic[@"name"];
    }
    if (dic[@"imgname"]){
        theDaily.imgname=dic[@"imgname"];
    }
    if (dic[@"info"]){
        theDaily.info=dic[@"info"];
    }
    if (dic[@"havedone"]){
        theDaily.havedone= [NSNumber numberWithDouble:[dic[@"havedone"] doubleValue]];
    }
    if(dic[@"recentdate"]){
        theDaily.recentdate=[dateFormatter dateFromString:dic[@"recentdate"]];
    }
    if(dic[@"isvalid"]){
        theDaily.isvalid= [NSNumber numberWithInt:[dic[@"isvalid"] intValue]];
    }
    if(dic[@"fromdate"]){
        theDaily.fromdate=[dateFormatter dateFromString:dic[@"fromdate"]];
    }
    if(dic[@"todate"]){
        theDaily.todate=[dateFormatter dateFromString:dic[@"todate"]];
    }
    
    NSError *error;
    if (![dbcx save:&error]) {
        NSLog(@"修改过程中发生错误,错误信息：%@",error.localizedDescription);
    }
}

#pragma mark 根据字典删除

+ (bool)removeDailyLong:(DailyLong *)dailylong withDbcx:(NSManagedObjectContext*)dbcx{
    [dbcx deleteObject:dailylong];
    NSError *error;
    if (![dbcx save:&error]) {
        NSLog(@"删除过程中发生错误，错误信息：%@!",error.localizedDescription);
        return false;
    }
    return true;
}

#pragma mark 将当前recentdate推进一天/到某天

+ (void)pushRecentdateIn:(DailyLong *)theDaily WithDbcx:(NSManagedObjectContext*)dbcx{
    theDaily.recentdate = [[NSDate alloc] initWithTimeInterval:3600*24 sinceDate:theDaily.recentdate];
    
    NSError *error;
    if (![dbcx save:&error]) {
        NSLog(@"修改过程中发生错误,错误信息：%@",error.localizedDescription);
    }
}

+ (void)pushRecentdateIn:(DailyLong *)theDaily WithDbcx:(NSManagedObjectContext*)dbcx toDate:(NSDate*)todate{
    theDaily.recentdate = [[NSDate alloc] initWithTimeInterval:3600*24 sinceDate:todate];
    
    NSError *error;
    if (![dbcx save:&error]) {
        NSLog(@"修改过程中发生错误,错误信息：%@",error.localizedDescription);
    }
}

@end
