//
//  AppDelegate.m
//  FishCalendar
//
//  Created by Hydra on 17/1/7.
//  Copyright © 2017年 Hydra. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate (){
    RootViewController *rtViewController;
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // 根据机型设定一些布局常量
    [self setExternWithPhoneType:[self iphoneType]];
    [Constant getSetting];
    if (isOrigin) {
        // 初次启动时，基本数据初始化
        [Constant initOriginData];
    }
    
    // 设置基本页面
    rtViewController = [[RootViewController alloc]init];
    NavController *navigationController=[[NavController alloc]initWithRootViewController:rtViewController];
    self.window.rootViewController = navigationController;

    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    // 重绘课程表
    [rtViewController removeAllCtrls];
    [rtViewController drawCalendar];
    [rtViewController addBtns];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}


#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"FishCalendar"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                    */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}









#pragma mark 自定义方法

// 获取手机型号、系统版本
- (int)iphoneType {
    
    struct utsname systemInfo;
    uname(&systemInfo);
    
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
    
    if ([platform isEqualToString:@"iPhone3,1"]) return 4;
    if ([platform isEqualToString:@"iPhone3,2"]) return 4;
    if ([platform isEqualToString:@"iPhone3,3"]) return 4;
    if ([platform isEqualToString:@"iPhone4,1"]) return 4;
    if ([platform isEqualToString:@"iPhone5,1"]) return 5;
    if ([platform isEqualToString:@"iPhone5,2"]) return 5;
    if ([platform isEqualToString:@"iPhone5,3"]) return 5;
    if ([platform isEqualToString:@"iPhone5,4"]) return 5;
    if ([platform isEqualToString:@"iPhone6,1"]) return 5;
    if ([platform isEqualToString:@"iPhone6,2"]) return 5;
    if ([platform isEqualToString:@"iPhone7,1"]) return 6;
    if ([platform isEqualToString:@"iPhone7,2"]) return 6;
    if ([platform isEqualToString:@"iPhone8,1"]) return 6;
    if ([platform isEqualToString:@"iPhone8,2"]) return 6;
    if ([platform isEqualToString:@"iPhone8,4"]) return 6;
    if ([platform isEqualToString:@"iPhone9,1"]) return 7;
    if ([platform isEqualToString:@"iPhone9,2"]) return 7;
    if ([platform isEqualToString:@"i386"])      return 0;
    if ([platform isEqualToString:@"x86_64"])    return 0;
    
    return -1;
}

// 根据机型设定一些常量
- (void)setExternWithPhoneType:(int)iphoneType {
    
    viewBounds = [[UIScreen mainScreen] bounds];
    dbcontext = [Constant createDbContext];
    kStatusBarHigh = [[UIApplication sharedApplication] statusBarFrame].size.height;
    kNavigationBarViewHigh = kStatusBarHigh + 48;
    
    kbtn1rect = CGRectMake(15, 28, 30, 30);
    kbtn2rect = CGRectMake(55, 28, 30, 30);
    kbtn3rect = CGRectMake(viewBounds.size.width - 84, 28, 30, 30);
    kbtn4rect = CGRectMake(viewBounds.size.width - 45, 28, 30, 30);
    
    // 布局常量
    if(iphoneType == 4){
        kTitleTextFontSize = 13;
        kSecTitleTextFontSize = 10;
        kInfoTextFontSize = 11;
        kLabelTextFontSize = 12;
        kLittleLabelTextFontSize = 11;
        kLeftX = 100;
        kRightX = 110;
        kCalendarxMargin = 12;
    }else if (iphoneType == 5){
        kTitleTextFontSize = 14;
        kSecTitleTextFontSize = 10;
        kInfoTextFontSize = 12;
        kLabelTextFontSize = 13;
        kLittleLabelTextFontSize = 12;
        kLeftX = 110;
        kRightX = 123;
        kCalendarxMargin = 13;
    }else if (iphoneType == 6){
        kTitleTextFontSize = 16;
        kSecTitleTextFontSize = 11;
        kInfoTextFontSize = 13;
        kLabelTextFontSize = 15;
        kLittleLabelTextFontSize = 13;
        kLeftX = 120;
        kRightX = 134;
        kCalendarxMargin = 15;
    }else if (iphoneType == 7){
        kTitleTextFontSize = 17;
        kSecTitleTextFontSize = 12;
        kInfoTextFontSize = 14;
        kLabelTextFontSize = 17;
        kLittleLabelTextFontSize = 14;
        kLeftX = 130;
        kRightX = 148;
        kCalendarxMargin = 16;
    }else{
        // 默认以6为准
        kTitleTextFontSize = 16;
        kSecTitleTextFontSize = 11;
        kInfoTextFontSize = 13;
        kLabelTextFontSize = 15;
        kLittleLabelTextFontSize = 13;
        kLeftX = 120;
        kRightX = 134;
        kCalendarxMargin = 15;
    }
    
}

@end
