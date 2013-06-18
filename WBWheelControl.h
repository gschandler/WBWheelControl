//
//  WBWheelControl.h
//
//	The MIT License (MIT)
//
//	Copyright (c) 2013 Wooly Beast Software
//
//	Permission is hereby granted, free of charge, to any person obtaining a copy
//	of this software and associated documentation files (the "Software"), to deal
//	in the Software without restriction, including without limitation the rights
//	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//	copies of the Software, and to permit persons to whom the Software is
//	furnished to do so, subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in
//	all copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//	THE SOFTWARE.
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
