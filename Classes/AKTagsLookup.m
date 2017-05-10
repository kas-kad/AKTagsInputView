//
//  AKTagsLookup.m
//
//  Created by Andrey Kadochnikov on 30.05.14.
//  Copyright (c) 2014 Andrey Kadochnikov. All rights reserved.
//

#import "AKTagsLookup.h"
#import "AKTagsListView.h"

@interface AKTagsLookup () <AKTagsListViewDelegate>
{
	AKTagsListView *_tagsView;
	NSMutableArray *_tagsBase;
}
@end

@implementation AKTagsLookup

-(id)initWithTags:(NSArray *)tags
{
    
    //int height = (IS_IPAD)?44:144;
    int height = 144;
    
    self = [super initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), height)];
    if (self) {
		_tagsBase                   = [NSMutableArray arrayWithArray:tags];
		_tagsView                   = [[AKTagsListView alloc] initWithFrame:self.bounds];
        _tagsView.scrollDirection   = UICollectionViewScrollDirectionVertical;
		_tagsView.autoresizingMask  = UIViewAutoresizingFlexibleWidth;        
		_tagsView.selectedTags      = [NSMutableArray arrayWithArray:tags];
		_tagsView.backgroundColor   = [UIColor clearColor];
		_tagsView.collectionView.backgroundColor = [UIColor clearColor];
		_tagsView.delegate          = self;
		self.backgroundColor        = [UIColor colorWithRed:240.0f/255.0f green:240.0f/255.0f blue:240.0f/255.0f alpha:1];
		[self addSubview:_tagsView];
    }
    return self;
}

-(void)filterLookupWithPredicate:(NSPredicate *)predicate
{
	[_tagsView.collectionView performBatchUpdates:^{
		NSMutableArray *filteredTags = [[_tagsBase filteredArrayUsingPredicate:predicate] mutableCopy];
		_tagsView.selectedTags = filteredTags;
		[_tagsView.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];

	} completion:^(BOOL finished) {
		
	}];
}

-(void)tagsListView:(AKTagsListView *)tagsView didSelectTag:(NSString *)tag atIndexPath:(NSIndexPath *)indexPath
{
//	[_tagsView deleteItemAt:indexPath];
	if ([self.delegate respondsToSelector:@selector(tagsLookup:didSelectTag:)]){
		[self.delegate tagsLookup:self didSelectTag:tag];
	}
}
@end
