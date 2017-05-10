//
//  UIImage+AKMaskColor.m
//  AKTagsInputViewExample
//
//  Created by Anton Gubarenko on 26.05.16.
//  Copyright © 2016 Andrey Kadochnikov. All rights reserved.
//

#import "UIImage+AKMaskColor.h"

@implementation UIImage (AKMaskColor)

- (UIImage *) ak_fillAlphaMaskWithColor: (UIColor *) color
{
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, self.scale);
    CGContextRef c = UIGraphicsGetCurrentContext();
    [self drawInRect:rect];
    CGContextSetFillColorWithColor(c, [color CGColor]);
    CGContextSetBlendMode(c, kCGBlendModeSourceAtop);
    CGContextFillRect(c, rect);
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return result;
}

@end
