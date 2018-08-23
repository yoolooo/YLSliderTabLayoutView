//
//  YLSliderView.m
//  YLSliderTabberView
//
//  Created by yan on 2018/8/22.
//  Copyright © 2018年 yanlong. All rights reserved.
//

#import "YLSliderView.h"

#define kPanSwitchOffsetThreshold 50.0f

@interface YLSliderView ()<UIGestureRecognizerDelegate>

@end

@implementation YLSliderView
{
    NSInteger _oldIndex;
    NSInteger _panToIndex;
    
    UIPanGestureRecognizer *_pan;
    CGPoint _panStartPoint;
    UIViewController *_oldController;
    UIViewController *_willController;
    BOOL _isSwitching;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initDefaultConfigure];
        
        self.backgroundColor = [UIColor lightGrayColor];
    }
    return self;
}

- (void)initDefaultConfigure{
    _oldIndex = -1;
    _isSwitching = NO;
    _pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panHandler:)];
    _pan.cancelsTouchesInView = NO;
    _pan.delegate = self;
    [self addGestureRecognizer:_pan];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    if ([touch.view isKindOfClass:[UISlider class]]) {
        return NO;
    }else{
        return YES;
    }
}

- (void)setSelectedIndex:(NSInteger)selectedIndex{
    if (selectedIndex != _oldIndex) {
        [self switchTo:selectedIndex];
    }
}

- (NSInteger)selectedIndex{
    return _oldIndex;
}

- (void)removeController:(UIViewController *)ctrl{
    UIViewController *vc = ctrl;
    [vc willMoveToParentViewController:nil];
    [vc.view removeFromSuperview];
    [vc removeFromParentViewController];
}

- (void)removeOld{
    [self removeController:_oldController];
    [_oldController endAppearanceTransition];
    _oldController = nil;
    _oldIndex = -1;
}
- (void)removeWill{
    [_willController beginAppearanceTransition:NO animated:NO];
    [self removeController:_willController];
    [_willController endAppearanceTransition];
    _willController = nil;
    _panToIndex = -1;
}

- (void)showAt:(NSInteger)index{
    if (_oldIndex != index) {
        [self removeOld];
        UIViewController *vc = [self.dataSource ylSliderView:self controllerAtIndex:index];
        [self.baseViewController addChildViewController:vc];
        vc.view.frame = self.bounds;
        [self addSubview:vc.view];
        [vc didMoveToParentViewController:self.baseViewController];
        _oldIndex = index;
        _oldController = vc;
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(ylSlideView:didSwitchToController:)]) {
            [self.delegate ylSlideView:self didSwitchToController:vc];
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(ylSlideView:didSwitchTo:)]) {
            [self.delegate ylSlideView:self didSwitchTo:index];
        }
    }
}

- (void)switchTo:(NSInteger)index{
    if (index == _oldIndex) {
        return;
    }
    if (_isSwitching) {
        return;
    }
    if (_oldController != nil && _oldController.parentViewController == self.baseViewController) {
        _isSwitching = YES;
        UIViewController *oldVC = _oldController;
        UIViewController *newVC = [self.dataSource ylSliderView:self controllerAtIndex:index];
        [oldVC willMoveToParentViewController:nil];
        [self.baseViewController addChildViewController:newVC];
        
        CGRect nowRect = oldVC.view.frame;
        CGRect leftRect = CGRectMake(CGRectGetMinX(nowRect)-CGRectGetWidth(nowRect), CGRectGetMinY(nowRect), CGRectGetWidth(nowRect), CGRectGetHeight(nowRect));
        CGRect rightRect = CGRectMake(CGRectGetMinX(nowRect)+CGRectGetWidth(nowRect), CGRectGetMinY(nowRect), CGRectGetWidth(nowRect), CGRectGetHeight(nowRect));
        CGRect newStartRect;
        CGRect oldEndRect;
        if (index>_oldIndex) {
            newStartRect = rightRect;
            oldEndRect = leftRect;
        }else{
            newStartRect = leftRect;
            oldEndRect = rightRect;
        }
        
        newVC.view.frame = newStartRect;
        [newVC willMoveToParentViewController:self.baseViewController];
        [self.baseViewController transitionFromViewController:oldVC toViewController:newVC duration:0.4 options:0 animations:^{
            newVC.view.frame = nowRect;
            oldVC.view.frame = oldEndRect;
        } completion:^(BOOL finished) {
            [oldVC removeFromParentViewController];
            [newVC didMoveToParentViewController:self.baseViewController];
            if (self.delegate && [self.delegate respondsToSelector:@selector(ylSlideView:didSwitchToController:)]) {
                [self.delegate ylSlideView:self didSwitchToController:newVC];
            }
            if (self.delegate && [self.delegate respondsToSelector:@selector(ylSlideView:didSwitchTo:)]) {
                [self.delegate ylSlideView:self didSwitchTo:index];
            }
            self->_isSwitching = NO;
        }];
        
        _oldIndex = index;
        _oldController = newVC;
    }else{
        [self showAt:index];
    }
    _willController = nil;
    _panToIndex = -1;
}

- (void)repositionForOffsetX:(CGFloat)offset{
    CGFloat x = 0.0f;
    if (_panToIndex < _oldIndex) {
        x = self.bounds.origin.x - self.bounds.size.width + offset;
    }else if (_panToIndex > _oldIndex){
        x = self.bounds.origin.x + self.bounds.size.width + offset;
    }
    
    UIViewController *oldVC = _oldController;
    oldVC.view.frame = CGRectMake(self.bounds.origin.x + offset, CGRectGetMinY(self.bounds), CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
    if (_panToIndex >= 0 && _panToIndex < [self.dataSource numberOfControllersInSliderView:self]) {
        
        UIViewController *newVC = _willController;
        newVC.view.frame = CGRectMake(x, self.bounds.origin.y, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(ylSlideView:switchingFrom:to:percent:)]) {
        [self.delegate ylSlideView:self switchingFrom:_oldIndex to:_panToIndex percent:fabs(offset)/CGRectGetWidth(self.bounds)];
    }
}


- (void)backToOldWithOffset:(CGFloat)offsetx{
    
    NSTimeInterval animatedTime = 0;
    animatedTime = 0.3;
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView animateWithDuration:animatedTime animations:^{
        [self repositionForOffsetX:0];
    } completion:^(BOOL finished) {
        if (self->_panToIndex >= 0 && self->_panToIndex < [self.dataSource numberOfControllersInSliderView:self] && self->_panToIndex != self->_oldIndex) {
            [self->_oldController beginAppearanceTransition:YES animated:NO];
            [self removeWill];
            [self->_oldController endAppearanceTransition];
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(ylSlideView:switchCanceled:)]) {
            [self.delegate ylSlideView:self switchCanceled:self->_oldIndex];
        }
    }];
}

- (void)panHandler:(UIPanGestureRecognizer *)pan{
    
    if (_oldIndex < 0) {
        return;
    }
    
    CGPoint point = [pan translationInView:self];
    if (pan.state == UIGestureRecognizerStateBegan) {
        _panStartPoint = point;
        [_oldController beginAppearanceTransition:NO animated:YES];
    }else if (pan.state == UIGestureRecognizerStateChanged){
        NSInteger panToIndex = -1;
        float offsetX = point.x - _panStartPoint.x;
        if (offsetX > 0) {
            panToIndex = _oldIndex - 1;
        }else if (offsetX < 0 ){
            panToIndex = _oldIndex + 1;
        }
        
        if (panToIndex != _panToIndex) {
            if (_willController) {
                [self removeWill];
            }
        }
        
        if (panToIndex < 0 || panToIndex >= [self.dataSource numberOfControllersInSliderView:self]) {
            _panToIndex = panToIndex;
            [self repositionForOffsetX:offsetX/2.0f];
        }else{
            if (panToIndex != _panToIndex) {
                _willController = [self.dataSource ylSliderView:self controllerAtIndex:panToIndex];
                [self.baseViewController addChildViewController:_willController];
                [_willController willMoveToParentViewController:self.baseViewController];
                [_willController beginAppearanceTransition:YES animated:YES];
                [self addSubview:_willController.view];
                _panToIndex = panToIndex;
            }
            [self repositionForOffsetX:offsetX];
        }
    }else if (pan.state == UIGestureRecognizerStateEnded){
        float offsetx = point.x - _panStartPoint.x;
        if (_panToIndex >= 0 && _panToIndex < [self.dataSource numberOfControllersInSliderView:self]) {
            if (fabs(offsetx) > kPanSwitchOffsetThreshold) {
                NSTimeInterval animationTime = 0;
                animationTime = fabs(self.frame.size.width - fabs(offsetx)) / self.bounds.size.width * 0.4;
                [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                [UIView animateWithDuration:animationTime animations:^{
                    [self repositionForOffsetX:offsetx > 0?self.bounds.size.width : -self.bounds.size.width];
                } completion:^(BOOL finished) {
                    [self removeOld];
                    if (self->_panToIndex >= 0 && self->_panToIndex < [self.dataSource numberOfControllersInSliderView:self]) {
                        [self->_willController endAppearanceTransition];
                        [self->_willController didMoveToParentViewController:self.baseViewController];
                        self->_oldIndex = self->_panToIndex;
                        self->_oldController = self->_willController;
                        self->_panToIndex = -1;
                    }
                    if (self.delegate && [self.delegate respondsToSelector:@selector(ylSlideView:didSwitchTo:)]) {
                        [self.delegate ylSlideView:self didSwitchTo:self->_oldIndex];
                    }
                    if (self.delegate && [self.delegate respondsToSelector:@selector(ylSlideView:didSwitchToController:)]) {
                        [self.delegate ylSlideView:self didSwitchToController:self->_oldController];
                    }
                    
                }];
            }else{
                [self backToOldWithOffset:offsetx];
            }
        }else{
            [self backToOldWithOffset:offsetx];
        }
    }
    
}


@end
