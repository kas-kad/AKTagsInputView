//
//  AKTagsListViewDelegate.h
//  AKTagsInputViewExample
//
//  Created by Anton Gubarenko on 27.05.16.
//  Copyright © 2016 Andrey Kadochnikov. All rights reserved.
//

@class AKTagsListView;

@protocol AKTagsListViewDelegate <NSObject>

-(void)tagsListView:(AKTagsListView*)tagsView didSelectTag:(NSString*)tag atIndexPath:(NSIndexPath*)indexPath;

@end