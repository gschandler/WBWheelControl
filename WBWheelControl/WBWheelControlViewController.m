//
//  WBWheelControlViewController.m
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

#import "WBWheelControlViewController.h"

@interface WBWheelControlViewController()
- (void)updateValueLabel;
- (void)updateEventLabel:(UIControlEvents)events;
@end

@implementation WBWheelControlViewController
@synthesize  valueLabel=_valueLabel;
@synthesize eventsLabel=_eventsLabel;
@synthesize	wheelControl=_wheelControl;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
	[_wheelControl release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
    self.wheelControl.minimumValue = 0.0;
	self.wheelControl.maximumValue = 360.0;
	self.wheelControl.value = 180.0;
	self.wheelControl.tintColor = [UIColor redColor];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	[self updateValueLabel];
}

- (void)updateValueLabel
{
	NSUInteger value = lrintf(self.wheelControl.value);
	self.valueLabel.text = [NSString stringWithFormat:@"%d", value];
}

- (void)updateEventLabel:(UIControlEvents)events
{
	NSArray *titles = [NSArray array];
    if ( events & UIControlEventTouchDown )
		titles = [titles arrayByAddingObject:@"UIControlEventTouchDown"];
    if ( events & UIControlEventTouchDownRepeat )
		titles = [titles arrayByAddingObject:@"UIControlEventTouchDownRepeat"];
    if ( events & UIControlEventTouchDragInside )
		titles = [titles arrayByAddingObject:@"UIControlEventTouchDragInside"];
    if ( events & UIControlEventTouchDragOutside )
		titles = [titles arrayByAddingObject:@"UIControlEventTouchDragOutside"];
    if ( events & UIControlEventTouchDragEnter )
		titles = [titles arrayByAddingObject:@"UIControlEventTouchDragEnter"];
    if ( events & UIControlEventTouchDragExit )
		titles = [titles arrayByAddingObject:@"UIControlEventTouchDragExit"];
    if ( events & UIControlEventTouchUpInside )
		titles = [titles arrayByAddingObject:@"UIControlEventTouchUpInside"];
    if ( events & UIControlEventTouchUpOutside )
		titles = [titles arrayByAddingObject:@"UIControlEventTouchUpOutside"];
    if ( events & UIControlEventTouchCancel )
		titles = [titles arrayByAddingObject:@"UIControlEventTouchCancel"];
    if ( events & UIControlEventValueChanged )
		titles = [titles arrayByAddingObject:@"UIControlEventValueChanged"];
	
	NSString *text = [titles componentsJoinedByString:@"+"];
//	self.eventsLabel.text = text;
	NSLog(@"%@",text);
}
@end

@implementation WBWheelControlViewController(Actions)
- (IBAction)touchDownEvent:(id)sender
{
	[self updateEventLabel:UIControlEventTouchDown];
}
- (IBAction)touchDownRepeatEvent:(id)sender
{
	[self updateEventLabel:UIControlEventTouchDownRepeat];
}
- (IBAction)touchDragInsideEvent:(id)sender
{
	[self updateEventLabel:UIControlEventTouchDragInside];
}
- (IBAction)touchDragOutsideEvent:(id)sender
{
	[self updateEventLabel:UIControlEventTouchDragOutside];
}
- (IBAction)touchDragEnterEvent:(id)sender
{
	[self updateEventLabel:UIControlEventTouchDragEnter];
}
- (IBAction)touchDragExitEvent:(id)sender
{
	[self updateEventLabel:UIControlEventTouchDragExit];
}
- (IBAction)touchUpInsideEvent:(id)sender
{
	[self updateEventLabel:UIControlEventTouchUpInside];
}
- (IBAction)touchUpOutsideEvent:(id)sender
{
	[self updateEventLabel:UIControlEventTouchUpOutside];
}
- (IBAction)touchCancelEvent:(id)sender
{
	[self updateEventLabel:UIControlEventTouchCancel];
}
- (IBAction)valueChangedEvent:(id)sender
{
	[self updateEventLabel:UIControlEventValueChanged];
	[self updateValueLabel];
}
@end