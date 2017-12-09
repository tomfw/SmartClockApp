//
//  MainTabController.m
//  SmartClock
//
//  Created by Thomas Williams on 11/14/17.
//  Copyright © 2017 Thomas Williams. All rights reserved.
//

#import "MainTabController.h"
#import "Particle-SDK.h"
#import "ClockViewController.h"
@interface MainTabController ()
@property (nonatomic) ParticleDevice *currentDevice;
@property (nonatomic) ClockViewController *clockView;
@end

@implementation MainTabController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
