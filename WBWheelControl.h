//
//  WBWheelControl.h
//  WBWheelControl
//
//  Created by Scott Chandler on 2/3/11.
//  Copyright 2011 Wooly Beast Software, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WBWheelControlInfo;

enum {
	WBWheelControlTypeCustom = 0,
	WBWheelControlTypeDefault
} WBWheelControlType;

@interface WBWheelControl : UIControl {
@private
	CALayer *				_tintLayer;
	NSMutableDictionary *	_stateInfo;
	UIColor *				_tintColor;
    IBOutlet UIImageView *	_backgroundView;
    IBOutlet UIImageView *	_thumbView;						// optional thumb image. sized to width.
	
	WBWheelControlInfo *	_contentInfo;
    CGFloat                 _radius;						// radius of the wheel
    CGFloat                 _width;							// "thickness" of the wheel
    CGFloat                 _minimumValue;					// default 0.0
    CGFloat                 _maximumValue;					// default 1.0
    CGFloat                 _value;							// pinned to min/max
    BOOL                    _showThumbOnTouchesOnly;		// default=YES
    CGFloat                 _trackingScale;					// > 0.0
}

@property (nonatomic,readwrite) CGFloat radius;				// (outside) radius of the button
@property (nonatomic,readwrite) CGFloat width;				// width of the wheel

@property (nonatomic,readwrite) CGFloat minimumValue;
@property (nonatomic,readwrite) CGFloat maximumValue;
@property (nonatomic,readwrite) CGFloat value;

@property (nonatomic,strong) UIColor *tintColor;

@property (nonatomic,readwrite) BOOL showThumbOnTouchesOnly;

@property (nonatomic,assign) CGFloat trackingScale;

- (void)setThumbImage:(UIImage *)image forState:(UIControlState)state;
- (void)setBackgroundImage:(UIImage *)image forState:(UIControlState)state;

- (UIImage *)thumbImageForState:(UIControlState)state;
- (UIImage *)backgroundImageForState:(UIControlState)state;

@end
