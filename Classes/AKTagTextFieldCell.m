//
//  AKTagTextFieldCell.m
//
//  Created by Andrey Kadochnikov on 30.05.14.
//  Copyright (c) 2014 Andrey Kadochnikov. All rights reserved.
//

#import "AKTagTextFieldCell.h"
@implementation AKTagTextFieldCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _textField = [[AKTextField alloc] initWithFrame:self.contentView.bounds];
		_textField.frame = CGRectInset(_textField.frame, 0, 5);
		_textField.autoresizingMask = UIViewAutoresizingFlexibleHeight  | UIViewAutoresizingFlexibleWidth;
		_textField.buttonPlaceholder = @"+ Add";
		_textField.autocorrectionType = UITextAutocorrectionTypeNo;
		[self.contentView addSubview:_textField];
    }
    return self;
}
@end
