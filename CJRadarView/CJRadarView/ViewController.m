
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
@property (strong, nonatomic) IBOutlet CJRadarView *radarView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.radarView.dataSource = self;
    [self.radarView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - DataSource
//角数
- (NSInteger)numberOfRowForRadarView:(CJRadarView *)radarView {
    return 30;
}
//每个角的数值
- (NSInteger)numberOfStepForRadarView:(CJRadarView *)radarView {
    return 3;
}

- (NSArray *)dataListForRadarView:(CJRadarView *)radarView {
    return  @[@[@(1),@(2),@(3),@(4)],@[@(6),@(3.5),@(2.5),@(1)],@[@(2),@(2),@(2),@(2)]];//,@[@(4),@(3),@(2),@(1)]]
}


- (NSInteger)maxValueOfRadarView:(CJRadarView *)radarView {
    return 5;
}

@end
