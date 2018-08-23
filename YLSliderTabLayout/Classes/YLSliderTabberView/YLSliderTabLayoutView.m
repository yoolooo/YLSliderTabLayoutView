//
//  YLSliderTabLayoutView.m
//  YLSliderTabberView
//
//  Created by yan on 2018/8/23.
//  Copyright © 2018年 yanlong. All rights reserved.
//

#import "YLSliderTabLayoutView.h"
#import "YLSliderTabbar.h"
#import "YLSliderView.h"

#define kDefaultTabbarBottomSpacing 0

@interface YLSliderTabLayoutView ()<YLSlideTabbarDelegate,YLSliderViewDataSource,YLSliderViewDelegate>

@end

@implementation YLSliderTabLayoutView
{
    YLSliderView *_sliderView;
}

- (void)initDefaultConfigure{
    self.tabbarBottomSpacing = kDefaultTabbarBottomSpacing;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self initDefaultConfigure];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initDefaultConfigure];
    }
    return self;
}

- (void)setup{
    self.tabbar.delegate = self;
    [self addSubview:self.tabbar];
    _sliderView = [[YLSliderView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.tabbar.frame)+self.tabbarBottomSpacing, self.bounds.size.width, self.bounds.size.height - CGRectGetHeight(self.tabbar.bounds)-self.tabbarBottomSpacing)];
    _sliderView.dataSource = self;
    _sliderView.delegate = self;
    _sliderView.baseViewController = self.baseViewController;
    _sliderView.selectedIndex = self.selectedIndex;
    [self addSubview:_sliderView];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.tabbar.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.tabbar.bounds));
    _sliderView.frame = CGRectMake(0, CGRectGetMaxY(self.tabbar.frame)+self.tabbarBottomSpacing, self.bounds.size.width, self.bounds.size.height - CGRectGetHeight(self.tabbar.bounds)-self.tabbarBottomSpacing);
}

- (void)setBaseViewController:(UIViewController *)baseViewController{
    _baseViewController = baseViewController;
    _sliderView.baseViewController = baseViewController;
}

- (void)setSelectedIndex:(NSInteger)selectedIndex{
    _selectedIndex = selectedIndex;
    self.tabbar.selectedIndex = selectedIndex;
    _sliderView.selectedIndex = selectedIndex;
}

#pragma mark --- YLSlideTabbarDelegate
- (void)ylSlideTabbar:(id)sender selectAt:(NSInteger)index{
    _sliderView.selectedIndex = index;
}

#pragma mark --- YLSliderViewDataSource
- (NSInteger)numberOfControllersInSliderView:(YLSliderView *)sliderView {
    return [self.delegate numberOfTabsInTabLayoutView:self];
}

- (UIViewController *)ylSliderView:(YLSliderView *)sliderView controllerAtIndex:(NSInteger)index {
    NSString *key = [NSString stringWithFormat:@"%ld",index];
    UIViewController *controller = (UIViewController*)[self.cache objectForKey:key];
    if (!controller) {
        controller = [self.delegate ylSliderTabLayoutView:self controllerAt:index];
        [self.cache setObject:controller forKey:key];
    }
    return controller;
}

- (void)ylSlideView:(YLSliderView *)sliderView didSwitchTo:(NSInteger)index {
    self.tabbar.selectedIndex = index;
    if ([self.delegate respondsToSelector:@selector(ylSliderTabLayoutView:didSelectedIndex:)]) {
        [self.delegate ylSliderTabLayoutView:self didSelectedIndex:index];
    }
}

- (void)ylSlideView:(YLSliderView *)sliderView didSwitchToController:(UIViewController *)controller {
    if ([self.delegate respondsToSelector:@selector(ylSliderTabLayoutView:didSelectedController:)]) {
        [self.delegate ylSliderTabLayoutView:self didSelectedController:controller];
    }
}

- (void)ylSlideView:(YLSliderView *)sliderView switchCanceled:(NSInteger)oldIndex {
    [self.tabbar setSelectedIndex:oldIndex];
}

- (void)ylSlideView:(YLSliderView *)sliderView switchingFrom:(NSInteger)oldIndex to:(NSInteger)toIndex percent:(float)percent {
    [self.tabbar switchingFrom:oldIndex to:toIndex percent:percent];
}


@end
