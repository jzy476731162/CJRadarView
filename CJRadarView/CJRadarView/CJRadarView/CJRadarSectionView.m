//
//  CJRadarSectionView.m
//  CJRadarView
//
//  Created by Carl Ji on 16/8/2.
//  Copyright © 2016年 Carl Ji. All rights reserved.
//

#import "CJRadarSectionView.h"

@implementation CJRadarSectionView

+ (instancetype)defaultStyleWithSectionData:(NSArray *)data centerPoint:(CGPoint)center radius:(CGFloat)radius columnCount:(NSInteger)columnCount maxValue:(CGFloat)maxValue{
    CJRadarSectionView *radar = [[CJRadarSectionView alloc] init];
    [radar setBackgroundColor:[UIColor clearColor]];
    
    radar.data = data;
    radar.centerPoint = center;
    radar.radius = radius;
    radar.columnCount = columnCount;
    radar.maxValue = maxValue;
    
    return radar;
}

- (instancetype)reloadRadarSectionViewWithData:(NSArray *)data centerPoint:(CGPoint)center radius:(CGFloat)radius columnCount:(NSInteger)columnCount maxValue:(CGFloat)maxValue {
    self.data = data;
    self.centerPoint = center;
    self.radius = radius;
    self.columnCount = columnCount;
    self.maxValue = maxValue;
    
    [self layoutIfNeeded];
    
    return self;
}

+ (CGPoint)getPointWithCenter:(CGPoint)center arc:(double)arc radius:(CGFloat)radius scale:(CGFloat)scale{
    if (!scale) {
        return center;
    }else {
        CGFloat x = center.x + radius * (sin(arc));
        CGFloat y = center.y - radius * (cos(arc));
        return CGPointMake(x, y);
    }
}


- (void)drawRect:(CGRect)rect {
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path setLineWidth:1];
    
    for (int index = 0; index < self.columnCount; index ++) {
        if (index >= [self.data count]) {
            [path addLineToPoint:self.centerPoint];
            continue;
        }
        CGFloat scale = [self.data[index] floatValue]/self.radius;
        CGPoint point = [CJRadarSectionView getPointWithCenter:self.centerPoint arc:(index * 2 * M_PI / self.columnCount) radius:self.radius scale:scale];
        if (index == 0) {
            [path moveToPoint:point];
        }else if (index == self.columnCount - 1) {
            [path closePath];
        }else {
            [path addLineToPoint:point];
        }
    }
    UIColor *lineColor = [UIColor colorWithRed:arc4random()%255/255 green:arc4random()%255/255 blue:arc4random()%255/255 alpha:0.3];
    UIColor *contentColor = [UIColor colorWithRed:arc4random()%255/255 green:arc4random()%255/255 blue:arc4random()%255/255 alpha:0.1];
    [lineColor setStroke];
    [contentColor setFill];
    
    [path fill];
    [path stroke];
}


@end
