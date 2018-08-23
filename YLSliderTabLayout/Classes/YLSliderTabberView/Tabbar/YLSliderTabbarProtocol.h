//
//  YLSliderTabbarProtocol.h
//  YLSliderTabberView
//
//  Created by yan on 2018/8/23.
//  Copyright © 2018年 yanlong. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol YLSlideTabbarDelegate <NSObject>

- (void)ylSlideTabbar:(id)sender selectAt:(NSInteger)index;

@end

@protocol YLSliderTabbarProtocol <NSObject>

@property(nonatomic, assign)            NSInteger selectedIndex;
@property(nonatomic, assign,readonly)   NSInteger tabbarCount;
@property(nonatomic, weak)              id<YLSlideTabbarDelegate> delegate;

- (void)switchingFrom:(NSInteger)fromIndex to:(NSInteger)toIndex percent:(float)percent;

@end
