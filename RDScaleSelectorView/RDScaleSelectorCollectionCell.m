//
//  RDScaleSelectorCollectionCell.m
//  RDScaleSelectorView
//
//  Created by Rain Day on 2018/8/29.
//  Copyright © 2018年 Rain Day. All rights reserved.
//

#import "RDScaleSelectorCollectionCell.h"

@interface RDScaleSelectorCollectionCell ()

@property (nonatomic, strong) UILabel *label;

@end

@implementation RDScaleSelectorCollectionCell

- (void)addConstraintForLabel {
    NSDictionary *metricsMap = @{ @"height" : @(self.frame.size.height - self.majorScaleSize.height - self.pointerHeight) };
    NSDictionary *nameMap = @{ @"label" : self.label };
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.label attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:self.scaleSpacing+self.minorScaleSize.width * 0.5]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.label attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:self.majorScaleSize.height + 20]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[label(<=height)]" options:0 metrics:metricsMap views:nameMap]];
}

- (void)configureWithIndexPath:(NSIndexPath *)indexPath {
    for (UIView *view in self.contentView.subviews) {
        [view removeFromSuperview];
    }
    self.label = [[UILabel alloc] init];
    self.label.translatesAutoresizingMaskIntoConstraints = NO;
    self.label.textColor = [UIColor whiteColor];
    if (self.majorScaleFont) {
        self.label.font = self.majorScaleFont;
    }
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.hidden = NO;
    if (indexPath.row > 0) {
        self.label.text = self.labelText;
    }
    [self.contentView addSubview:self.label];
    [self addConstraintForLabel];
    if (indexPath.row == 0) {
        self.label.hidden = YES;
    } else if (indexPath.item == 1) {
        [self createScaleViewWithInitialCount:1 totalCount:self.minorScaleCount + 1];
    } else if (indexPath.item == self.majorScaleCount) {
        [self createScaleViewWithInitialCount:0 totalCount:2];
    } else {
        [self createScaleViewWithInitialCount:0 totalCount:self.minorScaleCount + 1];
    }
}

- (void)createScaleViewWithInitialCount:(NSInteger)initialCount totalCount:(NSInteger)totalCount {
    for (NSInteger index = initialCount; index < totalCount; index++) {
        UIView *view = [[UIView alloc] init];
        view.translatesAutoresizingMaskIntoConstraints = NO;
        NSDictionary *metricsMap;
        NSDictionary *nameMap = @{ @"view" : view };
        if (index == 1) {
            metricsMap = @{ @"height" : @(self.majorScaleSize.height),
                            @"width" : @(self.majorScaleSize.width),
                            @"left" : @(index * self.scaleSpacing - 0.5 * self.majorScaleSize.width) };
        } else {
            if (self.isShowMinorScale) {
                metricsMap = @{ @"height" : @(self.minorScaleSize.height),
                                @"width" : @(self.minorScaleSize.width),
                                @"left" : @(index * self.scaleSpacing - 0.5 * self.minorScaleSize.width) };
            } else {
                view.frame = CGRectZero;
            }
        }
        view.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:view];

        if (metricsMap) {
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-1-[view(==height)]" options:0 metrics:metricsMap views:nameMap]];
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-left-[view(==width)]" options:0 metrics:metricsMap views:nameMap]];
        }
    }
}

@end
