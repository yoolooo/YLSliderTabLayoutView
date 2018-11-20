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


+ (instancetype)itemWithTitle:(NSString *)title{
    YLTabbarItem *item = [[YLTabbarItem alloc] init];
    item.title = title;
    return item;
}

@end



@interface YLSliderTabbarItemCell : UICollectionViewCell

@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, strong) UIColor *nomalColor;
@property (nonatomic, strong) UIColor *hightlightColor;

@end


@implementation YLSliderTabbarItemCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        UILabel *label = [[UILabel alloc] initWithFrame:self.bounds];
        label.textAlignment = NSTextAlignmentCenter;
        self.titleLabel = label;
        [self.contentView addSubview:label];
    }
    return self;
}

- (void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    self.titleLabel.textColor = selected?self.hightlightColor:self.nomalColor;
}

- (void)setHightlightColor:(UIColor *)hightlightColor{
    _hightlightColor = hightlightColor;
    if (self.selected) {
        self.titleLabel.textColor = hightlightColor;
    }
}

@end


@interface YLSliderTabbar ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@end


@implementation YLSliderTabbar
{
    UICollectionView *_collectionView;
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
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.showsHorizontalScrollIndicator = NO;
    [_collectionView registerClass:[YLSliderTabbarItemCell class] forCellWithReuseIdentifier:@"cellID"];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    //ios 11
    if ([_collectionView respondsToSelector:@selector(setContentInsetAdjustmentBehavior:)]) {
        if (@available(iOS 11.0, *)) {
            _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    [self addSubview:_collectionView];
    _trackView = [[UIImageView alloc] initWithFrame:CGRectMake(0, (self.bounds.size.height-kUnderLineTrackViewHeight), 0, kUnderLineTrackViewHeight)];
    [(UIScrollView*)_collectionView addSubview:_trackView];
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
    }else if (self.trackType == YLSliderTabbarTrackTypeBackground){
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
    
    [_collectionView reloadData];
//    for (int i=0; i<[self tabbarCount]; i++) {
//        if (i == self.selectedIndex) {
//            continue;
//        }
//        UILabel *label = (UILabel *)[_scrollView viewWithTag:kLabelTagBase+i];
//        label.textColor = tabItemNormalColor;
//    }
}

- (void)setTabItemSelectedColor:(UIColor *)tabItemSelectedColor{
    _tabItemSelectedColor = tabItemSelectedColor;
    
//    UILabel *label = (UILabel *)[_scrollView viewWithTag:kLabelTagBase+self.selectedIndex];
//    label.textColor = tabItemSelectedColor;
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
    _tabbarItems = tabbarItems;
    [_collectionView reloadData];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.backgroundView.frame = self.bounds;
    _collectionView.frame = self.bounds;
}

- (NSInteger)tabbarCount{
    return self.tabbarItems.count;
}

- (void)switchingFrom:(NSInteger)fromIndex to:(NSInteger)toIndex percent:(float)percent{
//    颜色
    YLSliderTabbarItemCell *fromCell = (YLSliderTabbarItemCell*)[_collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:fromIndex inSection:0]];
    fromCell.titleLabel.textColor = [YLSliderTabbar getColorOfPercent:percent between:self.tabItemNormalColor and:self.tabItemSelectedColor];
    if (toIndex >= 0 && toIndex < [self tabbarCount]) {
        YLSliderTabbarItemCell *toCell = (YLSliderTabbarItemCell*)[_collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:toIndex inSection:0]];
        if (toCell) {
            toCell.titleLabel.textColor = [YLSliderTabbar getColorOfPercent:percent between:self.tabItemSelectedColor and:self.tabItemNormalColor];
        }
        
    }
    
//    trackView
    UICollectionViewLayoutAttributes *fromCellAttribute = [_collectionView layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForRow:fromIndex inSection:0]];
    UICollectionViewLayoutAttributes *toCellAttribute;
    if (toIndex >= 0 && toIndex < [self tabbarCount]) {
        toCellAttribute = [_collectionView layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForRow:toIndex inSection:0]];
    }
    
    CGFloat trackX;
    CGFloat trackWidth;
    if (self.trackType == YLSliderTabbarTrackTypeBackground){
        CGFloat fromWidth = CGRectGetWidth(fromCellAttribute.bounds);
        CGFloat fromX = CGRectGetMinX(fromCellAttribute.frame);
        CGFloat toWidth = 0.0f;
        CGFloat toX = 0.0f;
        if (toCellAttribute) {
            toWidth = CGRectGetWidth(toCellAttribute.bounds);
            toX = CGRectGetMinX(toCellAttribute.frame);
        }
        trackX = fromX + (toX - fromX) * percent;
        trackWidth = fromWidth * (1-percent) + toWidth * percent;
    }else{
        
        CGRect fromRc = fromCell.frame;
        CGFloat fromWidth = fromCell.frame.size.width;
        CGFloat fromX = fromRc.origin.x;
        
        CGFloat toX;
        CGFloat toWidth;
        if (toCellAttribute) {
            CGRect toRc = toCellAttribute.frame;
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
        trackWidth = toWidth * percent + fromWidth*(1-percent);
        trackX = fromX + (toX - fromX)*percent;
        if (self.trackType == YLSliderTabbarTrackTypeRound) {
            trackWidth += 16;
            trackX -= 8;
        }
    }

    _trackView.frame = CGRectMake(trackX, _trackView.frame.origin.y, trackWidth, CGRectGetHeight(_trackView.bounds));
}

- (void)setSelectedIndex:(NSInteger)selectedIndex{
    if (_selectedIndex == selectedIndex) {
        return;
    }
    if (selectedIndex<self.tabbarItems.count) {
        [_collectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:selectedIndex inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
        
        [self switchingFrom:_selectedIndex to:selectedIndex percent:1];
        _selectedIndex = selectedIndex;
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


- (CGSize)sizeOfString:(NSString*)string font:(UIFont *)font constrainedToSize:(CGSize)size{
    CGSize resultSize = [string boundingRectWithSize:size
                                    options:(NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin)
                                 attributes:@{NSFontAttributeName: font}
                                    context:nil].size;
    return resultSize;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.tabbarItems.count;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return self.tabItemSpace;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    YLTabbarItem *item = self.tabbarItems[indexPath.row];
    NSString *title = item.title;
    CGSize size = [self sizeOfString:title font:[UIFont systemFontOfSize:self.tabItemNormalFontSize] constrainedToSize:CGSizeMake(CGFLOAT_MAX, 20)];
    return CGSizeMake(size.width+8, collectionView.bounds.size.height);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    YLSliderTabbarItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellID" forIndexPath:indexPath];
    
    YLTabbarItem *item = self.tabbarItems[indexPath.row];
    cell.titleLabel.textColor = self.tabItemNormalColor;
    cell.titleLabel.font = [UIFont systemFontOfSize:self.tabItemNormalFontSize];
    cell.hightlightColor = self.tabItemSelectedColor;
    cell.nomalColor = self.tabItemNormalColor;
    cell.titleLabel.text = item.title;
    
    [collectionView sendSubviewToBack:_trackView];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSUInteger index = indexPath.row;
    [self setSelectedIndex:index];
    if (self.delegate && [self.delegate respondsToSelector:@selector(ylSlideTabbar:selectAt:)]) {
        [self.delegate ylSlideTabbar:self selectAt:index];
    }
}


@end
