//
//  YBWaterView.m
//  Water Waves
//
//  Created by yb on 15-5-8.
//  Copyright (c) 2015年 Veari. All rights reserved.
//

#import "YBWaterView.h"

@interface YBWaterView ()
{
    UIColor *_currentWaterColor;
    UILabel *_currentWaterLevel; // [0~100]
    
    float _currentLinePointY;
    
    float a; // 水波上下辐度
    float b; // 正弦位移
    float c; // 水波高度 [-r ~ r]
    float r; // 水钟半径
    float margin; // 水钟边界大小
    
    BOOL jia;
    BOOL shen;  // 水位自动升降标记，YES 升， NO, 降
}
@end

@implementation YBWaterView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setBackgroundColor:[UIColor clearColor]];
        self.layer.borderWidth = 1;
        self.layer.borderColor = [[UIColor blackColor] CGColor];
        
        a = 1.5;
        b = 0;
        r = frame.size.width/2;
        
        jia = NO;
        
        _currentWaterColor = [UIColor colorWithRed:86/255.0f green:202/255.0f blue:139/255.0f alpha:1];
        _currentLinePointY = frame.size.height/2;  // 水钟位置
        _currentWaterLevel = [[UILabel alloc] init];
        _currentWaterLevel.textColor = [UIColor orangeColor];
        _currentWaterLevel.font = [UIFont boldSystemFontOfSize:frame.size.width/3];
        _currentWaterLevel.textAlignment = NSTextAlignmentCenter;
        _currentWaterLevel.text = @"100";
        
        self.autoAnimate = YES;
        
        [_currentWaterLevel sizeToFit];
        [_currentWaterLevel setCenter:CGPointMake(self.frame.size.width/2, self.frame.size.height/2)];
        [self addSubview:_currentWaterLevel];
        
        [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(animateWave) userInfo:nil repeats:YES];
        
    }
    return self;
}

-(void)animateWave
{
    // a
    if (jia) {
        a += 0.05;
    }else{
        a -= 0.05;
    }
    
    
    if (a<=5) {
        jia = YES;
    }
    
    if (a>=10) {
        jia = NO;
    }
    
    // b
    b+=0.3;
    
    if (self.autoAnimate) {
        // c
        if (shen) {
            c += r * 0.01;
        }else{
            c -= r * 0.01;
        }
        
        if (c >= r) {
            shen = NO;
        }
        
        if (c <= -r) {
            shen = YES;
        }
        
        self.waterlevel = (int)((c+r)/(2*r) * 100);
    }else{
        
        int currentWaterLevel = (int)((c+r)/(2*r) * 100);
        
        if (currentWaterLevel > self.waterlevel) {
            c -= r * 0.01;
        }
        
        if (currentWaterLevel < self.waterlevel) {
            c += r * 0.01;
        }
    }
    
    _currentWaterLevel.text = [NSString stringWithFormat:@"%d", (int)((c+r)/(2*r) * 100)];
    
    [self setNeedsDisplay];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGContextSetFillColorWithColor(context, [_currentWaterColor CGColor]); // 指定颜色
    CGContextFillEllipseInRect(context, CGRectMake(rect.size.width/2-r+10, rect.size.height/2-r+10, 2*r-20, 2*r-20));
    
    //画水
    CGContextSetFillColorWithColor(context, [[UIColor whiteColor] CGColor]); // 指定颜色
    CGContextSetLineWidth(context, 1); // 指定宽度
    
    float y=_currentLinePointY; // 水钟中心高度
    
    CGPathMoveToPoint(path, NULL, 0, _currentLinePointY - 7.5);  // 移动虚拟笔到起点
    
    for(float x=rect.size.width/2-r; x<=rect.size.width/2 + r; x++){
        y= a * sin( x/180*M_PI + 4*b/M_PI ) + _currentLinePointY -7.5;  // a是幅度，b是位移
        
        CGPathAddLineToPoint(path, nil, x, y - c); // 从上一终点绘制到目标点
    }
    
    CGPathAddLineToPoint(path, nil, rect.size.width, rect.size.height/2-r);
    CGPathAddLineToPoint(path, nil, 0, rect.size.height/2-r);
    CGPathAddLineToPoint(path, nil, 0, _currentLinePointY - 7.5);
    
    CGContextAddPath(context, path);
    CGContextFillPath(context);
    CGContextDrawPath(context, kCGPathStroke);
    CGPathRelease(path);

    
}


@end
