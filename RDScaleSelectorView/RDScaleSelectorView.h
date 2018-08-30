//
//  RDScaleSelectorView.h
//  RDScaleSelectorView
//
//  Created by Rain Day on 2018/8/29.
//  Copyright © 2018年 Rain Day. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RDScaleSelectorViewDataSource, RDScaleSelectorViewDelegate;
@interface RDScaleSelectorView : UIView

@property (nonatomic, strong) UIImageView *pointerImageView;

@property (nonatomic, weak) IBOutlet id <RDScaleSelectorViewDataSource> dataSource;
@property (nonatomic, weak) IBOutlet id <RDScaleSelectorViewDelegate> delegate;

- (void)reloadData;

@end

@protocol RDScaleSelectorViewDataSource <NSObject>

@required

/**
 *  大刻度数量
 */
- (NSInteger)numberOfMajorScaleInScaleSelectorView:(RDScaleSelectorView *)scaleSelectorView;

/**
 *  小刻度数量
 */
- (NSInteger)numberOfMinorScaleInScaleSelectorView:(RDScaleSelectorView *)scaleSelectorView;

/**
 *  刻度值
 */
- (NSString *)scaleSelectorView:(RDScaleSelectorView *)scaleSelectorView textOfMajorScaleAtIndex:(NSInteger)index;

@end

@protocol RDScaleSelectorViewDelegate <NSObject>

@optional

/**
 *  小刻度的间距
 */
- (CGFloat)spacingBetweenMinorScaleInScaleSelectorView:(RDScaleSelectorView *)scaleSelectorView;

/**
 *  指针的尺寸
 */
- (CGSize)scaleSelectorView:(RDScaleSelectorView *)scaleSelectorView sizeForPointerImageView:(UIImageView *)pointerImageView;

/**
 *  刻度字体
 */
- (UIFont *)fontForMajorScaleInScaleSelectorView:(RDScaleSelectorView *)scaleSelectorView;

/**
 *  是否显示小刻度
 */
- (BOOL)scaleSelectorViewShouldShowMinorScale:(RDScaleSelectorView *)scaleSelectorView;

/**
 *  小刻度尺寸
 */
- (CGSize)sizeForMinorScaleViewInScaleSelectorView:(RDScaleSelectorView *)scaleSelectorView;

/**
 *  大刻度尺寸
 */
- (CGSize)sizeForMajorScaleViewInScaleSelectorView:(RDScaleSelectorView *)scaleSelectorView;

/**
 *  选择刻度
 */
- (void)scaleSelectorView:(RDScaleSelectorView *)scaleSelectorView didChangeScaleWithMajorScale:(int)majorScale minorScale:(int)minorScale;

@end
