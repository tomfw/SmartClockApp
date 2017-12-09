//
//  ClockCloud.m
//  SmartClock
//
//  Created by Thomas Williams on 12/2/17.
//  Copyright © 2017 Thomas Williams. All rights reserved.
//

#import "ClockCloud.h"

@interface ClockCloud () <ClockCloudDelegate> {
	int _counter;
	NSTimer *_updateVarsTimer;
}
@end

@implementation ClockCloud

-(void)setMode:(NSString *)mode {
	[self callFunction:@"setMode" withArgs:@[mode]];
}

-(void)callFunction:(NSString *)funcName withArgs:(NSArray *)args {
	NSURLSessionDataTask *task = [self.currentDevice callFunction:funcName withArguments:args completion:^(NSNumber * resultCode, NSError *error) {
		if(!error) {
			NSLog(@"We returned from function....");
			if([self.delegate respondsToSelector:@selector(function:returned:inCloud:)]) {
				[self.delegate function:funcName returned:resultCode.intValue inCloud:self];
			}
		} else {
			//TODO: delegate error function...
			NSLog(@"Error: %@", error);
		}
	}];
}

-(void)getVariable:(NSString*)variableName {
	[self.currentDevice getVariable:variableName completion:^(id result, NSError *error) {
		if(!error) {
			if([self.delegate respondsToSelector:@selector(gotValue:forVariable:inCloud:)]) {
				[self.delegate gotValue:result forVariable:variableName inCloud:self];
			}
		} else {
			//TODO: call delegate error function
		}
	}];
}


-(void)loadDevices {
	[[ParticleCloud sharedInstance] getDevices:^(NSArray *devices, NSError *error) {
		NSLog(@"%@",devices.description);
		self.currentDevice = devices.firstObject;
		self.devices = devices;
		for (ParticleDevice *device in devices) {
			NSLog(@"%@ %@", device.id, device.name);
			if([device.name isEqualToString:@"clock_photon"]) {
				self.currentDevice = device;
				[self _updateAllVariables]; //load the vars as soon as we have device
			}
		}
		if([self.delegate respondsToSelector:@selector(devicesUpdatedForCloud:)]) {
			[self.delegate devicesUpdatedForCloud:self];
		}
	}];
}

-(void)_updateAllVariables {
	[self _requestVariable:@"timeZone"];
	[self _requestVariable:@"mode"];
	[self _requestVariable:@"timerStart"];
	[self _requestVariable:@"timerEnd"];
	[self _requestVariable:@"city"];
	[self _requestVariable:@"state"];
}

-(void)_updateVariable:(NSString *)var value:(id)value {
	if([var isEqualToString:@"timeZone"]) {
		self.timeZone = [(NSNumber*)value intValue];
	}
	
	if([var isEqualToString:@"mode"]) {
		self.currentMode = [(NSNumber*)value intValue];
	}
	if([var isEqualToString:@"timerStart"]) {
		self.timerStart = [(NSNumber*)value doubleValue];
	}
	if([var isEqualToString:@"timerEnd"]) {
		self.timerEnd = [(NSNumber*)value doubleValue];
	}
	if([var isEqualToString:@"city"]) {
		self.city = (NSString*)value;
	}
	if([var isEqualToString:@"state"]) {
		self.state = (NSString*)value;
	}
	
	if([self.delegate respondsToSelector:@selector(variable:updatedInCloud:)]) {
		[self.delegate variable:var updatedInCloud:self];
	}
}

-(void)_requestVariable:(NSString *)var {
	[self.currentDevice getVariable:var completion:^(id result, NSError *error) {
		if(!error) {
			[self _updateVariable:var value:result];
		} else {
			NSLog(@"Cloud var fetch problem: %@", error);
		}
	}];
}

-(void)connectAs:(NSString *)uName withPassword:(NSString *)password {
	[[ParticleCloud sharedInstance] loginWithUser:uName password:password completion:^(NSError *error) {
		if(!error) {
			NSLog(@"We are logged into the cloud!!");
			[self loadDevices];
		} else {
			NSLog(@"Error: %@", error);
		}
	}];
}

-(void)add {
	NSLog(@"The counter is: %d", ++_counter);
}

+(ClockCloud*)cloud {
	static ClockCloud *_cloud = nil;
	static dispatch_once_t onceToken;
	
	dispatch_once(&onceToken, ^{
		_cloud = [[self alloc] init];
	});
	return _cloud;
}

-(id)init {
	if ( self = [super init]) {
		NSLog(@"You will only see this once!");
		_updateVarsTimer = [NSTimer scheduledTimerWithTimeInterval:10.0f
															target:self
														  selector:@selector(_updateAllVariables)
														  userInfo:nil
														   repeats:YES];
	}
	return self;
}
@end
