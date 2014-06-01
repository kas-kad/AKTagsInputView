//
//  NSString+StringsizeWithMyFont.m
//
//  Created by Andrey Kadochnikov on 29.11.13.
//  Copyright (c) 2013 Andrey Kadochnikov. All rights reserved.
//

#import "NSString+StringsizeWithFont.h"

@implementation NSString (StringsizeWithFont)


-(CGSize)ceiledSize:(CGSize)size{
	size.height = ceilf(size.height);
	size.width = ceilf(size.width);
	return size;
}

- (CGSize) sizeWithMyFont:(UIFont *)fontToUse
{
	NSDictionary* attribs = @{NSFontAttributeName:fontToUse};
	return [self ceiledSize:[self sizeWithAttributes:attribs]];
}

- (CGSize) sizeWithMyFont:(UIFont *)fontToUse constrainedToMySize:(CGSize)size
{
	CGRect textRect = [self boundingRectWithSize:size
										 options:NSStringDrawingUsesLineFragmentOrigin
									  attributes:@{NSFontAttributeName:fontToUse}
										 context:nil];
	return [self ceiledSize:textRect.size];
}
-(CGSize)sizeWithMyFont:(UIFont *)font forMyWidth:(CGFloat)width myLineBreakMode:(NSLineBreakMode)lineBreakMode{

	NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
	paragraphStyle.lineBreakMode = lineBreakMode;
	NSDictionary *attributes = @{ NSFontAttributeName: font,
								  NSParagraphStyleAttributeName: paragraphStyle };
	CGRect textRect = [self boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
										 options:NSStringDrawingUsesLineFragmentOrigin
									  attributes:attributes
										 context:nil];
	return [self ceiledSize:textRect.size];
}

-(CGSize)sizeWithMyFont:(UIFont *)font constrainedToMySize:(CGSize)size myLineBreakMode:(NSLineBreakMode)lineBreakMode{
	NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
	paragraphStyle.lineBreakMode = lineBreakMode;
	NSDictionary *attributes = @{ NSFontAttributeName: font,
								  NSParagraphStyleAttributeName: paragraphStyle };
	
	CGRect textRect = [self boundingRectWithSize:size
										 options:NSStringDrawingUsesLineFragmentOrigin
									  attributes:attributes
										 context:nil];
	return [self ceiledSize:textRect.size];
}

-(void)drawInRect:(CGRect)rect withMyFont:(UIFont *)fontToUse myColor:(UIColor*)color
{
	NSDictionary* attribs = @{NSFontAttributeName:fontToUse, NSForegroundColorAttributeName: color};
	[self drawInRect:rect withAttributes:attribs];
}

-(void)drawInRect:(CGRect)rect withMyFont:(UIFont *)font myLineBreakMode:(NSLineBreakMode)lineBreakMode myAlignment:(NSTextAlignment)alignment myColor:(UIColor*)color
{
	NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
	paragraphStyle.lineBreakMode = lineBreakMode;
	paragraphStyle.alignment = alignment;
	
	NSDictionary *attributes = @{ NSFontAttributeName: font,
								  NSParagraphStyleAttributeName: paragraphStyle,
								  NSForegroundColorAttributeName: color};
	
	
	[self drawInRect:rect withAttributes:attributes];
}
@end
