//
//  NSString+StringsizeWithFont.h
//
//  Created by Andrey Kadochnikov on 29.11.13.
//  Copyright (c) 2013 Andrey Kadochnikov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (StringsizeWithFont)


-(CGSize)sizeWithMyFont:(UIFont *)fontToUse;
-(CGSize)sizeWithMyFont:(UIFont *)fontToUse constrainedToMySize:(CGSize)size;
-(CGSize)sizeWithMyFont:(UIFont *)font constrainedToMySize:(CGSize)size myLineBreakMode:(NSLineBreakMode)lineBreakMode;
-(CGSize)sizeWithMyFont:(UIFont *)font forMyWidth:(CGFloat)width myLineBreakMode:(NSLineBreakMode)lineBreakMode;

-(void)drawInRect:(CGRect)rect withMyFont:(UIFont *)fontToUse myColor:(UIColor*)color;
-(void)drawInRect:(CGRect)rect withMyFont:(UIFont *)font myLineBreakMode:(NSLineBreakMode)lineBreakMode myAlignment:(NSTextAlignment)alignment myColor:(UIColor*)color;

@end
