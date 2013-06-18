//
//  WBWheelControl.m
//  WBWheelControl
//
//  Created by Scott Chandler on 2/3/11.
//  Copyright 2011 Wooly Beast Software, LLC. All rights reserved.
//

#import "WBWheelControl.h"
#import <QuartzCore/QuartzCore.h>

// UITouch extensions
@interface UITouch(WBWheelControl)
- (CGPoint)locationRelativeToCenterInView:(UIView *)view;
- (CGPoint)previousLocationRelativeToCenterInView:(UIView *)view;
@end


// Utility functions
static CGFloat  LineLength( CGPoint start, CGPoint end );
static CGPoint  UnitVector( CGPoint vector );
static CGPoint	ResizeVector( CGPoint vector, CGFloat length );
static CGPoint	CGPointOffset( CGPoint point, CGFloat dx, CGFloat dy );

// NSDictionary key generation functions
static id ThumbImageKeyForState( UIControlState state );
static id BackgroundImageKeyForState( UIControlState state );


@interface WBWheelControl()
@property (nonatomic,strong,readonly) IBOutlet UIImageView *backgroundView;
@property (nonatomic,strong,readonly) IBOutlet UIImageView *thumbView;
@property (nonatomic,readonly) CGPoint wheelCenter;
@property (nonatomic,readonly) CGFloat outerRadius;
@property (nonatomic,readonly) CGFloat innerRadius;
@property (nonatomic,readonly) CGFloat middleRadius;
@property (nonatomic,strong,readonly) CALayer *	tintLayer;

- (void)trackTouch:(UITouch *)touch;
- (void)configureControl;
- (BOOL)pointIsInside:(CGPoint)point;
@end

@interface WBWheelControl(Tint)
- (void)addTintLayer;
- (void)removeTintLayer;
- (void)layoutTintLayer;
@end

@interface WBWheelControl(Thumb)
- (void)resizeThumb;
@end




@implementation WBWheelControl
@synthesize backgroundView=_backgroundView;
@synthesize thumbView=_thumbView;
@synthesize trackingScale=_trackingScale;
@synthesize radius=_radius;
@synthesize width=_width;
@synthesize value=_value;
@synthesize maximumValue=_maximumValue;
@synthesize minimumValue=_minimumValue;
@synthesize showThumbOnTouchesOnly=_showThumbOnTouchesOnly;
@synthesize tintColor=_tintColor;


//
//	Method:
//
//
//	Synopsis:
//
//
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if ( self ) {
        [self configureControl];
    }
    return self;
}

//
//	Method:
//
//
//	Synopsis:
//
//
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if ( self ) {
        [self configureControl];
    }
    return self;
}


//
//	Method:
//
//
//	Synopsis:
//
//
- (void)dealloc
{
    [_backgroundView release];
    [_thumbView release];
	[_contentInfo release];
	[_stateInfo release];
    [super dealloc];
}

//
//	Method:	
//		outerRadius
//
//	Synopsis:
//		Calculates and returns the outer radius of our track. Exactly the same as ivar radius.
//
- (CGFloat)outerRadius
{
	return _radius;
}

//
//	Method:	
//		innerRadius
//
//	Synopsis:
//		Calculates and returns the inner radius of our track
//
- (CGFloat)innerRadius
{
	return self.outerRadius - _width;
}

//
//	Method:
//		middleRadius
//
//	Synopsis:
//		Calculates and returns the radius of the circle that lies in the middle of our track.
//
- (CGFloat)middleRadius
{
	return (self.innerRadius + self.outerRadius)/2.0;
}

//
//	Method:	
//		
//
//	Synopsis:
//		
//
- (void)setTrackingScale:(CGFloat)scale
{
	NSParameterAssert(scale>=0.0);
	_trackingScale = MAX(0.0,scale);
}

//
//	Method:	
//		setRadius:
//
//	Synopsis:
//		
//
- (void)setRadius:(CGFloat)radius
{
    if ( radius != _radius ) {
//        CGPoint wheelCenter = self.wheelCenter;
//        CGPoint thumbCenter = self.thumbView.center;
//        thumbCenter = ResizeVector(wheelCenter.x, wheelCenter.y, thumbCenter.x, thumbCenter.y,radius);
//        self.thumbView.center = thumbCenter;
        _radius = radius;
		
		if ( self.tintLayer ) {
			[self layoutTintLayer];
		}
    }    
}


//
//	Method:	
//		setWidth:
//
//	Synopsis:
//		Sets the width of our track, which in turn determines the inner radius.
//
- (void)setWidth:(CGFloat)width
{
	CGFloat normalizedWidth = MIN(width,self.radius);
    
    if ( normalizedWidth != _width ) {
        _width = width;
		[self resizeThumb];
    }
}

//
//	Method:	
//		
//
//	Synopsis:
//		
//
- (void)setMinimumValue:(CGFloat)minimumValue
{
    _minimumValue = minimumValue;
    [self setValue:MAX(minimumValue,self.value)];
}

//
//	Method:	
//		
//
//	Synopsis:
//		
//
- (void)setMaximumValue:(CGFloat)maximumValue
{
    _maximumValue = maximumValue;
    [self setValue:MIN(maximumValue,self.value)];
}

//
//	Method:	
//		
//
//	Synopsis:
//		
//
- (void)setValue:(CGFloat)value
{
	CGFloat normalizedValue = MAX(_minimumValue,MIN(value,_maximumValue));
    _value = normalizedValue;
}

//
//	Method:	
//		
//
//	Synopsis:
//		
//
- (void)setShowThumbOnTouchesOnly:(BOOL)show
{
    if ( show != _showThumbOnTouchesOnly ) {
        self.thumbView.hidden = !show;
        _showThumbOnTouchesOnly = show;
    }
}


//
//	Method:	
//		
//
//	Synopsis:
//		
//

- (void)setTintColor:(UIColor *)color
{
	if ( color != _tintColor ) {
		[_tintColor release];
		_tintColor = [color retain];
		
		if ( _tintColor ) {
			[self addTintLayer];
		}
		else {
			[self removeTintLayer];
		}
	}
}

//
//	Method:	
//		wheelCenter
//
//	Synopsis:
//		
//
- (CGPoint)wheelCenter
{
	CGPoint center = [self convertPoint:self.center fromView:self.superview];
	return center;
}

//
//	Method:	
//		pointIsInside:
//
//	Synopsis:
//		
//
- (BOOL)pointIsInside:(CGPoint)point
{
	CGFloat length = LineLength( CGPointZero, point);
	return (length <= self.outerRadius && length >= self.innerRadius);
}

//
//	Method:	
//		
//
//	Synopsis:
//		
//
- (void)configureControl
{
    _trackingScale = 0.25;
	_showThumbOnTouchesOnly = YES;
	_radius = MIN(CGRectGetWidth(self.bounds),CGRectGetHeight(self.bounds));
	_stateInfo = [NSMutableDictionary new];
	
	[self setThumbImage:self.thumbView.image forState:UIControlStateNormal];
	[self setBackgroundImage:self.backgroundView.image forState:UIControlStateNormal];
}

//
//	Method:	
//		
//
//	Synopsis:
//		
//
- (void)layoutSubviews
{
	[super layoutSubviews];
	if ( _radius <= 0.0 ) {
		self.radius = MIN(CGRectGetWidth(self.bounds),CGRectGetHeight(self.bounds))/2.0;
		self.width = (self.thumbView) ? MAX(CGRectGetWidth(self.thumbView.bounds),CGRectGetHeight(self.thumbView.bounds)) : 44.0;
	}
	self.thumbView.hidden = !self.tracking && _showThumbOnTouchesOnly;
}

#pragma mark Drawing
//
//	Method:	
//		
//
//	Synopsis:
//		
//
#if 0
- (void)drawRect:(CGRect)rect
{
	[super drawRect:rect];
	if ( self.backgroundView.image == nil ) {
		CGContextRef context = UIGraphicsGetCurrentContext();
		UIGraphicsPushContext(context);
		CGPoint center = self.wheelCenter;
		[[UIColor lightGrayColor] setFill];
		[[UIColor darkGrayColor] setStroke];
		UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center
															radius:self.radius 
														startAngle:0.0 
														  endAngle:2.0 * M_PI 
														 clockwise:YES];
		[path closePath];
		[path appendPath:[UIBezierPath bezierPathWithArcCenter:center
						radius:self.radius-self.width
					startAngle:0.0
					  endAngle:2.0 * M_PI
					 clockwise:NO]];
		 
		[path closePath];
		[path fill];
		[path stroke];
		UIGraphicsPopContext();
	}
}
#endif
#pragma mark Touching

//
//	Method:	
//		touchesBegan:withEvent:
//
//	Synopsis:
//		
//
- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
	NSLog(@"%@",NSStringFromSelector(_cmd));
    BOOL tracking = [super beginTrackingWithTouch:touch withEvent:event];
    CGPoint location = [touch previousLocationRelativeToCenterInView:self];
	tracking = [self pointIsInside:location];
    [self trackTouch:touch];
	return tracking;
}

//
//	Method:	
//		touchesMoved:withEvent:
//
//	Synopsis:
//		
//
enum {
	kInsideFlag = 1 << 0,
	kPreviouslyInsideFlag = 1 << 1
};

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
	NSLog(@"%@",NSStringFromSelector(_cmd));
    BOOL tracking = [super continueTrackingWithTouch:touch withEvent:event];
    if ( tracking ) {
        [self trackTouch:touch];
        
        CGPoint location = [touch locationRelativeToCenterInView:self];		
        CGPoint previousLocation = [touch previousLocationRelativeToCenterInView:self];
		
		CGFloat	middleRadius = (self.innerRadius + self.outerRadius)/2.0;
        
		location = ResizeVector(location, middleRadius);
		previousLocation = ResizeVector(previousLocation, middleRadius);
                
        // the vector length
        CGFloat length = LineLength(previousLocation,location);
        
        // Our circular direction based on using 3-space cross product, but setting z=0 (u3 and v3 in vectors u and v):
        // u x v = (u2v3 - u3v2,u3v1 - u1v3,u1v2 - u2v1)
        // the resulting vector looks like:
        // (0,0, ±z)
        // if z < 0, we are moving CCW
        // if z > 0, we are moving CW
        // if z = 0, we are stoned
        CGFloat direction = (previousLocation.x * location.y) - (previousLocation.y * location.x);
        direction /= fabsf(direction);
        
		CGFloat delta = (length * direction) * _trackingScale;
		CGFloat oldValue = self.value;
		self.value = oldValue + delta;
		
		if ( oldValue != self.value ) {
			[self sendActionsForControlEvents:UIControlEventValueChanged];
		}
        
    }    
    return tracking;
}

//
//	Method:	
//		touchesEnded:withEvent:
//
//	Synopsis:
//		
//
- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
	NSLog(@"%@",NSStringFromSelector(_cmd));
    [super endTrackingWithTouch:touch withEvent:event];
    [self trackTouch:touch];
}

//
//	Method:	
//		touchesCancelled:withEvent:
//
//	Synopsis:
//		
//
- (void)cancelTrackingWithEvent:(UIEvent *)event
{
	NSLog(@"%@",NSStringFromSelector(_cmd));
    [super cancelTrackingWithEvent:event];
}

//
//	Method:	
//		
//
//	Synopsis:
//		
//
- (void)trackTouch:(UITouch *)touch
{
    self.thumbView.hidden = !self.tracking;
    if ( self.tracking ) {
        CGFloat radius = ((_radius * 2.0) - _width) / 2.0;
        CGPoint location = [touch locationRelativeToCenterInView:self];
		CGPoint thumbCenter = ResizeVector(location, radius);
		thumbCenter = CGPointOffset(thumbCenter,self.wheelCenter.x,self.wheelCenter.y);
        self.thumbView.center = thumbCenter;
//		NSLog(@"%@ %@",NSStringFromCGPoint(thumbCenter),NSStringFromCGRect(self.thumbView.bounds));
    }
}

//
//	Method:	
//		
//
//	Synopsis:
//		
//
- (void)setThumbImage:(UIImage *)image forState:(UIControlState)state
{
	NSAssert(_stateInfo,@"Invalid NSMutableDictionary data (nil)");
	
	id key = ThumbImageKeyForState(state);
	NSAssert(key,@"Invalid key (nil)");
	
	if ( image == nil ) {
		[_stateInfo removeObjectForKey:key];
	}
	else {
		[_stateInfo setObject:image forKey:key];
	}
}

//
//	Method:	
//		
//
//	Synopsis:
//		
//
- (void)setBackgroundImage:(UIImage *)image forState:(UIControlState)state
{
	NSAssert(_stateInfo,@"Invalid NSMutableDictionary data (nil)");
	
	id key = BackgroundImageKeyForState(state);
	NSAssert(key,@"Invalid key (nil)");
	
	if ( image == nil ) {
		[_stateInfo removeObjectForKey:key];
	}
	else {
		[_stateInfo setObject:image forKey:key];
	}
}


//
//	Method:	
//		
//
//	Synopsis:
//		
//
- (UIImage *)thumbImageForState:(UIControlState)state
{
	NSAssert(_stateInfo,@"Invalid NSMutableDictionary data (nil)");
	id key = ThumbImageKeyForState(state);
	UIImage *image = [_stateInfo objectForKey:key];
	if ( image == nil ) {
		key = ThumbImageKeyForState(UIControlStateNormal);
		image = [_stateInfo objectForKey:key];
	}
	return image;
}

//
//	Method:	
//		
//
//	Synopsis:
//		
//
- (UIImage *)backgroundImageForState:(UIControlState)state
{
	NSAssert(_stateInfo,@"Invalid NSMutableDictionary data (nil)");
	id key = BackgroundImageKeyForState(state);
	UIImage *image = [_stateInfo objectForKey:key];
	if ( image == nil ) {
		key = BackgroundImageKeyForState(UIControlStateNormal);
		image = [_stateInfo objectForKey:key];
	}
	return image;
}

@end


@implementation UITouch(WBWheelControl)
//
//	Method:	
//		
//
//	Synopsis:
//		
//
- (CGPoint)locationRelativeToCenterInView:(UIView *)view
{
	CGPoint location = [self locationInView:view];
	CGPoint center = CGPointMake(CGRectGetMidX(view.bounds),CGRectGetMidY(view.bounds));
	location = CGPointOffset(location, -center.x, -center.y);
	return location;
}

//
//	Method:	
//		
//
//	Synopsis:
//		
//
- (CGPoint)previousLocationRelativeToCenterInView:(UIView *)view
{
	CGPoint location = [self previousLocationInView:view];
	CGPoint center = CGPointMake(CGRectGetMidX(view.bounds),CGRectGetMidY(view.bounds));
	location = CGPointOffset(location, -center.x, -center.y);
	return location;
}

@end



@implementation WBWheelControl(Tint)
//
//	Method:
//
//
//	Synopsis:
//
//
- (CALayer *)tintLayer
{
	if ( _tintLayer == nil ) {
		_tintLayer = [[CALayer layer] retain];
	}
	return _tintLayer;
}

//
//	Method:
//
//
//	Synopsis:
//
//
- (void)addTintLayer
{
	CALayer *layer = self.tintLayer;
	layer.backgroundColor = [self.tintColor CGColor];
	layer.opacity = 0.25;
	[self.layer addSublayer:layer];
	[self layoutTintLayer];
}

//
//	Method:
//
//
//	Synopsis:
//
//
- (void)removeTintLayer
{
	[self.tintLayer removeFromSuperlayer];
}

//
//	Method:
//
//
//	Synopsis:
//
//
- (void)layoutTintLayer
{
	self.tintLayer.cornerRadius = self.radius;
	self.tintLayer.frame = self.bounds;
}

@end


@implementation WBWheelControl(Thumb)
- (void)resizeThumb
{
	CGRect rect = self.thumbView.bounds;
	CGFloat aspect = rect.size.width / rect.size.height;
	if ( rect.size.width > self.width ) {
		rect.size.width = self.width;
		rect.size.height = self.width * aspect;
	}
	else {
		rect.size.height = self.width;
		rect.size.width = self.width / aspect;
	}
	self.thumbView.bounds = rect;
	
}
@end



// NSDictionary key generation functions

//
//	Method:
//
//
//	Synopsis:
//
//
static id ThumbImageKeyForState( UIControlState state )
{
	id key = [NSString stringWithFormat:@"Thumb-%d",state];
	return key;
}

//
//	Method:
//
//
//	Synopsis:
//
//
static id	BackgroundImageKeyForState( UIControlState state )
{
	id key = [NSString stringWithFormat:@"Background-%d",state];
	return key;
}


// Utility vector and point functions


static CGFloat  LineLength( CGPoint start, CGPoint end )
{
    CGFloat dx = end.x - start.x;
    CGFloat dy = end.y - start.y;
    CGFloat result = sqrtf((dx*dx) + (dy*dy));
    return result;
}

static CGPoint  UnitVector( CGPoint vector )
{
    CGFloat length = LineLength(CGPointZero,vector);
    vector.x = (length>0.0) ? vector.x/length : 0.0;
    vector.y = (length>0.0) ? vector.y/length : 0.0;
    return vector;
}

static CGPoint ResizeVector( CGPoint vector, CGFloat length )
{
    vector = UnitVector(vector);
    vector.x *= length;
    vector.y *= length;
    return vector;
}

static CGPoint	CGPointOffset( CGPoint point, CGFloat dx, CGFloat dy )
{
	point.x += dx;
	point.y += dy;
	return point;
}
