//
//  YLCacheProtocol.h
//  YLSliderTabberView
//
//  Created by yan on 2018/8/23.
//  Copyright © 2018年 yanlong. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol YLCacheProtocol <NSObject>

- (void)setObject:(id)object forKey:(NSString *)key;
- (id)objectForKey:(NSString*)key;

@end
