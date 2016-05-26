//
//  AKTagsLayoutManager.m
//  AKTagsInputViewExample
//
//  Created by Anton Gubarenko on 26.05.16.
//  Copyright © 2016 Andrey Kadochnikov. All rights reserved.
//

#import "AKTagsLayoutManager.h"
#import "AKTagsDefines.h"

@implementation AKTagsLayoutManager

#pragma mark Singleton Methods

+ (instancetype) sharedManager
{
    static AKTagsLayoutManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id)init
{
    if (self = [super init])
    {
        self.tagBackgroundDefaultColor = [[UIColor lightGrayColor] colorWithAlphaComponent: 0.5f];
        self.tagTextDefaultColor = [UIColor darkGrayColor];
        
        self.tagSuggestionBackgroundColor = WK_COLOR_RED_TAG_COLOR;
        self.tagSuggestionTextColor = [UIColor whiteColor];
        self.tagSuggestionBorderColor = WK_COLOR_DARK_RED_TAG_COLOR;
        self.tagSuggestionBorderWidth = 1.0f;        
        
        self.lookupViewBackgroundColor = [UIColor whiteColor];
        
        self.deleteTagDefaultColor = [UIColor lightGrayColor];
        self.deleteTagConfirmColor = [UIColor redColor];
    }
    return self;
}
@end
