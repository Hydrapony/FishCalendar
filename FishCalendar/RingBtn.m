//
//  RingBtn.m
//  环形按钮（60×60）
//
//  Created by Hydra on 17/2/11.
//  Copyright © 2017年 Hydra. All rights reserved.
//

#import "RingBtn.h"

#define kMinusSliderPerCe 0.1 // 抬起后每次计时器触发减少的进度

@implementation RingBtn

#pragma mark 初始化
- (instancetype)initWithBlackColor:(UIColor*)backColor{
    self = [super init];
    if (self) {
        self.layer.delegate=self;
        [self.layer setNeedsDisplay];
        self.backgroundColor = backColor; //必须有背景色，否则不刷新
        
        if([kRingBtnTime isEqualToString:@"2"]){
            addSliderPerCe = 0.04;
        }else if([kRingBtnTime isEqualToString:@"3"]){
            addSliderPerCe = 0.06;
        }else if([kRingBtnTime isEqualToString:@"1"]){
            addSliderPerCe = 0.03;
        }
        
        // 伪进度
        numSlider = 0;
        // 按钮
        _btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btn setFrame:CGRectMake(10, 10, 40, 40)];
        [_btn setTintColor:[UIColor yellowColor]];
        [_btn setImage:[UIImage imageNamed:@"alright3mono.png"]forState:UIControlStateNormal];
        [_btn setImage:[UIImage imageNamed:@"alright3.png"]forState:UIControlStateDisabled];
        [_btn addTarget:self action:@selector(beginSet) forControlEvents:UIControlEventTouchDown];
        [_btn addTarget:self action:@selector(stopSet) forControlEvents:UIControlEventTouchUpInside];
        [_btn addTarget:self action:@selector(stopSet) forControlEvents:UIControlEventTouchUpOutside];

        [self addSubview:_btn];

    }
    return self;
}







#pragma mark 自定义方法

// 按下响应
- (void)beginSet{
    if(numSlider < 1 && ![_btntimer isValid]){
        numSlider += addSliderPerCe;
        _btntimer = [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(addRing) userInfo:nil repeats:YES];
    }
}

// 按下计时器定时触发方法
-(void)addRing{
    numSlider += addSliderPerCe;
    [self.layer setNeedsDisplay];
    if(numSlider >= 1){
        numSlider = 1;
        [_btntimer invalidate];
        [self setRingDone];
        [self.ringDelegate ringComplete:_btnInfoDic]; // 代理设置，删除行
    }
}

// 抬起响应
-(void)stopSet{
    if(numSlider < 1){
        [_btntimer invalidate];
        _btntimer = [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(secRing) userInfo:nil repeats:YES];
        [self.layer setNeedsDisplay];
    }
}

// 抬起计时器定时触发方法
-(void)secRing{
    numSlider -= kMinusSliderPerCe;
    [self.layer setNeedsDisplay];
    if(numSlider <= 0){
        numSlider = 0;
        [_btntimer invalidate];
    }
}

// 设置已完成按钮状态
-(void)setRingDone{
    [_btn setEnabled:false];
    numSlider = 0;
    [self.layer setNeedsDisplay];
}





#pragma mark layer代理

// 绘制图形、图像到图层
-(void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx{
    CGContextSaveGState(ctx);//保存初始状态
    CGPoint center = CGPointMake(30, 30);  //设置圆心位置
    CGFloat radius = 25;  //设置半径
    CGFloat startA = - M_PI_2;  //圆起点位置
    CGFloat endA = -M_PI_2 + M_PI * 2 * numSlider;  //圆终点位置
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:startA endAngle:endA clockwise:YES];
    CGContextSetLineWidth(ctx, 3); //设置线条宽度
    CGContextSetRGBStrokeColor(ctx,1,1,1,0.6);//画笔线的颜色
    CGContextAddPath(ctx, path.CGPath); //把路径添加到上下文
    CGContextStrokePath(ctx);  //渲染
    CGContextRestoreGState(ctx);
}

@end
