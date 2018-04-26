
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

- (IBAction)reload:(id)sender {
    [self.radarView reloadData];
}

#pragma mark - DataSource
//每个角的数值
- (NSInteger)numberOfStepForRadarView:(CJRadarView *)radarView {
    return 3;
}

- (NSArray *)dataListForRadarView:(CJRadarView *)radarView {
//    return  @[@[@(1),@(2),@(3),@(4),@(1),@(2),@(3),@(4)]];
    return @[@[@(6),@(3.5),@(2.5),@(1)],@[@(2),@(2),@(2),@(2)]];
//              ,@[@(6),@(3.5),@(2.5),@(1)],@[@(2),@(2),@(2),@(2)]];//,@[@(4),@(3),@(2),@(1)]]
}

- (NSArray *)titleOfRowForRadarView:(CJRadarView *)radarView {
    return @[@"标题1", @"标题2", @"标题3", @"标题4"];
}


- (NSInteger)maxValueOfRadarView:(CJRadarView *)radarView {
    return 5;
}

@end
