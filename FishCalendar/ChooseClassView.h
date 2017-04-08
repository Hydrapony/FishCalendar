//
//  ChooseClassView.h
//  课程选择弹框
//
//  Created by Hydra on 17/3/19.
//  Copyright © 2017年 Hydra. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Constant.h"

@interface ChooseClassView : UIView<UIPickerViewDataSource,UIPickerViewDelegate>{
    int selectnow;
}

extern CGRect viewBounds;

@property (nonatomic, strong) UIView *bgView; // 背景遮罩View

@property (weak, nonatomic) IBOutlet UIButton *okBtn;
@property (weak, nonatomic) IBOutlet UIButton *cleanBtn;
@property (nonatomic, copy) void(^selectClassBlock)(int);

@property (nonatomic, strong) NSArray *classNameArr; // 课程名称数组

- (instancetype)initWithClasses:(NSArray*)classNames;

/** 显示 */
- (void)show;
/** 隐藏 */
- (void)hide;

@end
