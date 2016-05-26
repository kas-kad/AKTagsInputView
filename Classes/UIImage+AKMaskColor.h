//
//  UIImage+AKMaskColor.h
//  AKTagsInputViewExample
//
//  Created by Anton Gubarenko on 26.05.16.
//  Copyright © 2016 Andrey Kadochnikov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (AKMaskColor)

- (UIImage *) ak_fillAlphaMaskWithColor: (UIColor *) color;
@end
