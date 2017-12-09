//
//  SettingsViewController.m
//  SmartClock
//
//  Created by Thomas Williams on 11/14/17.
//  Copyright © 2017 Thomas Williams. All rights reserved.
//

#import "SettingsViewController.h"
#import "ClockCloud.h"

@interface SettingsViewController () <ClockCloudDelegate>

@end

@implementation SettingsViewController

-(void)function:(NSString *)funcName returned:(int)returnVal inCloud:(ClockCloud *)cloud {
	if([funcName isEqualToString:@"setMode"]) {
		NSLog(@"We might be off...");
	}
}


- (IBAction)offButtonPressed:(id)sender {
	[[ClockCloud cloud] setMode:@"off"];
	[[ClockCloud cloud] setDelegate:self];
}

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
