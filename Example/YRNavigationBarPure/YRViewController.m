//
//  YRViewController.m
//  YRNavigationBarPure
//
//  Created by zongmumask on 09/02/2020.
//  Copyright (c) 2020 zongmumask. All rights reserved.
//

#import "YRViewController.h"
#import <UIViewController+PureTransition.h>

@interface YRViewController ()

@property (nonatomic, weak) IBOutlet UISwitch *hiddenSwitch;

@end

@implementation YRViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Hello";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = [self randomColor];
}

- (IBAction)next:(id)sender
{
    YRViewController *vc = [YRViewController new];
    vc.yr_prefersNavigationBarHidden = self.hiddenSwitch.on;
    [self.navigationController pushViewController:vc animated:YES];
}

- (UIColor *)randomColor
{
    CGFloat red = arc4random() % 256 / 255.0;
    CGFloat green = arc4random() % 256 / 255.0;
    CGFloat blue = arc4random() % 256 / 255.0;
    return [UIColor colorWithRed:red green:green blue:blue alpha:1];
}

@end
