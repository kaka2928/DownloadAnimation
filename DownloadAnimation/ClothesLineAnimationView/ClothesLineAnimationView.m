//
//  ClothesLineAnimationView.m
//  DownloadAnimation
//
//  Created by 曹  on 15/9/14.
//  Copyright (c) 2015年 com.cc.max. All rights reserved.
//

#import "ClothesLineAnimationView.h"
#import "ProcessIndicatorView.h"
#import <QuartzCore/QuartzCore.h>
static const float HORIZONTALSECTIONRATIO = 0.0625;
static const float VERTICALSECTIONRATIO = 0.66;
@interface  ClothesLineAnimationView()
{
    CGPoint turningPoint , startPoint, endPoint;
    UIBezierPath* aPath;
    CAShapeLayer *pathLayer;
    int CLOTHESLINEWIDTH;
    CAShapeLayer *failedLayer;
    BOOL isfailed;
    
}
@property (nonatomic ,strong) ProcessIndicatorView *indicatorView;

@end

@implementation ClothesLineAnimationView
- (instancetype)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {
//        self.layer.borderColor = [[UIColor redColor]CGColor];
//        self.layer.borderWidth = 2.0;
        CLOTHESLINEWIDTH = frame.size.height/10;
        self.backgroundColor = [[UIColor alloc]initWithRed:178.0/255 green:84.0/255 blue:17.0/255 alpha:1.0];
        self.layer.cornerRadius = (int)(CLOTHESLINEWIDTH);
        aPath = [UIBezierPath bezierPath];
        startPoint = CGPointMake(frame.origin.x+(frame.size.width)*HORIZONTALSECTIONRATIO, frame.size.height*VERTICALSECTIONRATIO - CLOTHESLINEWIDTH);
        endPoint = CGPointMake(frame.origin.x+(frame.size.width)*(1-HORIZONTALSECTIONRATIO), frame.size.height*VERTICALSECTIONRATIO - CLOTHESLINEWIDTH);
        turningPoint = startPoint;
        self.minimumValue = 0.0;
        self.maximumValue = 1.0;
        self.value = 0.0;
        isfailed = NO;
        self.indicatorView = [[ProcessIndicatorView alloc]initWithFrame:CGRectMake(0, frame.size.height*(1-VERTICALSECTIONRATIO)-CLOTHESLINEWIDTH, (frame.size.width)*HORIZONTALSECTIONRATIO*2, frame.size.height*(1-VERTICALSECTIONRATIO) + CLOTHESLINEWIDTH)];
        [self insertSubview:self.indicatorView atIndex:0];
        failedLayer = nil;
    }
    
    return self;
}
- (void)setValue:(float)value{

    _value = value;
    if (failedLayer!=nil) {
        [failedLayer removeFromSuperlayer];
        failedLayer = nil;
    }
    if (_value == _minimumValue) {
        turningPoint = startPoint;
    }else if(_value == _maximumValue){
        turningPoint = endPoint;
    }else{
        turningPoint = CGPointMake(self.frame.origin.x+(self.frame.size.width)*HORIZONTALSECTIONRATIO+(self.frame.size.width)*(1-HORIZONTALSECTIONRATIO*2)*_value, self.frame.size.height - CLOTHESLINEWIDTH);
    }
    [self.indicatorView moveToPoint:CGPointMake(turningPoint.x, turningPoint.y - CLOTHESLINEWIDTH/2)];
    self.indicatorView.value = _value;
    /**
     *  不要直接调用 drawRect:(CGRect)rect 会报错，可能是UIView正在绘制
     */
    [self setNeedsDisplay];
//    [self drawRect:self.frame];
}
- (void)failedAnimation{
    [self.indicatorView fail];
    isfailed = YES;
    /**
     *  不要直接调用 drawRect:(CGRect)rect 会报错，可能是UIView正在绘制
     */
    [self setNeedsDisplay];
}
- (void)resetAnimation{
    
    self.value = 0;
    isfailed = NO;
    self.indicatorView.value = 0;
}
- (void)drawRect:(CGRect)rect {
 
    [aPath removeAllPoints];
    
    UIColor *color = [UIColor clearColor];
    [color set]; // 隐藏path
   
    [aPath moveToPoint:startPoint];
    
    [aPath addLineToPoint:turningPoint];
    [aPath addLineToPoint:endPoint];
    
    [aPath stroke];//Draws line 根据坐标点连线
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    if (isfailed) {

        failedLayer = pathLayer;//保留前一次绘制layer，改变颜色，在reset中删除该layer的绘制
        
        pathLayer = [CAShapeLayer layer];

        pathLayer.strokeColor = [[UIColor grayColor] CGColor];


        pathAnimation.duration = 1.0;

    }else{

        [pathLayer removeFromSuperlayer];//删除前一次绘制的layer，重新绘制
        pathLayer = [CAShapeLayer layer];

        pathLayer.strokeColor = [[[UIColor alloc]initWithRed:77.0/255 green:127.0/255 blue:229.0/255 alpha:1.0] CGColor];


        pathAnimation.duration = 0.01;
        
    }
    pathLayer.frame = self.bounds;
    pathLayer.path = aPath.CGPath;
    pathLayer.fillColor = nil;//不需要填充颜色
    pathLayer.lineWidth = CLOTHESLINEWIDTH;
    pathLayer.lineJoin = kCALineJoinRound;
    pathLayer.lineCap = kCALineCapRound;
    [self.layer insertSublayer:pathLayer below:self.indicatorView.layer];//放在 indicatorView.layer 下层，避免遮挡
    
    pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
    [pathLayer addAnimation:pathAnimation forKey:@"strokeEnd"];
    
    
    
}


@end
