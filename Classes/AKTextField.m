//
//  AKTextField.m
//
//  Created by Andrey Kadochnikov on 02.06.14.
//  Copyright (c) 2014 Andrey Kadochnikov. All rights reserved.
//

#import "AKTextField.h"
#import "NSString+StringSizeWithFont.h"

@interface AKTextField ()

@property (nonatomic) BOOL shouldDrawPlaceholder;

@end

@implementation AKTextField

#pragma mark - Init -

-(id)init
{
	return nil; //do not allow this
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup
{
	self.buttonPlaceholderColor = [UIColor colorWithWhite:0.8f alpha:1.0f];
	self.shouldDrawPlaceholder = NO;
}

#pragma mark -

-(BOOL)becomeFirstResponder
{
	BOOL result = [super becomeFirstResponder];
	[self _updateShouldDrawPlaceholder];
	return result;
}

-(BOOL)resignFirstResponder
{
	BOOL result = [super resignFirstResponder];
	[self _updateShouldDrawPlaceholder];
	return result;
}

- (void)setButtonPlaceholder:(NSString *)str
{
	if ([str isEqual:_buttonPlaceholder]) {
		return;
	}
	_buttonPlaceholder = str;
	[self _updateShouldDrawPlaceholder];
}

- (void)_updateShouldDrawPlaceholder
{
	BOOL prev = self.shouldDrawPlaceholder;
	self.shouldDrawPlaceholder = !self.isFirstResponder;
	if (prev != self.shouldDrawPlaceholder) {
		[self setNeedsDisplay];
	}
}

- (void)drawRect:(CGRect)rect
{
	[super drawRect:rect];
	
	if (self.shouldDrawPlaceholder) {
		CGSize stringSize = [self.buttonPlaceholder sizeWithMyFont: self.font];
		CGFloat stringWidth = stringSize.width;
		CGFloat stringHeigth = stringSize.height;
		CGRect stringRect = CGRectMake(8, CGRectGetMidY(rect) - stringHeigth/2, stringWidth, stringHeigth);
		[self.buttonPlaceholder drawInRect:stringRect withMyFont:self.font myColor:_buttonPlaceholderColor];
		
		CGContextRef context = UIGraphicsGetCurrentContext();
		CGContextSetStrokeColorWithColor(context, self.buttonPlaceholderColor.CGColor);
		CGContextSetLineWidth(context, 1);
		CGFloat dashLengths[] = { 5, 3 };
		CGContextSetLineDash(context, 0, dashLengths, 2);
		CGContextStrokeRect(context, CGRectMake(1, 6, 8 + stringWidth + 8, 22));
	}
}

@end
