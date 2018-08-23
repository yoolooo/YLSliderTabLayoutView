//
//  YLCache.h
//  YLSliderTabberView
//
//  Created by yan on 2018/8/23.
//  Copyright © 2018年 yanlong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YLCacheProtocol.h"

@interface YLCache : NSObject <YLCacheProtocol>

- (instancetype)initWithCount:(NSInteger)count;
- (void)clearCache;

@end
