//
//  WeatherViewController.h
//  SmartClock
//
//  Created by Thomas Williams on 11/14/17.
//  Copyright © 2017 Thomas Williams. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeatherViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *cityField;
@property (weak, nonatomic) IBOutlet UITextField *stateField;
@property (weak, nonatomic) IBOutlet UITableView *forecastTable;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;

@end
