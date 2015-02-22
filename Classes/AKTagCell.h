//
//  AKTagCell.h
//
//  Created by Andrey Kadochnikov on 30.05.14.
//  Copyright (c) 2014 Andrey Kadochnikov. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AKTagCell;
@protocol AKTagCellDelegate <NSObject>
-(void)tagCellDidPressedDelete:(AKTagCell*)cell;
@end

@interface AKTagCell : UICollectionViewCell
@property (nonatomic, strong) UIButton *deleteButton;
@property (nonatomic, strong) UILabel *tagLabel;
@property (nonatomic, strong) NSString *tagName;
@property (nonatomic, assign) BOOL showDeleteButton;
@property (nonatomic, weak) id <AKTagCellDelegate> delegate;
@property (nonatomic, readonly) BOOL isReadyForDelete;
-(void)prepareForDelete;
-(void)resetReadyForDeleteStatus;
+(CGSize)preferredSizeWithTag:(NSString*)tag deleteButtonEnabled:(BOOL)deleteButtonEnabled;
@end
