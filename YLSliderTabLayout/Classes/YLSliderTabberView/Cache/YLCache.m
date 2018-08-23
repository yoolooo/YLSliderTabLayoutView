//
//  YLCache.m
//  YLSliderTabberView
//
//  Created by yan on 2018/8/23.
//  Copyright © 2018年 yanlong. All rights reserved.
//

#import "YLCache.h"

@implementation YLCache
{
    NSMutableDictionary *_dic;
    NSMutableArray *_keyList;
    NSInteger _capacity;
}

- (instancetype)initWithCount:(NSInteger)count{
    if (self = [super init]) {
        _capacity = count;
        _dic = [NSMutableDictionary dictionaryWithCapacity:_capacity];
        _keyList = [NSMutableArray arrayWithCapacity:_capacity];
    }
    return self;
}

- (void)setObject:(id)object forKey:(NSString *)key{
    if (![_keyList containsObject:key]) {
        if (_keyList.count < _capacity) {
            [_dic setValue:object forKey:key];
            [_keyList addObject:key];
        }else{
            NSString *unusedKey = _keyList.firstObject;
            [_dic setValue:nil forKey:unusedKey];
            [_keyList removeObjectAtIndex:0];
            [_dic setValue:object forKey:key];
        }
    }else{
        [_dic setValue:object forKey:key];
        [_keyList removeObject:key];
        [_keyList addObject:key];
    }
}

- (id)objectForKey:(NSString *)key{
    if ([_keyList containsObject:key]) {
        [_keyList removeObject:key];
        [_keyList addObject:key];
        return [_dic objectForKey:key];
    }else{
        return nil;
    }
}

- (void)clearCache{
    [_keyList removeAllObjects];
    [_dic removeAllObjects];
}


@end


