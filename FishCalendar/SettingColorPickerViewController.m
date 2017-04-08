//
//  ColorPickerViewController.m
//  参数设置-颜色设置
//
//  Created by Hydra on 17/3/12.
//  Copyright © 2017年 Hydra. All rights reserved.
//

#import "SettingColorPickerViewController.h"
#import <HRColorPickerView.h>

#import "RootViewController.h"

#define kLightBGColor [UIColor colorWithRed:48/255.0 green:50/255.0 blue:86/255.0 alpha:1] // 浅色背景

@interface SettingColorPickerViewController ()

@end

@implementation SettingColorPickerViewController

- (instancetype)initWithColor:(NSString*)savedcolorstr for:(NSString *)pknum
{
    self = [super init];
    if (self) {
        _pknum = pknum;
        NSArray *array = [savedcolorstr componentsSeparatedByString:@"+"];
        if([array count] == 3){
            self.color = [UIColor colorWithRed:[array[0] doubleValue] / 255.0f green:[array[1] doubleValue] / 255.0f blue:[array[2] doubleValue] / 255.0f alpha:1];
        }else{
            self.color = [UIColor greenColor];
        }
    }
    return self;
}

// 初始化
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavigationBarView]; // 顶部栏设置
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self initColorView];// 颜色控件初始化
}

// 顶部栏设置
- (void)initNavigationBarView{
    _navigationBarView=[[UIView alloc]initWithFrame:CGRectMake(viewBounds.origin.x, viewBounds.origin.y, viewBounds.size.width, kNavigationBarViewHigh)];
    _navigationBarView.backgroundColor = kLightBGColor;
    
    // 左侧返回按钮
    UIButton *btnReturn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [btnReturn setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [btnReturn setFrame:kbtn1rect];
    [btnReturn addTarget:self action:@selector(btnBack) forControlEvents:UIControlEventTouchUpInside];
    [_navigationBarView addSubview:btnReturn];
    
    // 中部标签
    UILabel *titleL = [UILabel new];
    titleL.text = @"颜色设置";
    titleL.textColor = [UIColor whiteColor];
    titleL.font = [UIFont systemFontOfSize:17];
    CGSize infoSize=[titleL.text sizeWithAttributes:@{NSFontAttributeName:titleL.font}];
    [titleL setFrame:CGRectMake((viewBounds.size.width - infoSize.width)/2, 34, infoSize.width, infoSize.height)];
    [_navigationBarView addSubview:titleL];
    
    // 右侧返回主页按钮
    UIButton *btnHome = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [btnHome setBackgroundImage:[UIImage imageNamed:@"home.png"] forState:UIControlStateNormal];
    [btnHome setFrame:kbtn4rect];
    [btnHome addTarget:self action:@selector(btnReturnin) forControlEvents:UIControlEventTouchUpInside];
    [_navigationBarView addSubview:btnHome];
    
    [self.view addSubview:_navigationBarView];
}

// 颜色控件初始化
-(void)initColorView{
    HRColorPickerView *colorPickerView = [[HRColorPickerView alloc] init];
    colorPickerView.color = self.color;
    colorPickerView.frame = CGRectMake(viewBounds.origin.x + 10, viewBounds.origin.y + kNavigationBarViewHigh, viewBounds.size.width - 15, viewBounds.size.height*6/7 - kNavigationBarViewHigh - 10);
    [colorPickerView addTarget:self action:@selector(action:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:colorPickerView];
    
    double colorRectwidthOne = viewBounds.size.width/(2+40); // 每份4单位宽度
    UIView *whiteColorPadView = [UIView new];
    whiteColorPadView.frame = CGRectMake(viewBounds.origin.x + colorRectwidthOne, viewBounds.size.height*6/7, viewBounds.size.width - 2*colorRectwidthOne, viewBounds.size.height/7 - 20);
    whiteColorPadView.layer.borderColor = [[UIColor darkGrayColor]CGColor];
    whiteColorPadView.layer.borderWidth = 1;
    for (double i = 9; i > -1; --i) {
        UIColor *colorinRect = [UIColor colorWithWhite:i/9 alpha:1];
        UIView *colorRect = [UIView new];
        colorRect.frame = CGRectMake(0 + i*4*colorRectwidthOne, 0, colorRectwidthOne * 4, viewBounds.size.height/7 - 20);
        colorRect.userInteractionEnabled = YES;
        colorRect.backgroundColor = colorinRect;
        [whiteColorPadView addSubview:colorRect];
        
        UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapColorRect:)];
        tapGesture.numberOfTapsRequired=1;//设置点按次数，默认为1，在iOS中很少用双击操作
        tapGesture.numberOfTouchesRequired=1;//点按的手指数
        [colorRect addGestureRecognizer:tapGesture];
    }
    [self.view addSubview:whiteColorPadView];
}

// 状态栏改为亮色样式
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}






#pragma mark 自定义方法

// 颜色改变响应
-(void)action:(HRColorPickerView*)colorPV{
    CGFloat components[3];
    [self getRGBComponents:components forColor:colorPV.color];
    NSString *colorstr = [NSString stringWithFormat:@"%f+%f+%f",components[0],components[1],components[2]];
    [_colorDelegate checkin:colorstr for:_pknum];
}

// 获取RGB值
- (void)getRGBComponents:(CGFloat [3])components forColor:(UIColor *)color {
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char resultingPixel[4];
    CGContextRef context = CGBitmapContextCreate(&resultingPixel, 1, 1, 8, 4, rgbColorSpace,(CGBitmapInfo)kCGImageAlphaNoneSkipLast);
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, CGRectMake(0, 0, 1, 1));
    CGContextRelease(context);
    CGColorSpaceRelease(rgbColorSpace);
    for (int component = 0; component < 3; component++) {
        components[component] = resultingPixel[component];
    }
}

// 点按白色颜色选择框手势事件
-(void)tapColorRect:(UITapGestureRecognizer *)gesture{
    CGFloat components[3];
    [self getRGBComponents:components forColor:gesture.view.backgroundColor];
    gesture.view.layer.borderWidth = 1;
    gesture.view.layer.borderColor = [[UIColor redColor]CGColor];
    NSString *colorstr = [NSString stringWithFormat:@"%f+%f+%f",components[0],components[1],components[2]];
    [_colorDelegate checkin:colorstr for:_pknum];
    [self btnBack];
}

// 响应按钮：关闭模态窗口
-(void)btnReturnin{
    [Constant getSetting];
    RootViewController *rootctrl = self.navigationController.viewControllers[0];
    [rootctrl removeAllCtrls];
    [rootctrl drawCalendar];
    [rootctrl addBtns];
    [rootctrl updateSumTask];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)btnBack{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
