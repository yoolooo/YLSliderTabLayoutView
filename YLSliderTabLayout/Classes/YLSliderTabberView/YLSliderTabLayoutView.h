//
//  YLSliderTabLayoutView.h
//  YLSliderTabberView
//
//  Created by yan on 2018/8/23.
//  Copyright © 2018年 yanlong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YLSliderTabbarProtocol.h"
#import "YLCacheProtocol.h"

@class YLSliderTabLayoutView;

@protocol YLSliderTabLayoutViewDelegate <NSObject>
@required
- (NSInteger)numberOfTabsInTabLayoutView:(YLSliderTabLayoutView*)tabLayoutView;
- (UIViewController*)ylSliderTabLayoutView:(YLSliderTabLayoutView*)tabLayoutView controllerAt:(NSInteger)index;
@optional
- (void)ylSliderTabLayoutView:(YLSliderTabLayoutView*)tabLayoutView didSelectedIndex:(NSInteger)index;
- (void)ylSliderTabLayoutView:(YLSliderTabLayoutView*)tabLayoutView didSelectedController:(UIViewController*)controller;

@end


@interface YLSliderTabLayoutView : UIView

@property (nonatomic, weak)     UIView<YLSliderTabbarProtocol> *tabbar;
@property (nonatomic, strong)   id<YLCacheProtocol> cache;
@property(nonatomic, assign)    CGFloat tabbarBottomSpacing;
@property (nonatomic, weak)     UIViewController *baseViewController;
@property (nonatomic, assign)   NSInteger selectedIndex;
@property (nonatomic, weak)     id<YLSliderTabLayoutViewDelegate> delegate;

- (void)setup;

@end
