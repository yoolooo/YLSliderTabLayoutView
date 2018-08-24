//
//  YLSliderTabbar.h
//  YLSliderTabberView
//
//  Created by yan on 2018/8/21.
//  Copyright © 2018年 yanlong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YLSliderTabbarProtocol.h"


/**
 滑块样式

 - YLSliderTabbarTrackTypeRound: 椭圆背景
 - YLSliderTabbarTrackTypeUnderLine: 底部横线
 - YLSliderTabbarTrackTypeBackground: 全覆盖背景色
 */
typedef NS_ENUM(NSInteger,YLSliderTabbarTrackType) {
    YLSliderTabbarTrackTypeRound,
    YLSliderTabbarTrackTypeUnderLine,
    YLSliderTabbarTrackTypeBackground,
};


@interface YLTabbarItem : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) CGFloat width;

+ (instancetype)itemWithTitle:(NSString *)title width:(CGFloat)width;

@end




@interface YLSliderTabbar : UIView<YLSliderTabbarProtocol>

@property(nonatomic, strong) UIView *backgroundView;

@property (nonatomic, strong) UIColor *tabItemNormalColor;
@property (nonatomic, strong) UIColor *tabItemSelectedColor;
@property (nonatomic, assign) CGFloat tabItemNormalFontSize;
@property (nonatomic, assign) CGFloat tabItemSelectedFontSize;
@property(nonatomic, strong) UIColor *trackColor;
@property(nonatomic, strong) NSArray <YLTabbarItem*>*tabbarItems;

@property (nonatomic,strong) UIColor *trackBoardColor;

@property(nonatomic, assign) NSInteger selectedIndex;
@property(nonatomic, readonly) NSInteger tabbarCount;
@property (nonatomic, assign) id<YLSlideTabbarDelegate> delegate;


@property(nonatomic, assign) YLSliderTabbarTrackType trackType;

@end
