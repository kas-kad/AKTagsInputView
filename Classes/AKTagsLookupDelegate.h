//
//  AKTagsLookupDelegate.h
//  AKTagsInputViewExample
//
//  Created by Anton Gubarenko on 26.05.16.
//  Copyright © 2016 Andrey Kadochnikov. All rights reserved.
//

@class AKTagsLookup;

@protocol AKTagsLookupDelegate <NSObject>

-(void)tagsLookup:(AKTagsLookup*)lookup didSelectTag:(NSString*)tag;

@end