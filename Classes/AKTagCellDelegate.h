//
//  AKTagCellDelegate.h
//  AKTagsInputViewExample
//
//  Created by Anton Gubarenko on 26.05.16.
//  Copyright © 2016 Andrey Kadochnikov. All rights reserved.
//

@class AKTagCell;

@protocol AKTagCellDelegate <NSObject>

-(void)tagCellDidPressedDelete:(AKTagCell*)cell;

@end