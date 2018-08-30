//
//  RDScaleSelectorView.m
//  RDScaleSelectorView
//
//  Created by Rain Day on 2018/8/29.
//  Copyright © 2018年 Rain Day. All rights reserved.
//

#import "RDScaleSelectorView.h"
#import "RDScaleSelectorCollectionCell.h"

@interface RDScaleSelectorView () <UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, assign) NSInteger minValue;
@property (nonatomic, assign) NSInteger maxValue;

@property (nonatomic, assign) NSInteger majorScaleCount;
@property (nonatomic, assign) NSInteger minorScaleCount;
@property (nonatomic, assign) NSInteger scaleSpacing;
@property (nonatomic, assign) CGSize minorScaleSize;
@property (nonatomic, assign) CGSize majorScaleSize;
@property (nonatomic, assign) BOOL isShowMinorScale;
@property (nonatomic, strong) UIFont *majorScaleFont;
@property (nonatomic, assign) CGSize pointerSize;

@end

@implementation RDScaleSelectorView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self initSubViews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    self.collectionView.backgroundColor = [UIColor blueColor];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.collectionView registerClass:[RDScaleSelectorCollectionCell class]  forCellWithReuseIdentifier:@"DYRulerCollectionViewCell"];
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    self.collectionView.backgroundColor = [UIColor blueColor];
    [self addSubview:self.collectionView];

    NSDictionary *nameMap = @{ @"collectionView" : self.collectionView };
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[collectionView]|" options:0 metrics:nil views:nameMap]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[collectionView]|" options:0 metrics:nil views:nameMap]];

    self.pointerImageView = [[UIImageView alloc] init];
    self.pointerImageView.backgroundColor = [UIColor whiteColor];
    self.pointerImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.pointerImageView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self configureDataSource];
}

- (void)configureDataSource {
    self.majorScaleCount = [self.dataSource numberOfMajorScaleInScaleSelectorView:self];
    self.minorScaleCount = [self.dataSource numberOfMinorScaleInScaleSelectorView:self];

    if ([self.delegate respondsToSelector:@selector(spacingBetweenMinorScaleInScaleSelectorView:)]) {
        self.scaleSpacing = MAX([self.delegate spacingBetweenMinorScaleInScaleSelectorView:self], 10);
    } else {
        self.scaleSpacing = 15;
    }

    // 指针视图尺寸
    if ([self.delegate respondsToSelector:@selector(scaleSelectorView:sizeForPointerImageView:)]) {
        self.pointerSize = [self.delegate scaleSelectorView:self sizeForPointerImageView:self.pointerImageView];
    } else {
        self.pointerSize = CGSizeMake(4, 50);
    }
    // 指针视图添加约束
    [self addConstraintForPointerImageView];

    // 小刻度尺寸
    if ([self.delegate respondsToSelector:@selector(sizeForMinorScaleViewInScaleSelectorView:)]) {
        self.minorScaleSize = [self.delegate sizeForMinorScaleViewInScaleSelectorView:self];
    } else {
        self.minorScaleSize = CGSizeMake(1, 10);
    }

    // 大刻度尺寸
    if ([self.delegate respondsToSelector:@selector(sizeForMajorScaleViewInScaleSelectorView:)]) {
        self.majorScaleSize = [self.delegate sizeForMajorScaleViewInScaleSelectorView:self];
    } else {
        self.majorScaleSize = CGSizeMake(2 * self.minorScaleSize.width, 2 * self.minorScaleSize.height);
    }

    // 是否显示小刻度
    if ([self.delegate respondsToSelector:@selector(scaleSelectorViewShouldShowMinorScale:)]) {
        self.isShowMinorScale = [self.delegate scaleSelectorViewShouldShowMinorScale:self];
    } else {
        self.isShowMinorScale = YES;
    }

    // 大刻度字体
    if ([self.delegate respondsToSelector:@selector(fontForMajorScaleInScaleSelectorView:)]) {
        self.majorScaleFont = [self.delegate fontForMajorScaleInScaleSelectorView:self];
    }
}

- (void)addConstraintForPointerImageView {
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.pointerImageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];

    NSDictionary *metricsMap = @{ @"width" : @(self.pointerSize.width),
                                  @"height" : @(self.pointerSize.height) };
    NSDictionary *nameMap = @{ @"pointerImageView" : self.pointerImageView };
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[pointerImageView(==width)]" options:0 metrics:metricsMap views:nameMap]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[pointerImageView(==height)]|" options:0 metrics:metricsMap views:nameMap]];
}

#pragma mark - public method
- (void)reloadData {
    [self configureDataSource];
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.majorScaleCount == 0 || self.minorScaleCount == 0) {
        return 0;
    }
    return self.majorScaleCount + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"DYRulerCollectionViewCell";
    RDScaleSelectorCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.scaleSpacing = self.scaleSpacing;
    cell.majorScaleCount = self.majorScaleCount;
    cell.minorScaleCount = self.minorScaleCount;
    cell.minorScaleSize = self.minorScaleSize;
    cell.majorScaleSize = self.majorScaleSize;
    cell.isShowMinorScale = self.isShowMinorScale;
    cell.majorScaleFont = self.majorScaleFont;
    cell.pointerHeight = self.pointerSize.height;
    self.minValue = [[self.dataSource scaleSelectorView:self textOfMajorScaleAtIndex:0] integerValue];
    self.maxValue = [[self.dataSource scaleSelectorView:self textOfMajorScaleAtIndex:self.majorScaleCount - 1] integerValue];
    if (indexPath.item > 0) {
        cell.labelText = [self.dataSource scaleSelectorView:self textOfMajorScaleAtIndex:indexPath.item - 1];
    }
    [cell configureWithIndexPath:indexPath];
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return CGSizeMake(self.frame.size.width * 0.5 - self.scaleSpacing, self.collectionView.frame.size.height);
    } else if (indexPath.row == self.majorScaleCount) {
        return CGSizeMake(self.frame.size.width * 0.5 + self.scaleSpacing, self.collectionView.frame.size.height);
    } else {
        return CGSizeMake(self.minorScaleCount * self.scaleSpacing, self.collectionView.frame.size.height);
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSLog(@"scrollViewDidEndDragging%f", scrollView.contentOffset.x);
    float accurateScale = (scrollView.contentOffset.x) / (self.scaleSpacing * self.minorScaleCount);
    float inaccurateScale = round(accurateScale * self.minorScaleCount) / self.minorScaleCount;
    [scrollView setContentOffset:CGPointMake((inaccurateScale) * self.scaleSpacing * self.minorScaleCount, 0) animated:YES];
    if (accurateScale >= 0 && accurateScale <= self.maxValue - self.minValue) {
        if ([self.delegate respondsToSelector:@selector(scaleSelectorView:didChangeScaleWithMajorScale:minorScale:)]) {
            [self.delegate scaleSelectorView:self didChangeScaleWithMajorScale:(int)inaccurateScale minorScale:(int)fmod(inaccurateScale * self.minorScaleCount, self.minorScaleCount)];
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        [self scrollViewDidEndDecelerating:scrollView];
    }
}

@end
