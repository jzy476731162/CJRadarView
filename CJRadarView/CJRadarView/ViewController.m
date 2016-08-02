//
//  ViewController.m
//  CJRadarView
//
//  Created by Carl Ji on 16/8/1.
//  Copyright © 2016年 Carl Ji. All rights reserved.
//

#import "ViewController.h"
#import "CJRadarView.h"

#import "CJRadarSectionView.h"


@interface ViewController () <CJRadarViewDataSource>
@property (weak, nonatomic) IBOutlet CJRadarView *radarView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.radarView.dataSource = self;
    
    CJRadarSectionView *newView = [CJRadarSectionView defaultStyleWithSectionData:@[@(1),@(2),@(3),@(1)] centerPoint:CGPointMake(200, 200) radius:50 columnCount:4 maxValue:5];
    newView.frame = CGRectMake(200, 200, 200, 200);
    
    [self.view addSubview:newView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - DataSource
- (NSInteger)numberOfRowForRadarView:(CJRadarView *)radarView {
    return 4;
}

- (NSInteger)numberOfStepForRadarView:(CJRadarView *)radarView {
    return 3;
}

- (NSInteger)numberOfSectionForRadarView:(CJRadarView *)radarView {
    return 1;
}


- (NSArray *)RadarView:(CJRadarView *)radarView valuesInSection:(NSInteger)index {
    return @[@[@(1),@(2),@(3),@(4)],@[@(4),@(3),@(2),@(1)]][index];
}

- (NSInteger)maxValueOfRadarView:(CJRadarView *)radarView {
    return 5;
}

@end
