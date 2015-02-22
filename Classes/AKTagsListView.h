//
//  AKTagsListView.h
//
//  Created by Andrey Kadochnikov on 30.05.14.
//  Copyright (c) 2014 Andrey Kadochnikov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AKTagCell.h"

#define CONTENT_LEFT_MARGIN 15.0f

@class AKTagsListView;
@protocol AKTagsListViewDelegate <NSObject>
-(void)tagsListView:(AKTagsListView*)tagsView didSelectTag:(NSString*)tag atIndexPath:(NSIndexPath*)indexPath;
@end

@interface AKTagsListView : UIView
<
AKTagCellDelegate,
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout
>
@property (nonatomic, weak) id<AKTagsListViewDelegate> delegate;

/**
 The property defines whether tags can be deleted from the list or not.
 If the property is set to 'YES' the delete button is displayed on the left of tag's name.
 */
@property (nonatomic, assign) BOOL allowDeleteTags;
@property (nonatomic, strong) UICollectionView *collectionView;

/**
 The property defines tags contained in collection.
 */
@property (nonatomic, strong) NSMutableArray *selectedTags;

-(void)addNewItemWithString:(NSString *)string completion:(void(^)(void))completion;
-(void)configureCell:(UICollectionViewCell*)cell atIndexPath:(NSIndexPath*)indexPath;
-(void)deleteItemAt:(NSIndexPath *)indexPath  completion:(void(^)(void))completion;
@end
