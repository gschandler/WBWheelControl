//
//  WBWheelControlAppDelegate.h
//  WBWheelControl
//
//  Created by Scott Chandler on 2/3/11.
//  Copyright 2011 Wooly Beast Software, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WBWheelControlViewController;

@interface WBWheelControlAppDelegate : NSObject <UIApplicationDelegate> {
@private

}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet WBWheelControlViewController *viewController;

@end
