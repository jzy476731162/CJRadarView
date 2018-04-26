//
//  CJRadarSectionView.m
//  CJRadarView
//
//  Created by Carl Ji on 16/8/2.
//  Copyright © 2016年 Carl Ji. All rights reserved.
//

#import "CJRadarSectionView.h"
#import "NSString+FormattedNumber.h"

@interface CJRadarSectionView()
@property (nonatomic, strong) UIBezierPath *path;
@property (nonatomic, strong) NSMutableArray <CATextLayer *>*valueLayers;
@end

@implementation CJRadarSectionView

- (NSMutableArray<CATextLayer *> *)valueLayers {
    if (!_valueLayers) {
        _valueLayers = [NSMutableArray new];
    }
    return _valueLayers;
}

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
    
    [radar animation];
    return radar;
}

- (instancetype)reloadRadarSectionViewWithData:(NSArray *)data radius:(CGFloat)radius maxValue:(CGFloat)maxValue{
    self.data = data;
    self.radius = radius;
    self.columnCount = data.count;
    [self resetMaxValue:data Max:maxValue];
    
    [self animation];
//    [UIView animateWithDuration:0.1 animations:^{
//         [self layoutIfNeeded];
//        self.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);
//    }];
   
    
    return self;
}

- (void)animation {
    self.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.2, 0.2);
    [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self layoutIfNeeded];
        self.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);
    } completion:nil];
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
        
        CGFloat arc = (index * 2 * M_PI / self.columnCount);
        CGPoint point = [CJRadarSectionView getPointWithCenter:self.centerPoint arc:arc radius:self.radius scale:scale];
        
        CATextLayer *layer;
        if (index < self.valueLayers.count) {
            layer = self.valueLayers[index];
        }else {
            layer = [CATextLayer layer];
            UIFont *font = [UIFont systemFontOfSize:10];
            CFStringRef fontName = (__bridge CFStringRef)font.fontName;
            CGFontRef fontRef = CGFontCreateWithFontName(fontName);
            [layer setContentsScale:[UIScreen mainScreen].scale];
            [layer setFont:fontRef];
            [layer setFontSize:font.pointSize];
            [layer setForegroundColor:[UIColor redColor].CGColor];
            
            CGFloat yValue =  point.y - 10 * cos(arc) - 5;
            
            layer.frame = CGRectMake(point.x + 5 * sin(arc) - 2.5, yValue, 40, 10);
            
            [layer setContentsScale:[UIScreen mainScreen].scale * 2];
            CGFontRelease(fontRef);
            [self.valueLayers addObject:layer];
        }
        
        [layer setString:[NSString formattedFloatString:[self.data[index] floatValue]]];
        [self.layer addSublayer:layer];
        
        
        if (index == 0) {
            [path moveToPoint:point];
        }else {
            [path addLineToPoint:point];
        }
        
        if (index == self.columnCount - 1) {
            [path closePath];
        }
    }
    UIColor *lineColor = [UIColor colorWithRed:arc4random()%255/255 green:arc4random()%255/255 blue:arc4random()%255/255 alpha:0.7];
    UIColor *contentColor = [UIColor colorWithRed:arc4random()%255/255 green:arc4random()%255/255 blue:arc4random()%255/255 alpha:0.6];
    [lineColor setStroke];
    [contentColor setFill];
    
    [path fill];
    [path stroke];
    
    self.path = path;
    
}

#pragma mark - Touch Event
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.superview bringSubviewToFront:self];
    [UIView animateWithDuration:0.2 animations:^{
        self.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.15, 1.15);
    }];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [UIView animateWithDuration:0.2 animations:^{
        self.transform = CGAffineTransformIdentity;
    } completion:nil];
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    CGPoint convertedPoint = [self convertPoint:point fromView:self.superview];
    if ([self.path containsPoint:convertedPoint]) {
        return true;
    }
    return false;
}

//- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    NSLog(@"touchCancelled");
//}



@end
