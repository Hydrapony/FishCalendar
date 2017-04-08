//
//  NavController.m
//  根Navigation控制器
//
//  Created by Hydra on 17/3/9.
//  Copyright © 2017年 Hydra. All rights reserved.
//

#import "NavController.h"

@interface NavController ()<UIGestureRecognizerDelegate>

@end

@implementation NavController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 将系统的边缘滑动手势关闭
    UIGestureRecognizer *gesture = self.interactivePopGestureRecognizer;
    gesture.enabled = NO;
    
    UIView *gestureView = gesture.view;
    
    // 添加自己的滑动手势
    UIPanGestureRecognizer *popRecognizer = [[UIPanGestureRecognizer alloc] init];
    popRecognizer.delegate = self;
    popRecognizer.maximumNumberOfTouches = 1;
    [gestureView addGestureRecognizer:popRecognizer];

    //获取系统手势的target数组
    NSMutableArray *_targets = [gesture valueForKey:@"_targets"];
    id gestureRecognizerTarget = [_targets firstObject];
    id navigationInteractiveTransition = [gestureRecognizerTarget valueForKey:@"_target"];
    SEL handleTransition = NSSelectorFromString(@"handleNavigationTransition:");
    [popRecognizer addTarget:navigationInteractiveTransition action:handleTransition];

}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    //这里有两个条件不允许手势执行，1、当前控制器为根控制器；2、如果这个push、pop动画正在执行（私有属性）
    return self.viewControllers.count != 1 && ![[self valueForKey:@"_isTransitioning"] boolValue];
}


@end
