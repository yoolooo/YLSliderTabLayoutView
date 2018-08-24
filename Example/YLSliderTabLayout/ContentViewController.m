//
//  ContentViewController.m
//  YLSliderTabberView
//
//  Created by yan on 2018/8/23.
//  Copyright © 2018年 yanlong. All rights reserved.
//

#import "ContentViewController.h"

@interface ContentViewController ()

@property (nonatomic, weak) UILabel *label;

@end

@implementation ContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.textColor = [UIColor redColor];
    label.font = [UIFont systemFontOfSize:20];
    label.textAlignment = NSTextAlignmentCenter;
    self.label = label;
    [self.view addSubview:label];
    
    NSLog(@"viewDidLoad");
    
}

- (void)setTitleString:(NSString *)titleString{
    self.label.text = titleString;
    [self.label sizeToFit];
    self.label.center = self.view.center;
}

- (void)dealloc{
    NSLog(@"dealloc--%@",self);
}

@end
