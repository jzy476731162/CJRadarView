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


static const NSInteger CJRadarViewBorderWidth = 10;

@interface CJRadarView ()

@property (nonatomic, assign) CGPoint centerPoint;
@property (nonatomic, assign) CGFloat radius;

@property (nonatomic, assign) CGFloat lineSpacing;
@property (nonatomic, assign) CGFloat arcAngle;

@property (nonatomic, assign) NSInteger stepNum;
@property (nonatomic, assign) NSInteger rowNum;
@property (nonatomic, assign) NSInteger sectionNum;
@property (nonatomic, strong) NSArray *numList;

@property (nonatomic, strong) NSNumber *maxValue;

@property (nonatomic, strong) NSMutableArray <CJRadarSectionView *>*viewList;
@end

@implementation CJRadarView

- (NSMutableArray<CJRadarSectionView *> *)viewList {
    if (!_viewList) {
        _viewList = [NSMutableArray new];
    }
    return _viewList;
}

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
    self.stepNum = [self.dataSource numberOfStepForRadarView:self] ? : 1;
    self.rowNum = [self.dataSource numberOfRowForRadarView:self];
    self.numList = [self.dataSource dataListForRadarView:self];
    self.sectionNum = self.numList.count;
    self.maxValue = @([self.dataSource maxValueOfRadarView:self]);
    [self cleaningData:self.numList maxValue:self.maxValue rowNumber:@(self.rowNum)];
    
    self.lineSpacing = self.radius/ self.stepNum;
    self.arcAngle = M_PI * 2/self.rowNum;
}

- (void)cleaningData:(NSArray *)dataList maxValue:(NSNumber *)max rowNumber:(NSNumber *)row{
    //获取最大值
    NSNumber *rowNumber = row;
    for (NSArray *list in dataList) {
        for (NSNumber *num in list) {
            if ([num compare:self.maxValue] == NSOrderedDescending) {
                self.maxValue = num;
            }
        }
        if (list.count > [rowNumber integerValue]) {
            rowNumber = @(list.count);
        }
    }
    self.rowNum = [rowNumber integerValue];
    
    NSMutableArray *newList = [NSMutableArray new];
    for (NSArray *list in dataList) {
        NSMutableArray *partList = [NSMutableArray new];
        for (NSInteger i = 0; i < [rowNumber integerValue]; i++) {
            if (i < list.count) {
                [partList addObject:list[i]];
            }else {
                [partList addObject:@(0)];
            }
        }
        [newList addObject:partList];
    }
    self.numList = (NSArray *)newList;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //  Draw bottom Dash Line
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
        CGFloat dash[] = {1, 1};
        [path setLineDash:dash count:1 phase:0];
        
        
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
        CGFloat lineDash[] = {1, 1};
        CGContextSetLineDash(context, 0, lineDash, 1);
        CGContextStrokePath(context);
    }
    CGContextRestoreGState(context);
    
    //Draw Content View
}

- (void)reloadData {
    [self resetRadarData];
    
    [self setNeedsDisplay];
    
    for (UIView *view in self.viewList) {
        [view removeFromSuperview];
    }
    
    for (NSUInteger i = 0; i < self.sectionNum; i++) {
        if (self.viewList.count >= i) {
            CJRadarSectionView *view = [CJRadarSectionView defaultStyleWithSectionData:self.numList[i] radius:self.radius maxValue:[self.maxValue floatValue] frame:self.bounds];
            [self.viewList addObject:view];
            [self addSubview:view];
            
        }else {
            [self.viewList[i] reloadRadarSectionViewWithData:self.numList[i] radius:self.radius maxValue:[self.maxValue floatValue]];
            [self addSubview:self.viewList[i]];
        }
    }
}

@end

