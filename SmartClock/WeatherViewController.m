//
//  WeatherViewController.m
//  SmartClock
//
//  Created by Thomas Williams on 11/14/17.
//  Copyright © 2017 Thomas Williams. All rights reserved.
//

#import "WeatherViewController.h"
#import "ClockCloud.h"

@interface WeatherViewController () <ClockCloudDelegate, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate> {
	NSTimer *_timer;
	NSArray *_temperatures;
	NSArray *_probabilities;
}
-(void)updateWeather;
@end

@implementation WeatherViewController
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	return NO;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"forecastCell"];
	int temp = [(NSNumber*)_temperatures[indexPath.row] intValue];
	int pop = [(NSNumber*)_probabilities[indexPath.row] intValue];
	cell.textLabel.font = [UIFont fontWithName:@"helvetica" size:16];
	cell.textLabel.text = [NSString stringWithFormat:@"+%02.0f h: %d degrees\t%d%%", (double)indexPath.row, temp, pop];
	cell.backgroundColor = [UIColor clearColor];
	return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return _temperatures ? _temperatures.count : 0;
}

-(void)variable:(NSString *)variable updatedInCloud:(ClockCloud *)cloud {
	[self updateUIFromCloud];
}

-(void)updateUIFromCloud {
	ClockCloud *cloud = [ClockCloud cloud];
	if(!self.cityField.hasText || !self.stateField.hasText) {
		self.cityField.text = cloud.city;
		self.stateField.text = cloud.state;
	}
}


-(void)gotValue:(id)value forVariable:(NSString *)variableName inCloud:(ClockCloud *)cloud {
	NSString *eventString = (NSString*)value;
	NSString *weatherString;
	if([variableName isEqualToString:@"weather_data"]) {
		NSRange range = [eventString rangeOfString:@"data:"];
		NSUInteger start = range.location + range.length + 1;
		NSUInteger len = eventString.length - start;
		weatherString = [eventString substringWithRange:NSMakeRange(start, len)];
		NSArray *tempsAndPops = [weatherString componentsSeparatedByString:@"~"];
		NSMutableArray *temps = [NSMutableArray array];
		NSMutableArray *pops = [NSMutableArray array];
		for(NSUInteger i = 0; i < tempsAndPops.count - 1; i+=2) {
			[pops addObject:tempsAndPops[i]];
			[temps addObject:tempsAndPops[i+1]];
		}
		_temperatures = [temps copy];
		_probabilities = [pops copy];
		[self.forecastTable reloadData];
		[self.loadingIndicator stopAnimating];

	}
}

-(void)function:(NSString *)funcName returned:(int)returnVal inCloud:(ClockCloud *)cloud {
	if([funcName isEqualToString:@"setMode"]) {
		NSLog(@"We should be in weather mode...");
	}
	if([funcName isEqualToString:@"setCity"]) {
		NSLog(@"City probably updated?");
	}
}

- (IBAction)changeLocationPressed:(id)sender {
	NSString *city = self.cityField.text;
	NSString *state = self.stateField.text;
	if(city && state) {
		NSLog(@"Update location: %@, %@", city, state);
		[[ClockCloud cloud] callFunction:@"setCity"
								withArgs:@[[NSString stringWithFormat:@"%@~%@", city, state]]];
		[[ClockCloud cloud] setDelegate: self];
	}
}

- (IBAction)selectButtonPressed:(id)sender {
	[[ClockCloud cloud] setMode:@"weather"];
	[[ClockCloud cloud] setDelegate:self];
}

-(void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[[ClockCloud cloud] setDelegate:self];
	[self updateUIFromCloud];
}

-(void)updateWeather {
	[[ClockCloud cloud] getVariable:@"weather_data"];
	[self.loadingIndicator startAnimating];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	_timer = [NSTimer scheduledTimerWithTimeInterval:15.0f target:self selector:@selector(updateWeather) userInfo:nil repeats:YES];
	self.forecastTable.delegate = self;
	self.forecastTable.dataSource = self;
	self.cityField.delegate = self;
	self.stateField.delegate = self;
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
