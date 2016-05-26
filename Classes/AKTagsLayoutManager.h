//
//  AKTagsLayoutManager.h
//  AKTagsInputViewExample
//
//  Created by Anton Gubarenko on 26.05.16.
//  Copyright © 2016 Andrey Kadochnikov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AKTagsLayoutManager : NSObject

+ (instancetype) sharedManager;

@property (nonatomic, strong) UIColor *tagBackgroundDefaultColor;
@property (nonatomic, strong) UIColor *tagTextDefaultColor;

@property (nonatomic, strong) UIColor *tagSuggestionBackgroundColor;
@property (nonatomic, strong) UIColor *tagSuggestionTextColor;
@property (nonatomic, strong) UIColor *tagSuggestionBorderColor;
@property (nonatomic, assign) CGFloat tagSuggestionBorderWidth;

@property (nonatomic, strong) UIColor *lookupViewBackgroundColor;

@property (nonatomic, strong) UIColor *deleteTagDefaultColor;
@property (nonatomic, strong) UIColor *deleteTagConfirmColor;

@end
