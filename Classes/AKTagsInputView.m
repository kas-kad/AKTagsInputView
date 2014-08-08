//
//  AKTagsInputView.m
//
//  Created by Andrey Kadochnikov on 30.05.14.
//  Copyright (c) 2014 Andrey Kadochnikov. All rights reserved.
//
#import "AKTagsDefines.h"
#import "AKTagsInputView.h"
#import "AKTagTextFieldCell.h"
#import "AKTagsLookup.h"

NSString *const TextFieldCellReuseIdentifier = @"textFieldCell";

@interface AKTagsInputView () <UITextFieldDelegate, AKTagsLookupDelegate>

@property (nonatomic, strong) AKTagsLookup *lookup;
@property (nonatomic, strong) AKTagTextFieldCell *textFieldCell;

@end

@implementation AKTagsInputView

@synthesize lookupTags = _lookupTags;

#pragma mark - Init -

-(id)initWithFrame:(CGRect)frame
{
	if (self = [super initWithFrame:frame]){
        [self setup];
	}
	return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super initWithCoder:aDecoder]){
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.allowDeleteTags = YES;
    self.forbiddenCharsString = DEFAULT_FORBIDDEN_CHARS_STRING;
    [self.collectionView registerClass:[AKTagTextFieldCell class]
            forCellWithReuseIdentifier:TextFieldCellReuseIdentifier];
    
    [self addSubview:self.collectionView];
}

#pragma mark - Lookup -

-(NSArray *)lookupTags
{
    if (!_lookupTags) {
        _lookupTags = @[];
    }
    return _lookupTags;
}

-(void)setLookupTags:(NSArray *)lookupTags
{
    _lookupTags = lookupTags;
    if (self.enableTagsLookup) {
        self.lookup.tagsBase = [_lookupTags mutableCopy];
    }
}

- (void)setEnableTagsLookup:(BOOL)enableTagsLookup
{
    _enableTagsLookup = enableTagsLookup;
    [self lookup];
}

- (void)setTextFieldCell:(AKTagTextFieldCell *)textFieldCell
{
    _textFieldCell = textFieldCell;
    [self lookup];
}

-(AKTagsLookup *)lookup
{
    if (!_lookup) {
        _lookup = [[AKTagsLookup alloc] initWithTags:self.lookupTags];
        _lookup.delegate = self;
    }
    if (self.enableTagsLookup){
        [_lookup filterLookupWithPredicate:[self predicateExcludingTags:self.selectedTags]];
        self.textFieldCell.textField.inputAccessoryView = _lookup;
    }

    return _lookup;
}

#pragma mark - CV Layout

-(CGSize)collectionView:(UICollectionView *)collectionView
                 layout:(UICollectionViewLayout *)collectionViewLayout
 sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.row == self.selectedTags.count){
		return CGSizeMake(CGRectGetWidth(self.collectionView.bounds)/2, CGRectGetHeight(self.bounds));
	} else {
		return [super collectionView:collectionView
                              layout:collectionViewLayout
              sizeForItemAtIndexPath:indexPath];
	}
}

#pragma mark - CV Datasource

-(NSInteger)collectionView:(UICollectionView *)collectionView
    numberOfItemsInSection:(NSInteger)section
{
	// +1 extra cell for the textFieldCell
    NSInteger count = [super collectionView:collectionView numberOfItemsInSection:section];
	return (count + 1);
}

-(void)configureCell:(AKTagCell*)cell atIndexPath:(NSIndexPath*)indexPath
{
	cell.backgroundColor = WK_COLOR_GREED_COLOR;
	cell.tagLabel.textColor = [UIColor blackColor];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.row == self.selectedTags.count){
		if (!self.textFieldCell){
            // I don't want my CV to nullify my textFieldCell's content while reusing cells, I store the cell in memory
			self.textFieldCell = [collectionView dequeueReusableCellWithReuseIdentifier:TextFieldCellReuseIdentifier
                                                                       forIndexPath:indexPath];
			self.textFieldCell.textField.delegate = self;
			
		}
		return self.textFieldCell;
	} else {
		return [super collectionView:collectionView
              cellForItemAtIndexPath:indexPath];
	}
}

#pragma mark - tags lookup delegate

-(void)tagsLookup:(AKTagsLookup *)lookup
     didSelectTag:(NSString *)tag
{
	[self addNewItemWithString:tag
                    completion:nil];
	self.textFieldCell.textField.text = nil;
}

#pragma mark - textFieldCell's delegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
	if ([self tagNameIsValid:textField.text]){
		[self addNewItemWithString:textField.text
                        completion:nil];
		textField.text = nil;
	} else {
		[textField resignFirstResponder];
	}
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
			if ([self tagNameIsValid:(textField.text)]){
				[self addNewItemWithString:textField.text completion:nil];
				textField.text = nil;
			}
			return NO;
		}
	}

	NSString *newText = [textField.text stringByReplacingCharactersInRange:range withString:string];
	if (newText.length > 0){
		[self.lookup filterLookupWithPredicate:[self predicateExcludingTags:self.selectedTags
                                                          andFilterByString: newText]];
	} else {
		[self.lookup filterLookupWithPredicate:[self predicateExcludingTags:self.selectedTags]];
	}
	return YES;
}

#pragma mark - Overridden

-(void)addNewItemWithString:(NSString *)string completion:(void (^)(BOOL))completion
{
	[self.lookup filterLookupWithPredicate:[self predicateExcludingTags:[self.selectedTags arrayByAddingObject:string]]];
	[super addNewItemWithString:string completion:completion];
}

- (void)deleteItemAt:(NSIndexPath *)indexPath  completion:(void(^)(BOOL finish))completion
{
	[super deleteItemAt:indexPath completion:^(BOOL finish) {
		[self.lookup filterLookupWithPredicate:[self predicateExcludingTags:self.selectedTags]];
	}];
}

-(BOOL)becomeFirstResponder
{
	return [self.textFieldCell.textField becomeFirstResponder];
}

- (BOOL)resignFirstResponder
{
    return [self.textFieldCell.textField resignFirstResponder];
}

#pragma mark - Helpers

-(void)clear
{
	self.selectedTags = [NSMutableArray array];
}

-(BOOL)tagNameIsValid:(NSString*)tagName
{
	NSString *textFieldTrimmedContent = [tagName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
	return (textFieldTrimmedContent.length > 0);
}

-(NSPredicate*)predicateExcludingTags:(NSArray*)tagsToExclude andFilterByString:(NSString*)string
{
	return [NSCompoundPredicate andPredicateWithSubpredicates:@[[self predicateExcludingTags:tagsToExclude],
                                                                [NSPredicate predicateWithFormat:@"self BEGINSWITH[cd] %@", string]]];
}

-(NSPredicate*)predicateExcludingTags:(NSArray*)tagsToExclude
{
	return [NSPredicate predicateWithFormat:@"NOT(self IN %@)", tagsToExclude];
}

@end
