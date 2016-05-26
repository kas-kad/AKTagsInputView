//
//  AKTagsInputView.m
//  handmash
//
//  Created by Andrey Kadochnikov on 30.05.14.
//  Copyright (c) 2014 Andrey Kadochnikov. All rights reserved.
//

#import "AKTagsInputView.h"
#import "AKTagTextFieldCell.h"
#import "AKTagsLookup.h"
#import "AKTagsLayoutManager.h"
#import "Constants.h"

@interface AKTagsInputView () <UITextFieldDelegate, AKTagsLookupDelegate>
{
    AKTagTextFieldCell *_textFieldCell;
    AKTagsLookup *_lookup;
}
@property (nonatomic, assign) BOOL insertingInProgress;
@property (nonatomic, readwrite) AKTagsLayoutManager *layoutManager;

@end

@implementation AKTagsInputView

-(instancetype) initWithFrame: (CGRect) frame
{
    if (self = [super initWithFrame:frame]){
       [self initialSetup];
    }
    return self;
}

- (void) initialSetup
{
    self.allowDeleteTags = YES;
    _insertingInProgress = NO;
    _forbiddenCharsString = DEFAULT_FORBIDDEN_CHARS_STRING;
    [self.collectionView registerClass:[AKTagTextFieldCell class] forCellWithReuseIdentifier:@"textFieldCell"];
    [self initLayout];
}

- (instancetype) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self initialSetup];
    }
    return self;
}

- (void) initLayout
{
    self.layoutManager = [AKTagsLayoutManager sharedManager];
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

-(void)configureCell:(UICollectionViewCell*)cell atIndexPath:(NSIndexPath*)indexPath
{
    // empty implementation for default gray-style cell's look
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.selectedTags.count){
        if (!_textFieldCell){ // I don't want my CV to nullify my textFieldCell's content while reusing cells, I store the cell in memory
            _textFieldCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"textFieldCell" forIndexPath:indexPath];
            _textFieldCell.textField.delegate = self;
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
}

#pragma mark - textFieldCell's delegate
-(void)textFieldDidBeginEditing:(AKTextField *)textField
{
    [self restoreZWWSIfNeeded:textField];
    if ([self.delegate respondsToSelector:@selector(tagsInputViewDidBeginEditing:)]){
        [self.delegate tagsInputViewDidBeginEditing:self];
    }
}
-(void)textFieldDidEndEditing:(AKTextField *)textField
{
    if ([self canInsertNewTagName:textField.text]){
        [self addNewItemWithString:textField.tagName completion:nil];
    }
    textField.text = nil;
    if ([self.delegate respondsToSelector:@selector(tagsInputViewDidEndEditing:)]){
        [self.delegate tagsInputViewDidEndEditing:self];
    }
}
-(BOOL)canInsertNewTagName:(NSString *)tagName
{
    tagName = [self trimmedString:tagName];
    if ([self tagNameIsNotEmpty:tagName]){
        return YES;
    } else {
        return NO;
    }
}
-(BOOL)textFieldShouldReturn:(AKTextField *)textField
{
    if ([self canInsertNewTagName:textField.text]){
        [self addNewItemWithString:textField.tagName completion:nil];
    }
    [self.collectionView setContentOffset: CGPointZero
                                 animated: YES];
    [textField resignFirstResponder];
    return YES;
}

- (void)restoreZWWSIfNeeded:(AKTextField *)textField
{
    if ([textField.text rangeOfString:ZWWS].location == NSNotFound){
        textField.text = [NSString stringWithFormat:@"%@%@", ZWWS, textField.tagName];
    }
}

-(BOOL)textField:(AKTextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (self.insertingInProgress){
        return NO;
    }
    BOOL isBackSpace = NO;
    AKTagCell *lastTagCell;
    if (self.selectedTags.count){
        lastTagCell = (AKTagCell*)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:self.selectedTags.count-1 inSection:0]];
    }
    if ([string isEqualToString:@""]){
        isBackSpace = YES;
        
        if ([textField.text rangeOfString:ZWWS].location == 0 && textField.text.length == 1 && self.selectedTags.count){
            if (!lastTagCell.isReadyForDelete) {
                [lastTagCell prepareForDelete];
                return NO;
            } else {
                [self deleteItemAt:[NSIndexPath indexPathForRow:self.selectedTags.count-1 inSection:0] completion:nil];
                return NO;
            }
        }
    }
    
    if (!isBackSpace){
        [lastTagCell resetReadyForDeleteStatus];
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
            if ([self canInsertNewTagName:textField.tagName]){
                [self addNewItemWithString:textField.tagName completion:nil];
            }
            return NO;
        }
    }
    
    NSString *newText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSMutableString *mutableText = [newText mutableCopy];
    if ([newText rangeOfString:ZWWS].location != NSNotFound){
        NSRange ZWWSRange = [newText rangeOfString:ZWWS];
        [mutableText deleteCharactersInRange:ZWWSRange];
    }
    newText = [NSString stringWithString:mutableText];
    if (newText.length > 0){
        [_lookup filterLookupWithPredicate: [self predicateExcludingTags:self.selectedTags andFilterByString: newText]];
    } else {
        [_lookup filterLookupWithPredicate: [self predicateExcludingTags: self.selectedTags]];
    }
    
    [self restoreZWWSIfNeeded:textField];
    
    return YES;
}

-(BOOL)isFirstResponder
{
    return _textFieldCell.isFirstResponder;
}
-(BOOL)resignFirstResponder
{
    return [_textFieldCell resignFirstResponder];
}
-(BOOL)becomeFirstResponder
{
    return [_textFieldCell becomeFirstResponder];
}
#pragma mark - Overridden
-(void)addNewItemWithString:(NSString *)string completion:(void (^)(void))completion
{
    self.insertingInProgress = YES;
    [_lookup filterLookupWithPredicate: [self predicateExcludingTags: [self.selectedTags arrayByAddingObject:string]]];
    
    _textFieldCell.textField.text = nil;
    __weak typeof(_textFieldCell) weakCell = _textFieldCell;
    __weak typeof(self) weakSelf = self;
    [super addNewItemWithString:string completion:^{
        [weakSelf restoreZWWSIfNeeded:weakCell.textField];
        weakSelf.insertingInProgress = NO;
        if (completion){
            completion();
        }
    }];
    if ([self.delegate respondsToSelector:@selector(tagsInputViewDidAddTag:)]){
        [self.delegate tagsInputViewDidAddTag:self];
    }
}

- (void)deleteItemAt:(NSIndexPath *)indexPath  completion:(void (^)(void))completion
{
    __weak typeof(_textFieldCell) weakCell = _textFieldCell;
    __weak typeof(self) weakSelf = self;
    [super deleteItemAt:indexPath completion:^{
        
        [weakSelf restoreZWWSIfNeeded:weakCell.textField];
        
        if (completion){
            completion();
        }
        [_lookup filterLookupWithPredicate: [self predicateExcludingTags:self.selectedTags]];
    }];
    if ([self.delegate respondsToSelector:@selector(tagsInputViewDidRemoveTag:)]){
        [self.delegate tagsInputViewDidRemoveTag:self];
    }
}

#pragma mark - Helpers
-(void)setSelectedTags:(NSMutableArray *)selectedTags
{
    if ([selectedTags isKindOfClass: [NSMutableArray class]])
    {
        [super setSelectedTags:selectedTags];
    }
    else
    {
        @throw [NSException exceptionWithName: @"AKWrongParametersException"
                                       reason: @"selectedTags must be a mutable array"
                                     userInfo: nil];
    }
}


-(void) setLookupTags: (NSArray *) lookupTags
{
    _lookupTags = lookupTags;
    if (_enableTagsLookup)
    {
        _lookup = [[AKTagsLookup alloc] initWithTags:_lookupTags];
        _lookup.delegate = self;
        [_lookup filterLookupWithPredicate:[self predicateExcludingTags:self.selectedTags]];
        _textFieldCell.textField.inputAccessoryView = _lookup;
    }
    
}

-(NSString *)trimmedString:(NSString *)str
{
    return [str stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
}
-(BOOL)tagNameIsNotEmpty:(NSString*)tagName
{
    NSString *textFieldTrimmedContent = [self trimmedString:tagName];
    return textFieldTrimmedContent.length > 0;
}
-(BOOL)tagNameIsValid:(NSString*)tagName
{
    if (![self tagNameIsNotEmpty:tagName]){
        return NO;
    }
    BOOL isValid = NO;
    if ([self.delegate respondsToSelector:@selector(validateTag:)]){
        isValid = [self.delegate validateTag:tagName];
    }
    return isValid;
}

-(NSPredicate*)predicateExcludingTags:(NSArray*)tagsToExclude andFilterByString:(NSString*)string
{
    return [NSCompoundPredicate andPredicateWithSubpredicates:@[[self predicateExcludingTags:tagsToExclude], [NSPredicate predicateWithFormat:@"self BEGINSWITH[cd] %@", string]]];
}

-(NSPredicate*)predicateExcludingTags:(NSArray*)tagsToExclude
{
    return [NSPredicate predicateWithFormat:@"NOT(self IN %@)", tagsToExclude];
}

@end
