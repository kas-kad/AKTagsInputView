//
//  AKTagsInputView.h
//
//  Created by Andrey Kadochnikov on 30.05.14.
//  Copyright (c) 2014 Andrey Kadochnikov. All rights reserved.
//

#import "AKTagsListView.h"
#define DEFAULT_FORBIDDEN_CHARS_STRING (@"!$%^&*+.") // these chars are standart hashtags forbidden ones, but I'd allow 'space' char

@class AKTagsInputView;
@protocol AKTagsInputViewDelegate <AKTagsListViewDelegate>
@optional
-(BOOL)validateTag:(NSString*)tagName;
-(void)tagsInputViewDidBeginEditing:(AKTagsInputView*)inputView;
-(void)tagsInputViewDidEndEditing:(AKTagsInputView*)inputView;
-(void)tagsInputViewDidAddTag:(AKTagsInputView*)inputView;
-(void)tagsInputViewDidRemoveTag:(AKTagsInputView*)inputView;
@end

@interface AKTagsInputView : AKTagsListView

@property (nonatomic, weak) id<AKTagsInputViewDelegate> delegate;
/**
 Forbidden chars are defined by default charstring: '!$%^&*+.' Which are default for hashtag standart.
 But unlike the standart the 'space' symbol is allowed to use in tags name.
 */
@property (nonatomic, strong) NSString* forbiddenCharsString;

/**
 The property by default is set to 'NO'.
 You can finish and insert particular tag into a list of selected tags by typing ',' coma symbol.
 Space symbol by default can be used in tag's name (unlikely hashtags manner).
 Set this property to 'YES' if you want to separate your tags with 'space' symbol.
 */
@property (nonatomic, assign) BOOL separateTagsWithSpaceSymbol;

/**
 
 */
@property (nonatomic, assign) BOOL enableTagsLookup;
@property (nonatomic, strong) NSArray *lookupTags;
@end
