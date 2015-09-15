//
//  ProcessIndicatorView.m
//  DownloadAnimation
//
//  Created by caochao on 15/9/15.
//  Copyright (c) 2015年 com.cc.max. All rights reserved.
//

#import "ProcessIndicatorView.h"
#import <QuartzCore/QuartzCore.h>
static const float VERTICALSECTIONRATIO = 0.75;
@interface ProcessIndicatorView ()
@property (nonatomic , strong) CALayer *topLayer;
@property (nonatomic , strong) CAShapeLayer *bottomLayer;
@property (nonatomic , strong) UILabel *percentageLabel;

@end

@implementation ProcessIndicatorView

- (instancetype)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {
        
        self.minimumValue = 0;
        self.maximumValue = 1;
        self.value = 0;
        self.topLayer = [CALayer layer];
        self.topLayer.backgroundColor = [UIColor colorWithWhite:1 alpha:1].CGColor;
        self.topLayer.position = CGPointMake(CGRectGetWidth(frame)/2, VERTICALSECTIONRATIO * CGRectGetHeight(frame)/2);
        self.topLayer.bounds = CGRectMake(0, 0, CGRectGetWidth(frame), VERTICALSECTIONRATIO * CGRectGetHeight(frame));
        self.topLayer.cornerRadius = 2.f;
        [self.layer addSublayer:self.topLayer];
        
        self.bottomLayer = [CAShapeLayer layer];
        UIBezierPath *bottomBezierPath = [UIBezierPath bezierPath];
        [bottomBezierPath moveToPoint:CGPointMake(CGRectGetWidth(frame)/3, VERTICALSECTIONRATIO * CGRectGetHeight(frame)-2)];//point 高度减去2 使得两个layer镶嵌在一起
        [bottomBezierPath addLineToPoint:CGPointMake(CGRectGetWidth(frame)/2, CGRectGetHeight(frame))];
        [bottomBezierPath addLineToPoint:CGPointMake(CGRectGetWidth(frame)*(2.0/3), VERTICALSECTIONRATIO * CGRectGetHeight(frame)-2)];
        [bottomBezierPath closePath];
        self.bottomLayer.path = bottomBezierPath.CGPath;
        self.bottomLayer.fillColor = [UIColor colorWithWhite:1 alpha:1].CGColor;
        [self.layer addSublayer:self.bottomLayer];

        
        self.percentageLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), VERTICALSECTIONRATIO * CGRectGetHeight(frame))];
        self.percentageLabel.textAlignment = NSTextAlignmentCenter;
        self.percentageLabel.font = [UIFont fontWithName:@"CourierNewPS-BoldMT" size:(int)(VERTICALSECTIONRATIO * CGRectGetHeight(frame)-3)];
        [self addSubview:self.percentageLabel];
                                                                       
    }
    
    return self;
}
- (void)setValue:(float)value{

    _value = value;
     self.percentageLabel.textColor = [UIColor blackColor];
    [self.percentageLabel setText:[NSString stringWithFormat:@"%d%%",(int)(value*100)]];
}
- (void)fail{

    CABasicAnimation* rotationAnimation =
    [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];//"z"还可以是“x”“y”，表示沿z轴旋转
    rotationAnimation.toValue = [NSNumber numberWithFloat:(M_PI*2)];
    rotationAnimation.duration = 1.0f;
    rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]; //缓入缓出
    
    [self.layer addAnimation:rotationAnimation forKey:@"transform.rotation.y"];
    [UIView animateWithDuration:1.0 animations:^(){
        [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y +(1-VERTICALSECTIONRATIO) * CGRectGetHeight(self.frame) , CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
        
    } completion: ^(BOOL finished){
        [self.percentageLabel setText:@"fail"];
        self.percentageLabel.textColor = [UIColor redColor];
        
    }];

    
}

- (void)moveToPoint:(CGPoint )point{
   [self setFrame:CGRectMake((point.x - CGRectGetWidth(self.frame)/2), (point.y - CGRectGetHeight(self.frame)), CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];

}
@end
