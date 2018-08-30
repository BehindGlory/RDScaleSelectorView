//
//  RDBirthdaySelectViewController.m
//  RDScaleSelectorView
//
//  Created by Rain Day on 2018/8/29.
//  Copyright © 2018年 Rain Day. All rights reserved.
//

#import "RDBirthdaySelectViewController.h"
#import "RDScaleSelectorView.h"
#import "NSDate+DateTools.h"

@interface RDBirthdaySelectViewController () <RDScaleSelectorViewDataSource, RDScaleSelectorViewDelegate>

@property (nonatomic, weak) IBOutlet RDScaleSelectorView *scaleSelectorView;
@property (nonatomic, weak) IBOutlet UILabel *label;

@end

@implementation RDBirthdaySelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - DYRulerViewDataSource
- (NSInteger)numberOfMajorScaleInScaleSelectorView:(RDScaleSelectorView *)scaleSelectorView {
    return 21;
}

- (NSInteger)numberOfMinorScaleInScaleSelectorView:(RDScaleSelectorView *)scaleSelectorView {
    return 12;
}

- (NSString *)scaleSelectorView:(RDScaleSelectorView *)scaleSelectorView textOfMajorScaleAtIndex:(NSInteger)index {
    return [NSString stringWithFormat:@"%@", @([[NSDate date] year] - [self numberOfMajorScaleInScaleSelectorView:scaleSelectorView] + index + 1)];
}

#pragma mark - DYRulerViewDelegate
- (CGFloat)spacingBetweenMinorScaleInScaleSelectorView:(RDScaleSelectorView *)scaleSelectorView {
    return 15;
}

- (CGSize)scaleSelectorView:(RDScaleSelectorView *)scaleSelectorView sizeForPointerImageView:(UIImageView *)pointerImageView {
    return CGSizeMake(8, 60);
}

- (UIFont *)fontForMajorScaleInScaleSelectorView:(RDScaleSelectorView *)scaleSelectorView {
    return [UIFont boldSystemFontOfSize:20];
}

- (BOOL)scaleSelectorViewShouldShowMinorScale:(RDScaleSelectorView *)scaleSelectorView {
    return YES;
}

- (CGSize)sizeForMajorScaleViewInScaleSelectorView:(RDScaleSelectorView *)scaleSelectorView {
    return CGSizeMake(6, 40);
}

- (CGSize)sizeForMinorScaleViewInScaleSelectorView:(RDScaleSelectorView *)scaleSelectorView {
    return CGSizeMake(2, 20);
}

- (void)scaleSelectorView:(RDScaleSelectorView *)scaleSelectorView didChangeScaleWithMajorScale:(int)majorScale minorScale:(int)minorScale {
    self.label.text = [NSString stringWithFormat:@"%@/%@", @([[NSDate date] year] - [self numberOfMajorScaleInScaleSelectorView:scaleSelectorView] + majorScale + 1), @(minorScale + 1)];
}

@end
