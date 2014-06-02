//
//  AKTagsInputView.m
//  handmash
//
//  Created by Andrey Kadochnikov on 30.05.14.
//  Copyright (c) 2014 Andrey Kadochnikov. All rights reserved.
//
#import "AKTagsDefines.h"
#import "AKTagsInputView.h"
#import "AKTagTextFieldCell.h"
#import "AKTagsLookup.h"

@interface AKTagsInputView ()
<
	UITextFieldDelegate,
	AKTagsLookupDelegate
>
{
	AKTagTextFieldCell *_textFieldCell;
	AKTagsLookup *_lookup;
}
@end

@implementation AKTagsInputView

-(id)initWithFrame:(CGRect)frame
{
	if (self = [super initWithFrame:frame]){
		self.allowDeleteTags = YES;
		_forbiddenCharsString = DEFAULT_FORBIDDEN_CHARS_STRING;
		[self.collectionView registerClass:[AKTagTextFieldCell class] forCellWithReuseIdentifier:@"textFieldCell"];
	}
	return self;
}

#pragma mark - CV Layout
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.row == self.selectedTags.count){
		return CGSizeMake(CGRectGetWidth(self.collectionView.bounds)/2, CGRectGetHeight(self.bounds));
	} else {
		return [super collectionView:collectionView layout:collectionViewLayout sizeForItemAtIndexPath:indexPath];
	}
}

#pragma mark - CV Datasource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
	// +1 extra cell for the textFieldCell
	return [super collectionView:collectionView numberOfItemsInSection:section] + 1;
}

-(void)configureCell:(AKTagCell*)cell atIndexPath:(NSIndexPath*)indexPath
{
	cell.backgroundColor = WK_COLOR_GREED_COLOR;
	cell.tagLabel.textColor = [UIColor blackColor];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.row == self.selectedTags.count){
		if (!_textFieldCell){ // I don't want my CV to nullify my textFieldCell's content while reusing cells, I store the cell in memory
			_textFieldCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"textFieldCell" forIndexPath:indexPath];
			_textFieldCell.textField.delegate = self;
			_textFieldCell.textField.placeholder = _placeholder;
			
			if (_enableTagsLookup){
				_lookup = [[AKTagsLookup alloc] initWithTags:_lookupTags];
				_lookup.delegate = self;
				[_lookup filterLookupWithPredicate:[self predicateExcludingTags:self.selectedTags]];
				_textFieldCell.textField.inputAccessoryView = _lookup;
			}
		}
		return _textFieldCell;
	} else {
		return [super collectionView:collectionView cellForItemAtIndexPath:indexPath];
	}
}

#pragma mark - tags lookup delegate
-(void)tagsLookup:(AKTagsLookup *)lookup didSelectTag:(NSString *)tag
{
	[self addNewItemWithString:tag completion:nil];
	_textFieldCell.textField.text = nil;
}

#pragma mark - textFieldCell's delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[self addNewItemWithString:textField.text completion:nil];
	textField.text = nil;
	return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
	BOOL isSpace = NO;
	if ([string isEqualToString:@""]){
		isSpace = YES;
	}
	
	if (!isSpace){
		NSCharacterSet *forbiddenCharSet  = [NSCharacterSet characterSetWithCharactersInString:_forbiddenCharsString];
		string = [string stringByTrimmingCharactersInSet:forbiddenCharSet];
		
		if (string.length == 0){
			textField.backgroundColor = [UIColor redColor];
			[UIView animateWithDuration:0.3f animations:^{
				textField.backgroundColor = [UIColor whiteColor];
			}];
			return NO;
		}
		
		if ([string isEqualToString:@","] || (_separateTagsWithSpaceSymbol && [string isEqualToString:@" "])){
			NSString *textFieldTrimmedContent = [textField.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
			if (textFieldTrimmedContent.length > 0){
				[self addNewItemWithString:textField.text completion:nil];
				textField.text = nil;
			}
			return NO;
		}
	}

	NSString *newText = [textField.text stringByReplacingCharactersInRange:range withString:string];
	if (newText.length > 0){
		[_lookup filterLookupWithPredicate: [self predicateExcludingTags:self.selectedTags andFilterByString: newText]];
	} else {
		[_lookup filterLookupWithPredicate: [self predicateExcludingTags: self.selectedTags]];
	}
	return YES;
}

#pragma mark - Overridden
-(void)addNewItemWithString:(NSString *)string completion:(void (^)(BOOL))completion
{
	[_lookup filterLookupWithPredicate: [self predicateExcludingTags: [self.selectedTags arrayByAddingObject:string]]];
	[super addNewItemWithString:string completion:completion];
}

- (void)deleteItemAt:(NSIndexPath *)indexPath  completion:(void(^)(BOOL finish))completion
{
	[super deleteItemAt:indexPath completion:^(BOOL finish) {
		[_lookup filterLookupWithPredicate: [self predicateExcludingTags:self.selectedTags]];
	}];
}

-(BOOL)becomeFirstResponder
{
	return [_textFieldCell.textField becomeFirstResponder];
}

#pragma mark - Helpers
-(NSPredicate*)predicateExcludingTags:(NSArray*)tagsToExclude andFilterByString:(NSString*)string
{
	return [NSCompoundPredicate andPredicateWithSubpredicates:@[[self predicateExcludingTags:tagsToExclude], [NSPredicate predicateWithFormat:@"self BEGINSWITH[cd] %@", string]]];
}

-(NSPredicate*)predicateExcludingTags:(NSArray*)tagsToExclude
{
	return [NSPredicate predicateWithFormat:@"NOT(self IN %@)", tagsToExclude];
}

@end
