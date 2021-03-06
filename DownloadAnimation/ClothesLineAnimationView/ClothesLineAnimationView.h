//
//  ClothesLineAnimationView.h
//  DownloadAnimation
//
//  Created by 曹  on 15/9/14.
//  Copyright (c) 2015年 com.cc.max. All rights reserved.
// test for git

#import <UIKit/UIKit.h>

@interface ClothesLineAnimationView : UIView
@property(nonatomic,assign) float value;// default 0.0. this value will be pinned to min/max
@property(nonatomic,assign) float minimumValue;// default 0.0. the current value may change if outside new min value
@property(nonatomic,assign) float maximumValue;// default 1.0. the current value may change if outside new max value

- (instancetype)initWithFrame:(CGRect)frame;
- (void)failedAnimation;
- (void)resetAnimation;
@end
