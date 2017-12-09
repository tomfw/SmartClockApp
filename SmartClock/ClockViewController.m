//
//  ClockViewController.m
//  SmartClock
//
//  Created by Thomas Williams on 11/14/17.
//  Copyright © 2017 Thomas Williams. All rights reserved.
//

#import "ClockViewController.h"
#import "ClockCloud.h"

@interface ClockViewController () <ClockCloudDelegate>

@end

@implementation ClockViewController

-(void)variable:(NSString *)variable updatedInCloud:(ClockCloud *)cloud {
	[self updateUIFromCloud];
}


-(void)updateUIFromCloud {
	ClockCloud *cloud = [ClockCloud cloud];
	self.zoneLabel.text = [NSString stringWithFormat:@"%d", cloud.timeZone];
}

-(void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:YES];
	[[ClockCloud cloud] setDelegate:self];
	[self updateUIFromCloud];
}
-(void)function:(NSString *)funcName returned:(int)returnVal inCloud:(ClockCloud *)cloud {
	if([funcName isEqualToString:@"setZone"]) {
		NSLog(@"We probably changed zones...");
	}
}

- (IBAction)changeZoneClicked:(id)sender {
	int zone = self.zoneLabel.text.intValue;
	[[ClockCloud cloud] callFunction:@"setZone"
							withArgs:@[[NSString stringWithFormat:@"%d", zone]]];
	[[ClockCloud cloud] setDelegate:self];
}

- (IBAction)setButtonPressed:(UIButton *)sender {
	ClockCloud *cloud = [ClockCloud cloud];
	[cloud callFunction:@"setMode" withArgs:@[@"clock"]];
	[cloud setDelegate:self];
}
- (IBAction)zoneSelectorChanged:(UIStepper *)sender {
	self.zoneLabel.text = [NSString stringWithFormat:@"%d", (int)sender.value];
}

- (void) awakeFromNib {
	[super awakeFromNib];
	NSLog(@"Clock View Y'all");
	[[ClockCloud cloud] add];
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
