//
//  YLSliderTabbar.m
//  YLSliderTabberView
//
//  Created by yan on 2018/8/21.
//  Copyright © 2018年 yanlong. All rights reserved.
//

#import "YLSliderTabbar.h"


#define kUnderLineTrackViewHeight 3
#define kTrackViewHeight 30
#define kImageSpacingX 3.0f

#define kLabelTagBase 1000
#define kImageTagBase 2000
#define kSelectedImageTagBase 3000
#define kViewTagBase 4000

@implementation YLTabbarItem


+ (instancetype)itemWithTitle:(NSString *)title width:(CGFloat)width{
    YLTabbarItem *item = [[YLTabbarItem alloc] init];
    item.title = title;
    item.width = width;
    return item;
}

@end



@implementation YLSliderTabbar
{
    UIScrollView *_scrollView;
    UIImageView *_trackView;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _selectedIndex = -1;
        [self initView];
    }
    return self;
}

- (void)initView{
    _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    _scrollView.showsHorizontalScrollIndicator = NO;
    //ios 11
    if ([_scrollView respondsToSelector:@selector(setContentInsetAdjustmentBehavior:)]) {
        if (@available(iOS 11.0, *)) {
            _scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    [self addSubview:_scrollView];
    _trackView = [[UIImageView alloc] initWithFrame:CGRectMake(0, (self.bounds.size.height-kUnderLineTrackViewHeight), 0, kUnderLineTrackViewHeight)];
    [_scrollView addSubview:_trackView];
    _trackView.layer.cornerRadius = _trackView.bounds.size.height/2.0;
}

- (void)setTrackType:(YLSliderTabbarTrackType)trackType{
    _trackType = trackType;
    if (self.trackType==YLSliderTabbarTrackTypeUnderLine) {
        _trackView.frame = CGRectMake(0, self.bounds.size.height-kUnderLineTrackViewHeight, 0, kUnderLineTrackViewHeight);
        _trackView.layer.cornerRadius = kUnderLineTrackViewHeight/2.0;
    }else if (self.trackType == YLSliderTabbarTrackTypeRound){
        _trackView.frame = CGRectMake(-8, (self.bounds.size.height-kTrackViewHeight)/2, 0, kTrackViewHeight);
        _trackView.layer.cornerRadius = kTrackViewHeight/2.0;
    }
    else{
        _trackView.frame = CGRectMake(0, 0, 0, self.bounds.size.height);
        _trackView.layer.cornerRadius = 0;
    }
}

- (void)setBackgroundView:(UIView *)backgroundView{
    if (_backgroundView != backgroundView) {
        [_backgroundView removeFromSuperview];
        [self insertSubview:backgroundView atIndex:0];
        _backgroundView = backgroundView;
    }
}

- (void)setTabItemNormalColor:(UIColor *)tabItemNormalColor{
    _tabItemNormalColor = tabItemNormalColor;
    
    for (int i=0; i<[self tabbarCount]; i++) {
        if (i == self.selectedIndex) {
            continue;
        }
        UILabel *label = (UILabel *)[_scrollView viewWithTag:kLabelTagBase+i];
        label.textColor = tabItemNormalColor;
    }
}

- (void)setTabItemSelectedColor:(UIColor *)tabItemSelectedColor{
    _tabItemSelectedColor = tabItemSelectedColor;
    
    UILabel *label = (UILabel *)[_scrollView viewWithTag:kLabelTagBase+self.selectedIndex];
    label.textColor = tabItemSelectedColor;
}

- (void)setTrackColor:(UIColor *)trackColor{
    _trackColor = trackColor;
    _trackView.backgroundColor = trackColor;
}

- (void)setTrackBoardColor:(UIColor *)trackBoardColor
{
    _trackBoardColor = trackBoardColor;
    _trackView.layer.borderWidth = 0.5;
    _trackView.layer.borderColor = trackBoardColor.CGColor;
}

- (void)setTabbarItems:(NSArray<YLTabbarItem *> *)tabbarItems{
    if (_tabbarItems == tabbarItems) {
        return;
    }
    [_tabbarItems enumerateObjectsUsingBlock:^(YLTabbarItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIView *backView = [self->_scrollView viewWithTag:kViewTagBase+idx];
        [backView removeFromSuperview];
    }];
    _tabbarItems = tabbarItems;
    self.selectedIndex = -1;
    CGFloat height = self.bounds.size.height;
    CGFloat x = 0.0f;
    NSInteger i = 0;
    for (YLTabbarItem *item in _tabbarItems) {
        
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(x, 0, item.width, height)];
        backView.backgroundColor = [UIColor clearColor];
        backView.tag = kViewTagBase + i;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, item.width, height)];
        label.text = item.title;
        label.font = [UIFont systemFontOfSize:self.tabItemNormalFontSize];
        [label sizeToFit];
        label.center = backView.center;
        label.backgroundColor = [UIColor clearColor];
        label.textColor = self.tabItemNormalColor;
        label.textAlignment = NSTextAlignmentCenter;
        label.tag = kLabelTagBase+i;
        label.frame = CGRectMake((item.width-label.bounds.size.width)/2.0f, (height-label.bounds.size.height)/2.0f, CGRectGetWidth(label.bounds), CGRectGetHeight(label.bounds));
        
        [backView addSubview:label];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [backView addGestureRecognizer:tap];
        [_scrollView addSubview:backView];
        
        x += item.width;
        i++;
        _scrollView.contentSize = CGSizeMake(x, height);
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.backgroundView.frame = self.bounds;
    _scrollView.frame = self.bounds;
}

- (NSInteger)tabbarCount{
    return self.tabbarItems.count;
}

- (void)switchingFrom:(NSInteger)fromIndex to:(NSInteger)toIndex percent:(float)percent{
    UILabel *fromLabel = (UILabel*)[_scrollView viewWithTag:kLabelTagBase+fromIndex];
    fromLabel.textColor = [YLSliderTabbar getColorOfPercent:percent between:self.tabItemNormalColor and:self.tabItemSelectedColor];
    UILabel *toLabel = nil;
    if (toIndex >= 0 && toIndex < [self tabbarCount]) {
        toLabel = (UILabel*)[_scrollView viewWithTag:kLabelTagBase + toIndex];
        toLabel.textColor = [YLSliderTabbar getColorOfPercent:percent between:self.tabItemSelectedColor and:self.tabItemNormalColor];
    }
    CGRect fromRc = [_scrollView convertRect:fromLabel.bounds fromView:fromLabel];
    CGFloat fromWidth = fromLabel.frame.size.width;
    CGFloat fromX = fromRc.origin.x;
    
    CGFloat toX;
    CGFloat toWidth;
    if (toLabel) {
        CGRect toRc = [_scrollView convertRect:toLabel.bounds fromView:toLabel];
        toWidth = toRc.size.width;
        toX = toRc.origin.x;
    }else{
        toWidth = fromWidth;
        if (toIndex > fromIndex) {
            toX = fromX + fromWidth;
        }else{
            toX = fromX - fromWidth;
        }
    }
    CGFloat width = toWidth * percent + fromWidth*(1-percent);
    CGFloat x = fromX + (toX - fromX)*percent;
    if (self.trackType == YLSliderTabbarTrackTypeRound) {
        width += 16;
        x -= 8;
    }
    _trackView.frame = CGRectMake(x, _trackView.frame.origin.y, width, CGRectGetHeight(_trackView.bounds));
}

- (void)setSelectedIndex:(NSInteger)selectedIndex{
    if (_selectedIndex == selectedIndex) {
        return;
    }
    if (_selectedIndex >= 0) {
        UILabel *fromLabel = (UILabel *)[_scrollView viewWithTag:kLabelTagBase+_selectedIndex];
        fromLabel.textColor = self.tabItemNormalColor;
        fromLabel.font = [UIFont systemFontOfSize:self.tabItemNormalFontSize];
    }
    if (selectedIndex >= 0 && selectedIndex < [self tabbarCount]) {
        UILabel *toLabel = (UILabel *)[_scrollView viewWithTag:kLabelTagBase+selectedIndex];
        toLabel.font = [UIFont systemFontOfSize:self.tabItemSelectedFontSize?self.tabItemSelectedFontSize:self.tabItemNormalFontSize];
        [toLabel sizeToFit];
        toLabel.textColor = self.tabItemSelectedColor;
        //选中居中
        UIView *selectedView = [_scrollView viewWithTag:kViewTagBase+selectedIndex];
        toLabel.center = CGPointMake(CGRectGetWidth(selectedView.bounds)/2.0, CGRectGetHeight(selectedView.bounds)/2.0);
        CGRect rc = selectedView.frame;
        rc = CGRectMake(CGRectGetMinX(rc) - CGRectGetMaxY(_scrollView.bounds),rc.origin.y,CGRectGetWidth(_scrollView.bounds) , CGRectGetHeight(rc));
        [_scrollView scrollRectToVisible:rc animated:YES];
        
        CGRect trackRc = [_scrollView convertRect:toLabel.bounds fromView:toLabel];
        CGFloat x = trackRc.origin.x;
        CGFloat width = trackRc.size.width;
        if (self.trackType == YLSliderTabbarTrackTypeRound) {
            width  += 16;
            x -= 8;
        }
        
        _trackView.frame = CGRectMake(x, _trackView.frame.origin.y, width, CGRectGetHeight(_trackView.bounds));
        _selectedIndex = selectedIndex;
    }
}

- (void)tapAction:(UITapGestureRecognizer *)tap{
    NSInteger i = tap.view.tag - kViewTagBase;
    self.selectedIndex = i;
    if (self.delegate && [self.delegate respondsToSelector:@selector(ylSlideTabbar:selectAt:)]) {
        [self.delegate ylSlideTabbar:self selectAt:i];
    }
}













+ (UIColor *)getColorOfPercent:(CGFloat)percent between:(UIColor *)color1 and:(UIColor *)color2{
    CGFloat red1, green1, blue1, alpha1;
    [color1 getRed:&red1 green:&green1 blue:&blue1 alpha:&alpha1];
    
    CGFloat red2, green2, blue2, alpha2;
    [color2 getRed:&red2 green:&green2 blue:&blue2 alpha:&alpha2];
    
    CGFloat p1 = percent;
    CGFloat p2 = 1.0 - percent;
    UIColor *mid = [UIColor colorWithRed:red1*p1+red2*p2 green:green1*p1+green2*p2 blue:blue1*p1+blue2*p2 alpha:1.0f];
    return mid;
}

@end
