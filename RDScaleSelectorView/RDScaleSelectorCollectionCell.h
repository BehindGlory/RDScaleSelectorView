//
//  RDScaleSelectorCollectionCell.h
//  RDScaleSelectorView
//
//  Created by Rain Day on 2018/8/29.
//  Copyright © 2018年 Rain Day. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RDScaleSelectorCollectionCell : UICollectionViewCell

@property (nonatomic, assign) NSInteger majorScaleCount;
@property (nonatomic, assign) NSInteger minorScaleCount;
@property (nonatomic, assign) NSInteger scaleSpacing;
@property (nonatomic, assign) CGSize minorScaleSize;
@property (nonatomic, assign) CGSize majorScaleSize;
@property (nonatomic, assign) BOOL isShowMinorScale;
@property (nonatomic, strong) UIFont *majorScaleFont;
@property (nonatomic, assign) CGFloat pointerHeight;
@property (nonatomic, strong) NSString  *labelText;

- (void)configureWithIndexPath:(NSIndexPath *)indexPath;

@end
