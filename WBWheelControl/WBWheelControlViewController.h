//
//  WBWheelControlViewController.h
//  WBWheelControl
//
//  Created by Scott Chandler on 2/3/11.
//  Copyright 2011 Wooly Beast Software, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WBWheelControl.h"

@interface WBWheelControlViewController : UIViewController {
@private
	UILabel			*_eventsLabel;
    UILabel         *_valueLabel;
    WBWheelControl  *_wheelControl;
}


@property ( nonatomic, readonly, retain ) IBOutlet UILabel *eventsLabel;
@property ( nonatomic, readonly, retain ) IBOutlet UILabel *valueLabel;
@property ( nonatomic, readonly, retain ) IBOutlet WBWheelControl *wheelControl;

@end


@interface WBWheelControlViewController(Actions)
- (IBAction)touchDownEvent:(id)sender;
- (IBAction)touchDownRepeatEvent:(id)sender;
- (IBAction)touchDragInsideEvent:(id)sender;
- (IBAction)touchDragOutsideEvent:(id)sender;
- (IBAction)touchDragEnterEvent:(id)sender;
- (IBAction)touchDragExitEvent:(id)sender;
- (IBAction)touchUpInsideEvent:(id)sender;
- (IBAction)touchUpOutsideEvent:(id)sender;
- (IBAction)touchCancelEvent:(id)sender;
- (IBAction)valueChangedEvent:(id)sender;
@end
