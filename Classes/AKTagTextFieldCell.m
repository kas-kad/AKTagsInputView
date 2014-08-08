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
        [self setup];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.textField = [[AKTextField alloc] initWithFrame:self.contentView.bounds];
    self.textField.frame = CGRectInset(_textField.frame, 0, 5);
    self.textField.autoresizingMask = UIViewAutoresizingFlexibleHeight  | UIViewAutoresizingFlexibleWidth;
    self.textField.buttonPlaceholder = NSLocalizedString(@"+ SOMETHING",@"");
    self.textField.autocorrectionType = UITextAutocorrectionTypeNo;
    [self.contentView addSubview:_textField];
}

@end
