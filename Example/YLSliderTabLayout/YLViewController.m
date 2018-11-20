//
//  YLViewController.m
//  YLSliderTabLayout
//
//  Created by yoolooo on 08/23/2018.
//  Copyright (c) 2018 yoolooo. All rights reserved.
//

#import "YLViewController.h"
#import "YLSliderTabLayout.h"
#import "ContentViewController.h"

@interface YLViewController ()<YLSliderTabLayoutViewDelegate>

@end

@implementation YLViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initView];
}


- (void)initView{
    
    YLSliderTabbar *sliderView = [[YLSliderTabbar alloc] initWithFrame:CGRectMake(0, 88, self.view.bounds.size.width, 40)];
    sliderView.backgroundColor = [UIColor whiteColor];
    sliderView.tabItemNormalColor = [UIColor blackColor];
    sliderView.tabItemSelectedColor = [UIColor orangeColor];
    sliderView.tabItemNormalFontSize = 17;
    sliderView.tabItemSelectedFontSize = 20;
    sliderView.trackType = YLSliderTabbarTrackTypeRound;
    sliderView.trackColor = [UIColor purpleColor];
    sliderView.edgeInsets = UIEdgeInsetsMake(0, 50, 0, 50);
    NSMutableArray *items = [NSMutableArray array];
    CGFloat width = 0;
    for (int i = 0; i<3; i++) {
        NSString *title = [NSString stringWithFormat:@"title %d",i];
        
        CGFloat itemWidth = [self sizeOfString:title font:[UIFont systemFontOfSize:17] constrainedToSize:CGSizeMake(CGFLOAT_MAX, 20)].width+8;
        width+=itemWidth;
        YLTabbarItem *item = [YLTabbarItem itemWithTitle:title width:itemWidth];
        [items addObject:item];
    }
    
    sliderView.tabItemSpace = (self.view.bounds.size.width-sliderView.edgeInsets.left-sliderView.edgeInsets.right-width)/2;
    
    
    sliderView.tabbarItems = items;
    
    YLSliderTabLayoutView *slider = [[YLSliderTabLayoutView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height-64) tabbar:sliderView tabbarBottomSpacing:0 baseViewController:self cache:nil delegate:self];
    [self.view addSubview:slider];
    slider.selectedIndex = 0;
    
}


- (NSInteger)numberOfTabsInTabLayoutView:(YLSliderTabLayoutView *)tabLayoutView{
    return 3;
}

- (UIViewController *)ylSliderTabLayoutView:(YLSliderTabLayoutView *)tabLayoutView controllerAt:(NSInteger)index{
    ContentViewController *vc = [ContentViewController new];
    vc.view.backgroundColor = [UIColor colorWithRed:random()%255/255.0 green:random()%255/255.0 blue:random()%255/255.0 alpha:1];
    vc.titleString = [NSString stringWithFormat:@"NO.%ld",index];
    return vc;
}



- (CGSize)sizeOfString:(NSString*)string font:(UIFont *)font constrainedToSize:(CGSize)size{
    CGSize resultSize = [string boundingRectWithSize:size
                                             options:(NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin)
                                          attributes:@{NSFontAttributeName: font}
                                             context:nil].size;
    return resultSize;
}

@end
