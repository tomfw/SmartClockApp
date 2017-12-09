//
//  TimerViewController.m
//  SmartClock
//
//  Created by Thomas Williams on 11/14/17.
//  Copyright © 2017 Thomas Williams. All rights reserved.
//

#import "TimerViewController.h"
#import "ClockCloud.h"
@interface TimerViewController () <ClockCloudDelegate, UITextFieldDelegate>
{
	NSTimer *_timerUpdate;
}

@end

@implementation TimerViewController

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	return NO;
}

-(void)variable:(NSString *)variable updatedInCloud:(ClockCloud *)cloud {
	[self updateUIFromCloud];
}

-(void)updateUIFromCloud {
	ClockCloud *cloud = [ClockCloud cloud];
}

-(void)function:(NSString *)funcName returned:(int)returnVal inCloud:(ClockCloud *)cloud {
	if([funcName isEqualToString:@"setMode"]) {
		NSLog(@"We should be in timer mode...");
	} else if([funcName isEqualToString:@"setNewTimer"]) {
		NSLog(@"I think we set a timer?");
	}
}
- (IBAction)setButtonPressed:(id)sender {
	[self.minutesField resignFirstResponder];
	double min = self.minutesField.text.doubleValue;
	NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
	
	if(min) {
		NSString *arg = [NSString stringWithFormat:@"%d~%d", (int)now, (int)now + (int)(min * 60)];
		NSLog(@"Sending: %@", arg);
		[[ClockCloud cloud] callFunction:@"setNewTimer" withArgs:@[arg]];
	}
}
- (IBAction)clearButtonPressed:(id)sender {
	[self.minutesField resignFirstResponder];
	[[ClockCloud cloud] callFunction:@"setNewTimer" withArgs:@[@"0~100"]];
}
- (IBAction)stoppedEditing:(id)sender {
	[self.minutesField resignFirstResponder];
}

-(void)updateClock {
	ClockCloud *cloud = [ClockCloud cloud];
	NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
	NSString *remainingStr;
	if(cloud.timerEnd > now) {
		NSString *unit = @"s";
		double r = cloud.timerEnd - now;
		if(r > 60 * 60) {
			r /= (60*60);
			unit = @"h";
		} else if(r > 60) {
			r /= 60;
			unit = @"m";
		}
		remainingStr = [NSString stringWithFormat:@"%.2f%@",r, unit];
	} else if(cloud.timerStart != 0) {
		remainingStr = @"DONE";
	} else {
		remainingStr = @"-";
	}
	self.remainingLabel.text = remainingStr;
}

- (IBAction)selectButtonPressed:(id)sender {
	[[ClockCloud cloud] setMode:@"timer"];
	[[ClockCloud cloud] setDelegate:self];
}

-(void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:YES];
	[[ClockCloud cloud] setDelegate:self];
	[self updateClock];
}


- (void) awakeFromNib {
	[super awakeFromNib];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	_timerUpdate = [NSTimer scheduledTimerWithTimeInterval:1.0f
													target:self
												  selector:@selector(updateClock)
												  userInfo:nil
												   repeats:YES];
	self.minutesField.delegate = self;

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
