//
//  ClockViewController.h
//  SmartClock
//
//  Created by Thomas Williams on 11/14/17.
//  Copyright © 2017 Thomas Williams. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Particle-SDK.h"

@interface ClockViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *zoneLabel;
@property (nonatomic, weak) ParticleDevice *device;
@end
