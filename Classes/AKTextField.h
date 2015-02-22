//
//  AKTextField.h
//
//  Created by Andrey Kadochnikov on 02.06.14.
//  Copyright (c) 2014 Andrey Kadochnikov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AKTextField : UITextField
@property (nonatomic, strong) NSString *buttonPlaceholder;
@property (nonatomic, strong) UIColor *buttonPlaceholderColor;
@property (nonatomic, readonly) NSString *tagName;
@end
