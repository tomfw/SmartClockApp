//
//  ViewController.m
//  SmartClock
//
//  Created by Thomas Williams on 11/14/17.
//  Copyright © 2017 Thomas Williams. All rights reserved.
//

#import "LoginViewController.h"
#import "MainTabController.h"
#import "ParticleCloud.h"
#import "ClockCloud.h"

#define DEV_USER  @"thomasforsythewilliams@gmail.com"
#define DEV_PASS  @""

@interface LoginViewController () <ClockCloudDelegate>

@end

@implementation LoginViewController

- (void)devicesUpdatedForCloud:(ClockCloud *)cloud {
	NSLog(@"We got the device list!");
	UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
	MainTabController *mtc = [board instantiateViewControllerWithIdentifier:@"MainTabController"];
	[self presentViewController:mtc animated:YES completion:nil];
}

- (IBAction)loginButtonPressed:(UIButton *)sender {

	[[ClockCloud cloud] setDelegate:self];
	if(self.userNameField.hasText && self.passwordField.hasText) {
	[[ClockCloud cloud] connectAs:self.userNameField.text
					 withPassword:self.passwordField.text];
	} else { //dev mode... login without credentials
		[[ClockCloud cloud] connectAs:DEV_USER withPassword:DEV_PASS];
	}
	
}

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	NSLog(@"Login controller, mane!");
}


- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}


@end
