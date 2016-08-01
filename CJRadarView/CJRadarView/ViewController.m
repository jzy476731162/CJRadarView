//
//  ViewController.m
//  CJRadarView
//
//  Created by Carl Ji on 16/8/1.
//  Copyright © 2016年 Carl Ji. All rights reserved.
//

#import "ViewController.h"
#import "CJRadarView.h"


@interface ViewController () <CJRadarViewDataSource>
@property (weak, nonatomic) IBOutlet CJRadarView *radarView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.radarView.dataSource = self;
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

@end
