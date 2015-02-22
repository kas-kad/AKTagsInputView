//
//  AKTagsListView.m
//
//  Created by Andrey Kadochnikov on 30.05.14.
//  Copyright (c) 2014 Andrey Kadochnikov. All rights reserved.
//
#import "AKTagsDefines.h"
#import "AKTagsListView.h"
#import "NSString+StringSizeWithFont.h"

@implementation AKTagsListView

- (id)initWithFrame:(CGRect)frame
{
	frame.size.height = 44;
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.collectionView];
		_selectedTags = [NSMutableArray array];
    }
    return self;
}

-(UICollectionView*)collectionView
{
	if (!_collectionView){
		UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
		flow.scrollDirection = UICollectionViewScrollDirectionHorizontal;
		flow.minimumLineSpacing = 10;
		flow.minimumInteritemSpacing = 10;
		flow.scrollDirection = UICollectionViewScrollDirectionHorizontal;
		
		_collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flow];
		_collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
		_collectionView.dataSource = self;
		_collectionView.backgroundColor = [UIColor whiteColor];
		_collectionView.allowsMultipleSelection = NO;
		_collectionView.delegate = self;
		_collectionView.showsHorizontalScrollIndicator = NO;
		_collectionView.showsVerticalScrollIndicator = NO;
		[_collectionView registerClass:[AKTagCell class] forCellWithReuseIdentifier:@"tagsViewCell"];
	}
	return _collectionView;
}

#pragma mark - Cell delegate
-(void)tagCellDidPressedDelete:(AKTagCell *)cell
{
	NSIndexPath *indexPath = [_collectionView indexPathForCell:cell];
	[self deleteItemAt:indexPath completion:nil];
}

#pragma mark - CV Layout
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, CONTENT_LEFT_MARGIN, 0, 0);
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
	return [AKTagCell preferredSizeWithTag:self.selectedTags[indexPath.row] deleteButtonEnabled:self.allowDeleteTags];
}

#pragma mark - CV Delegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
	if ([self.delegate respondsToSelector:@selector(tagsListView:didSelectTag:atIndexPath:)]){
		[self.delegate tagsListView:self didSelectTag:self.selectedTags[indexPath.row] atIndexPath:indexPath];
	}
}

#pragma mark - CV Datasource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
	return self.selectedTags.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	AKTagCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"tagsViewCell" forIndexPath:indexPath];
	cell.tagName = self.selectedTags[indexPath.row];
	cell.delegate = self;
	cell.showDeleteButton = self.allowDeleteTags;
	[self configureCell:cell atIndexPath:indexPath];
	return cell;
}

-(void)configureCell:(AKTagCell*)cell atIndexPath:(NSIndexPath*)indexPath
{
	cell.backgroundColor = WK_COLOR_RED_TAG_COLOR;
	cell.tagLabel.textColor = [UIColor whiteColor];
	cell.layer.borderWidth = 1;
	cell.layer.borderColor = WK_COLOR_DARK_RED_TAG_COLOR.CGColor;
}

#pragma mark - Helpers
-(NSString*)squashWhitespaces:(NSString*)string
{
	NSString *result = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
	NSArray *components = [result componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
	components = [components filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self <> ''"]];
	result = [components componentsJoinedByString:@" "];
	return result;
}

- (void)scrollListInsertingItem:(NSString *)string
{
	CGFloat width = CGRectGetWidth(self.bounds);
	CGFloat contentXOffset = (self.collectionView.contentSize.width - width);
	contentXOffset = MAX(contentXOffset + [AKTagCell preferredSizeWithTag:string deleteButtonEnabled:_allowDeleteTags].width, 0);
	CGPoint offset = CGPointMake(contentXOffset, 0);
	[self.collectionView setContentOffset:offset animated:YES];
}

- (void)addNewItemWithString:(NSString *)string completion:(void(^)(void))compeltion
{
    NSString *squashedString = [self squashWhitespaces:string];
    [self.selectedTags addObject:squashedString];
    
    [self scrollListInsertingItem:string];
    
    // this is a workaround of a big problem when CV resigns first responder while dequeue cells.
    // so that my textfield cell may become to unwanted state and get into an UI mess
    // I have to insert new cells only having textfield cell visible, so first I scroll to it and only after that
    // I insert new item
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.collectionView performBatchUpdates:^{
            
            [self.collectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.selectedTags.count-1 inSection:0]]];
        } completion:^(BOOL finished) {
            if (compeltion){
                compeltion();
            }
        }];
    });
}

- (void)deleteItemAt:(NSIndexPath *)indexPath  completion:(void(^)(void))completion
{
	[self.collectionView deselectItemAtIndexPath:indexPath animated:YES];
	[self.collectionView performBatchUpdates:^{
		NSArray* itemPaths = @[indexPath];
		[self deleteItemsFromDataSourceAtIndexPaths:itemPaths];
		[self.collectionView deleteItemsAtIndexPaths:itemPaths];
    } completion: ^(BOOL finished){
        if (completion){
            completion();
        }
    }];
}

-(void)deleteItemsFromDataSourceAtIndexPaths:(NSArray*)ipaths
{
	for (NSIndexPath *ip in ipaths){
		[self.selectedTags removeObjectAtIndex:ip.row];
	}
}
@end
