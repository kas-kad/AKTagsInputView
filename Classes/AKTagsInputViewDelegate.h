//
//  AKTagsInputViewDelegate.h
//  AKTagsInputViewExample
//
//  Created by Anton Gubarenko on 26.05.16.
//  Copyright © 2016 Andrey Kadochnikov. All rights reserved.
//

@class AKTagsInputView;

@protocol AKTagsInputViewDelegate <AKTagsListViewDelegate>

@optional
-(BOOL)validateTag:(NSString*)tagName;
-(void)tagsInputViewDidBeginEditing:(AKTagsInputView*)inputView;
-(void)tagsInputViewDidEndEditing:(AKTagsInputView*)inputView;
-(void)tagsInputViewDidAddTag:(AKTagsInputView*)inputView;
-(void)tagsInputViewDidRemoveTag:(AKTagsInputView*)inputView;

@end