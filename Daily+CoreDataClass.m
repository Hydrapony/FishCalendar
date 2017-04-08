//
//  Daily+CoreDataClass.m
//  FishCalendar
//
//  Created by Hydra on 17/2/21.
//  Copyright © 2017年 Hydra. All rights reserved.
//

#import "Daily+CoreDataClass.h"

@implementation Daily

#pragma mark 根据字典增

+(Daily *)addWithDictionary:(NSDictionary *)dic withDbcx:(NSManagedObjectContext*)dbcx{
    Daily *theDaily= [NSEntityDescription insertNewObjectForEntityForName:@"Daily" inManagedObjectContext:dbcx];
    //通过上面的代码可以得到Daily这个表的指定实例，然后可以使用这个实例去为表中的属性赋值
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
    if(dic[@"enddate"]){
        theDaily.enddate=[dateFormatter dateFromString:dic[@"enddate"]];
    }
    if(dic[@"isvalid"] != nil){
        theDaily.isvalid= [NSNumber numberWithInt:[dic[@"isvalid"] intValue]];
    }else{
        theDaily.isvalid= @1;
    }
    if(dic[@"fromdate"]){
        theDaily.fromdate=[dateFormatter dateFromString:dic[@"fromdate"]];
    }
    if(dic[@"todate"]){
        theDaily.todate=[dateFormatter dateFromString:dic[@"todate"]];
    }
    if(dic[@"isdaily"]!= nil){
        theDaily.isdaily= [NSNumber numberWithBool:[dic[@"isdaily"] boolValue]];
    }else{
        theDaily.isdaily= @0;
    }
    
    NSError *error;
    if (![dbcx save:&error]) {
        NSLog(@"添加过程中发生错误,错误信息：%@！",error.localizedDescription);
    }
    return theDaily;
}

#pragma mark 根据字典改

// 修改，字典中需要条件 TODO
+(void)modifyDaily:(Daily *)theDaily withDictionary:(NSDictionary *)dic withDbcx:(NSManagedObjectContext*)dbcx{
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
    if(dic[@"enddate"]){
        theDaily.enddate=[dateFormatter dateFromString:dic[@"enddate"]];
    }
    if(dic[@"isvalid"]){
        theDaily.isvalid= [NSNumber numberWithInt:[dic[@"isvalid"] intValue]];
    }
    if(dic[@"fromdate"]){
        theDaily.enddate=[dateFormatter dateFromString:dic[@"fromdate"]];
    }
    if(dic[@"todate"]){
        theDaily.todate=[dateFormatter dateFromString:dic[@"todate"]];
    }
    if(dic[@"isdaily"]!= nil){
        theDaily.isdaily= [NSNumber numberWithBool:[dic[@"isdaily"] boolValue]];
    }
    
    NSError *error;
    if (![dbcx save:&error]) {
        NSLog(@"修改过程中发生错误,错误信息：%@",error.localizedDescription);
    }
}

#pragma mark 根据DailyLong对象增

+(Daily *)addWithDailyLong:(DailyLong *)dl withDbcx:(NSManagedObjectContext*)dbcx{
    Daily *theDaily= [NSEntityDescription insertNewObjectForEntityForName:@"Daily" inManagedObjectContext:dbcx];
    theDaily.name = dl.name;
    theDaily.imgname = dl.imgname;
    theDaily.enddate = dl.recentdate;
    theDaily.isvalid = @1;
    theDaily.havedone = dl.havedone;
    theDaily.info = dl.info;
    
    NSError *error;
    if (![dbcx save:&error]) {
        NSLog(@"添加过程中发生错误,错误信息：%@！",error.localizedDescription);
    }
    return theDaily;
}

@end
