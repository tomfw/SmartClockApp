//
//  TimerViewController.h
//  SmartClock
//
//  Created by Thomas Williams on 11/14/17.
//  Copyright © 2017 Thomas Williams. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimerViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *minutesField;
@property (weak, nonatomic) IBOutlet UILabel *remainingLabel;
@property (nonatomic) bool running;
@end
