//
//  CJRadarSectionView.m
//  CJRadarView
//
//  Created by Carl Ji on 16/8/2.
//  Copyright © 2016年 Carl Ji. All rights reserved.
//

#import "CJRadarSectionView.h"

@implementation CJRadarSectionView

+ (instancetype)defaultStyleWithSectionData:(NSArray *)data radius:(CGFloat)radius maxValue:(CGFloat)maxValue frame:(CGRect)frame{
    CJRadarSectionView *radar = [[CJRadarSectionView alloc] init];
    [radar setBackgroundColor:[UIColor clearColor]];
    
    radar.data = data;
    radar.radius = radius;
    radar.columnCount = data.count;
    radar.maxValue = maxValue;
    radar.centerPoint = CGPointMake(frame.size.width/2, frame.size.height/2);
    radar.frame = frame;
    [radar resetMaxValue:data Max:maxValue];
    
    return radar;
}

- (instancetype)reloadRadarSectionViewWithData:(NSArray *)data radius:(CGFloat)radius maxValue:(CGFloat)maxValue{
    self.data = data;
    self.radius = radius;
    self.columnCount = data.count;
    [self resetMaxValue:data Max:maxValue];
    
    [self layoutIfNeeded];
    
    return self;
}


- (void)resetMaxValue:(NSArray *)list Max:(CGFloat)max{
    CGFloat maxValue = self.maxValue;
    for (NSNumber *value in list) {
        if ([value floatValue] > maxValue) {
            maxValue = [value floatValue];
        }
    }
    self.maxValue = maxValue;
}

+ (CGPoint)getPointWithCenter:(CGPoint)center arc:(double)arc radius:(CGFloat)radius scale:(CGFloat)scale{
    if (!scale) {
        return center;
    }else {
        CGFloat x = center.x + radius * scale * (sin(arc));
        CGFloat y = center.y - radius * scale * (cos(arc));
        return CGPointMake(x, y);
    }
}


- (void)drawRect:(CGRect)rect {

    UIBezierPath *path = [UIBezierPath bezierPath];
    [path setLineWidth:1];
    
    for (int index = 0; index < self.columnCount; index ++) {
        CGFloat scale = [self.data[index] floatValue]/self.maxValue;

        CGPoint point = [CJRadarSectionView getPointWithCenter:self.centerPoint arc:(index * 2 * M_PI / self.columnCount) radius:self.radius scale:scale];
        if (index == 0) {
            [path moveToPoint:point];
        }else {
            [path addLineToPoint:point];
        }
        
        if (index == self.columnCount - 1) {
            [path closePath];
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
