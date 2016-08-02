//
//  CJRadarView.h
//  radarView
//
//  Created by Carl Ji on 16/8/1.
//  Copyright © 2016年 Carl Ji. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CJRadarView;

@protocol CJRadarViewDelegate <NSObject>



@end

@protocol CJRadarViewDataSource <NSObject>

- (NSInteger)maxValueOfRadarView:(CJRadarView *)radarView;

- (NSInteger)numberOfStepForRadarView:(CJRadarView *)radarView;

- (NSInteger)numberOfSectionForRadarView:(CJRadarView *)radarView;

- (NSInteger)numberOfRowForRadarView:(CJRadarView *)radarView;

- (NSString *)titleOfRowForRadarView:(CJRadarView *)radarView;

- (NSArray *)RadarView:(CJRadarView *)radarView valuesInSection:(NSInteger)index;

@end

IB_DESIGNABLE
@interface CJRadarView : UIView <CJRadarViewDataSource>

@property (nonatomic, strong)IBInspectable UIColor *lineColor;

@property (nonatomic, assign)IBInspectable BOOL enableBgColorFade;

@property (nonatomic, weak) id <CJRadarViewDataSource> dataSource;

- (void)reloadData;

@end
