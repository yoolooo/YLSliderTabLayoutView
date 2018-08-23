//
//  YLSliderView.h
//  YLSliderTabberView
//
//  Created by yan on 2018/8/22.
//  Copyright © 2018年 yanlong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YLSliderView;

@protocol YLSliderViewDataSource <NSObject>
@required
- (NSInteger)numberOfControllersInSliderView:(YLSliderView*)sliderView;
- (UIViewController*)ylSliderView:(YLSliderView*)sliderView controllerAtIndex:(NSInteger)index;
@end


@protocol YLSliderViewDelegate <NSObject>

- (void)ylSlideView:(YLSliderView *)sliderView switchingFrom:(NSInteger)oldIndex to:(NSInteger)toIndex percent:(float)percent;
- (void)ylSlideView:(YLSliderView *)sliderView didSwitchTo:(NSInteger)index;
- (void)ylSlideView:(YLSliderView *)sliderView switchCanceled:(NSInteger)oldIndex;
- (void)ylSlideView:(YLSliderView *)sliderView didSwitchToController:(UIViewController*)controller;

@end


@interface YLSliderView : UIView

@property(nonatomic, weak) UIViewController *baseViewController;
@property(nonatomic, assign) NSInteger selectedIndex;
@property(nonatomic, weak) id<YLSliderViewDelegate>delegate;
@property(nonatomic, weak) id<YLSliderViewDataSource>dataSource;

- (void)switchTo:(NSInteger)index;


@end
