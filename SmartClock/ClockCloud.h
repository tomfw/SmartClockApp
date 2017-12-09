//
//  ClockCloud.h
//  SmartClock
//
//  Created by Thomas Williams on 12/2/17.
//  Copyright © 2017 Thomas Williams. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ParticleCloud.h"
#import "Particle-SDK.h"

@class ClockCloud;

@protocol ClockCloudDelegate <NSObject>
@optional
-(void)devicesUpdatedForCloud:(ClockCloud*)cloud;
-(void)gotValue:(id)value forVariable:(NSString *)variableName inCloud:(ClockCloud*)cloud;
-(void)function:(NSString*)funcName returned:(int)returnVal inCloud:(ClockCloud*)cloud;
-(void)variable:(NSString*)variable updatedInCloud:(ClockCloud*)cloud;
@end

@interface ClockCloud : NSObject

@property (strong, nonatomic) NSString* userName;
@property (strong, nonatomic) NSArray* devices;
@property (strong, nonatomic) ParticleDevice *currentDevice;
@property (weak) id<ClockCloudDelegate> delegate;

//particle variables
@property (nonatomic) int currentMode;
@property (nonatomic) NSTimeInterval timerStart;
@property (nonatomic) NSTimeInterval timerEnd;
@property (nonatomic) int timeZone;
@property (strong, nonatomic) NSString *city;
@property (strong, nonatomic) NSString *state;

-(void)add;
-(void)connectAs:(NSString *)uName withPassword:(NSString *)password;
-(void)loadDevices;
-(void)getVariable:(NSString*)variableName;
-(void)callFunction:(NSString*)funcName withArgs:(NSArray *)args;
-(void)setMode:(NSString*)mode;
-(void)_updateAllVariables;
-(void)_updateVariable:(NSString *)var value:(id)value;
-(void)_requestVariable:(NSString *)var;
+(ClockCloud*)cloud;
@end
