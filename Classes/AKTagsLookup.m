//
//  AKTagsLookup.m
//
//  Created by Andrey Kadochnikov on 30.05.14.
//  Copyright (c) 2014 Andrey Kadochnikov. All rights reserved.
//

#import "AKTagsLookup.h"
#import "AKTagsListView.h"

@interface AKTagsLookup () <AKTagsListViewDelegate>

@property (strong, nonatomic) AKTagsListView *tagsView;
@property (strong, nonatomic) NSMutableArray *tagsBase;

@end

@implementation AKTagsLookup

-(id)initWithTags:(NSArray *)tags
{
    self = [super initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), 44)];
    if (self) {
		self.tagsBase = [NSMutableArray arrayWithArray:tags];
        
        // tags view
		self.tagsView = [[AKTagsListView alloc] initWithFrame:self.bounds];
		self.tagsView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		self.tagsView.selectedTags = [NSMutableArray arrayWithArray:tags];
		self.tagsView.backgroundColor = [UIColor clearColor];
		self.tagsView.collectionView.backgroundColor = [UIColor clearColor];
		self.tagsView.delegate = self;
		self.backgroundColor = [UIColor clearColor];
		[self addSubview:self.tagsView];
    }
    return self;
}

-(void)filterLookupWithPredicate:(NSPredicate *)predicate
{
	[self.tagsView.collectionView performBatchUpdates:^{
		NSMutableArray *filteredTags = [[self.tagsBase filteredArrayUsingPredicate:predicate] mutableCopy];
		self.tagsView.selectedTags = filteredTags;
		[self.tagsView.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];

	} completion:NULL];
}

-(void)tagsListView:(AKTagsListView *)tagsView didSelectTag:(NSString *)tag atIndexPath:(NSIndexPath *)indexPath
{
	if ([self.delegate respondsToSelector:@selector(tagsLookup:didSelectTag:)]){
		[self.delegate tagsLookup:self didSelectTag:tag];
	}
}
@end
