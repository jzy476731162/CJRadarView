//
//  CJRadarView.m
//  radarView
//
//  Created by Carl Ji on 16/8/1.
//  Copyright © 2016年 Carl Ji. All rights reserved.
//

#import "CJRadarView.h"
#import <math.h>

#import "CJRadarSectionView.h"

static const NSInteger CJRadarViewBorderWidth = 2;

@interface CJRadarView ()

@property (nonatomic, assign) CGPoint centerPoint;
@property (nonatomic, assign) CGFloat radius;

@property (nonatomic, assign) CGFloat lineSpacing;
@property (nonatomic, assign) CGFloat arcAngle;

@property (nonatomic, assign) NSInteger stepNum;
@property (nonatomic, assign) NSInteger rowNum;
@property (nonatomic, assign) NSInteger sectionNum;

@property (nonatomic, assign) NSNumber *maxValue;

@property (nonatomic, strong) NSMutableArray *viewList;
@end

@implementation CJRadarView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _centerPoint = CGPointMake(frame.size.width/2, frame.size.height/2);
        if (frame.size.width > frame.size.height) {
            _radius = frame.size.height/2 - CJRadarViewBorderWidth;
        }else {
            _radius = frame.size.width/2 - CJRadarViewBorderWidth;
        }
        
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        _centerPoint = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        if (self.frame.size.width > self.frame.size.height) {
            _radius = self.frame.size.height/2 - CJRadarViewBorderWidth;
        }else {
            _radius = self.frame.size.width/2 - CJRadarViewBorderWidth;
        }
    }
    return self;
}

- (UIColor *)lineColor {
    if (!_lineColor) {
        _lineColor = [UIColor blueColor];
    }
    return _lineColor;
}


- (void)resetRadarData {
    NSInteger stepNum;
    NSInteger rowNum;
    NSInteger sectionNum;
    NSNumber * defaultMaxValue;
    if (self.dataSource) {
        stepNum = [self.dataSource numberOfStepForRadarView:self] ? : 1;
        rowNum = [self.dataSource numberOfRowForRadarView:self] > 2 ? [self.dataSource numberOfRowForRadarView:self]: 3;
        sectionNum = [self.dataSource numberOfSectionForRadarView:self] ? : 1;
        defaultMaxValue = [self.dataSource maxValueOfRadarView:self] ? @([self.dataSource maxValueOfRadarView:self]) :@(10);
    }else {
        stepNum = 1;
        rowNum = 3;
        sectionNum = 1;
        defaultMaxValue = @(10);
    }
    
    
    self.stepNum = stepNum;
    self.rowNum = rowNum;
    self.sectionNum = sectionNum;
    
    self.maxValue = defaultMaxValue;
    if (!self.maxValue) {
        for (int sectionIndex = 0; sectionIndex < sectionNum; sectionIndex++) {
            NSArray *arr = [self.dataSource RadarView:self valuesInSection:sectionIndex];
            for (NSNumber *number in arr) {
                if ([number compare:self.maxValue] == NSOrderedAscending) {
                    self.maxValue = number;
                }
            }
        }
    }
    
    self.lineSpacing = self.radius/stepNum;
    self.arcAngle = M_PI * 2/rowNum;
}

- (void)drawRect:(CGRect)rect {
    [self resetRadarData];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(context);
    for (int i = 0; i < self.stepNum; i++) {
        UIBezierPath *path = [UIBezierPath bezierPath];
        CGPoint startPoint = CGPointMake(self.centerPoint.x, self.centerPoint.y - self.radius + (self.lineSpacing * i));
        [path moveToPoint:startPoint];
        
        for (int row = 0; row <= self.rowNum; row ++) {
            CGFloat currentAngle = self.arcAngle * row;
            
            CGPoint endPoint = CGPointMake(self.centerPoint.x + sin(currentAngle) * (self.radius - i * self.lineSpacing), self.centerPoint.y - cos(currentAngle) * (self.radius - i * self.lineSpacing));
            [path addLineToPoint:endPoint];
        }
        
        
        if (self.enableBgColorFade) {
            const CGFloat *colors = CGColorGetComponents([self.lineColor CGColor]);
            [[UIColor colorWithRed:colors[0] green:colors[1] blue:colors[2] alpha:0.5/self.stepNum] setFill];
            [path fill];
        }
       
        
        [self.lineColor setStroke];
        [path setLineWidth:1];
        
        [path stroke];
    }
    
    for (int row = 0; row < self.rowNum; row ++) {
        CGFloat currentAngle = self.arcAngle * row;
        
        CGPoint endPoint = CGPointMake(self.centerPoint.x + sin(currentAngle) * self.radius, self.centerPoint.y - cos(currentAngle) * self.radius);
        CGContextMoveToPoint(context, self.centerPoint.x, self.centerPoint.y);
        CGContextAddLineToPoint(context, endPoint.x, endPoint.y);
        CGContextSetStrokeColorWithColor(context, [self.lineColor CGColor]);
        CGContextStrokePath(context);
    }
    CGContextRestoreGState(context);
    
}

- (void)reloadData {
    [self setNeedsDisplay];
    
    if ([self.viewList count] != self.sectionNum) {
        
    }else {
        
    }
}





@end
