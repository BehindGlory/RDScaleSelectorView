//
//  RDWeightSelectViewController.m
//  RDScaleSelectorView
//
//  Created by Rain Day on 2018/8/29.
//  Copyright © 2018年 Rain Day. All rights reserved.
//

#import "RDWeightSelectViewController.h"
#import "RDScaleSelectorView.h"

@interface RDWeightSelectViewController () <RDScaleSelectorViewDataSource, RDScaleSelectorViewDelegate>

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) RDScaleSelectorView *scaleSelectorView;

@end

@implementation RDWeightSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.scaleSelectorView = [[RDScaleSelectorView alloc] init];
    self.scaleSelectorView.delegate = self;
    self.scaleSelectorView.dataSource = self;
    self.scaleSelectorView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.scaleSelectorView];

    self.label = [[UILabel alloc] init];
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.backgroundColor = [UIColor redColor];
    self.label.textColor = [UIColor blackColor];
    self.label.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.label];

    NSDictionary *nameMap = @{ @"scaleSelectorView" : self.scaleSelectorView,
                               @"label" : self.label };
    NSDictionary *metricsMap = @{ @"scaleSelectorViewHeight" : @(140),
                                  @"labelHeight" : @(30),
                                  @"labelWidth" : @(100) };
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[scaleSelectorView]|" options:0 metrics:nil views:nameMap]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-150-[scaleSelectorView(==scaleSelectorViewHeight)]" options:0 metrics:metricsMap views:nameMap]];

    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.label attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[label(==labelWidth)]" options:0 metrics:metricsMap views:nameMap]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[scaleSelectorView]-110-[label(==labelHeight)]" options:0 metrics:metricsMap views:nameMap]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - RDScaleSelectorViewDataSource
- (NSInteger)numberOfMajorScaleInScaleSelectorView:(RDScaleSelectorView *)scaleSelectorView {
    return 200;
}

- (NSInteger)numberOfMinorScaleInScaleSelectorView:(RDScaleSelectorView *)scaleSelectorView {
    return 10;
}

- (NSString *)scaleSelectorView:(RDScaleSelectorView *)scaleSelectorView textOfMajorScaleAtIndex:(NSInteger)index {
    return [NSString stringWithFormat:@"%@", @(index + 1)];
}

#pragma mark - RDScaleSelectorViewDelegate
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
    return CGSizeMake(4, 40);
}

- (CGSize)sizeForMinorScaleViewInScaleSelectorView:(RDScaleSelectorView *)scaleSelectorView {
    return CGSizeMake(2, 20);
}

- (void)scaleSelectorView:(RDScaleSelectorView *)scaleSelectorView didChangeScaleWithMajorScale:(int)majorScale minorScale:(int)minorScale {
    self.label.text = [NSString stringWithFormat:@"%@/%@", @(majorScale + 1), @(minorScale)];
}

@end
