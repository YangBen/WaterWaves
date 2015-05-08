//
//  YBViewController.h
//  Water Waves
//
//  Created by yb on 15-5-8.
//  Copyright (c) 2015年 Veari. All rights reserved.
//

#import "YBViewController.h"
#import "YBWaterView.h"

@interface YBViewController ()
{
    YBWaterView *_waterView;
}
@end

@implementation YBViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _waterView = [[YBWaterView alloc]initWithFrame:CGRectMake(10, 20, 300, 300)];
    
    [self.view addSubview:_waterView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions
- (IBAction)actionSet90:(id)sender {
    [_waterView setAutoAnimate:NO];
    [_waterView setWaterlevel:90];
}

- (IBAction)actionStopStart:(id)sender {
    [_waterView setAutoAnimate:!_waterView.autoAnimate];
}


@end
