//
//  CJRadarSectionView.h
//  CJRadarView
//
//  Created by Carl Ji on 16/8/2.
//  Copyright © 2016年 Carl Ji. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CJRadarSectionView : UIView

+ (instancetype)defaultStyleWithSectionData:(NSArray *)data radius:(CGFloat)radius maxValue:(CGFloat)maxValue frame:(CGRect)frame;
- (instancetype)reloadRadarSectionViewWithData:(NSArray *)data radius:(CGFloat)radius maxValue:(CGFloat)maxValue;

@property (nonatomic, strong) NSArray *data;
@property (nonatomic, assign) CGPoint centerPoint;
@property (nonatomic, assign) CGFloat radius;
@property (nonatomic, assign) NSInteger columnCount;
@property (nonatomic, assign) CGFloat maxValue;

@end
