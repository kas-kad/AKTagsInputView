//
//  AKTagsLookup.h
//
//  Created by Andrey Kadochnikov on 30.05.14.
//  Copyright (c) 2014 Andrey Kadochnikov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AKTagsLookupDelegate.h"

@interface AKTagsLookup : UIView

@property (nonatomic, weak) id<AKTagsLookupDelegate> delegate;

-(id)initWithTags:(NSArray*)tags;
-(void)filterLookupWithPredicate:(NSPredicate*)predicate;

@end
