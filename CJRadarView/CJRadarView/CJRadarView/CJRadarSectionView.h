//
//  CJRadarSectionView.h
//  CJRadarView
//
//  Created by Carl Ji on 16/8/2.
//  Copyright © 2016年 Carl Ji. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CJRadarSectionView : UIView

+ (instancetype)defaultStyleWithSectionData:(NSArray *)data centerPoint:(CGPoint)center radius:(CGFloat)radius columnCount:(NSInteger)columnCount maxValue:(CGFloat)maxValue;
- (instancetype)reloadRadarSectionViewWithData:(NSArray *)data centerPoint:(CGPoint)center radius:(CGFloat)radius columnCount:(NSInteger)columnCount maxValue:(CGFloat)maxValue;

@property (nonatomic, strong) NSArray *data;
@property (nonatomic, assign) CGPoint centerPoint;
@property (nonatomic, assign) CGFloat radius;
@property (nonatomic, assign) NSInteger columnCount;
@property (nonatomic, assign) CGFloat maxValue;

@end
