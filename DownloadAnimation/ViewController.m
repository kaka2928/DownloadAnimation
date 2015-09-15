//
//  ViewController.m
//  DownloadAnimation
//
//  Created by 曹  on 15/9/14.
//  Copyright (c) 2015年 com.cc.max. All rights reserved.
// test for git

#import "ViewController.h"
#import "ClothesLineAnimationView.h"
@interface ViewController ()
{

    ClothesLineAnimationView *line;
}
@property (weak, nonatomic) IBOutlet UISlider *slider;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];

    line = [[ClothesLineAnimationView alloc]initWithFrame:CGRectMake(0, 200, CGRectGetWidth([[UIScreen mainScreen]bounds]),50)];
    [self.view addSubview:line];
    line.value = 0.0;
    _slider.value = 0;
    
    // Do any additional setup after loading the view, typically from a nib.
}
- (void)lineChange{

    if (line.value!=1.0) {
        line.value +=0.1;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)sliderChanged:(id)sender {
    UISlider *slider = (UISlider *)sender;
    line.value = slider.value;
}
- (IBAction)errorButton:(id)sender {
    [line failedAnimation];
}
- (IBAction)resumeButton:(id)sender {
    [line resetAnimation];
}

@end
