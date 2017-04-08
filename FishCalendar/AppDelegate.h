//
//  AppDelegate.h
//  FishCalendar
//
//  Created by Hydra on 17/1/7.
//  Copyright © 2017年 Hydra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <sys/utsname.h>

#import "Constant.h"
#import "NavController.h"
#import "RootViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    
}

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

// 全局变量
extern CGRect viewBounds;
extern NSManagedObjectContext* dbcontext;
extern int kStatusBarHigh;
extern int kNavigationBarViewHigh;

extern bool isOrigin;
extern int kTitleTextFontSize;
extern int kSecTitleTextFontSize;
extern int kInfoTextFontSize;
extern int kLabelTextFontSize;
extern int kLittleLabelTextFontSize;
extern int kLeftX;
extern int kRightX;
extern int kCalendarxMargin;

extern CGRect kbtn1rect;
extern CGRect kbtn2rect;
extern CGRect kbtn3rect;
extern CGRect kbtn4rect;

extern NSMutableDictionary *ksettingsAll;
extern NSString *kclassFontName;
extern NSString *kclassBgName;

- (void)saveContext;

@end

