AKTagsInputView
===============
AKTagsInputView class implements a convenient input view for seek'n'selecting and writing tags data.

#####Features
- write your own tags
- forbidden symbols settings
- space or coma separation
- lookup-style accessory input view for selecting predefined tags
- fast search by first letters

###Installing using CocoaPods
Add the following to your Podfile.
```ruby
pod 'AKTagsInputView', '~> 1.0'
```

###How to use

- Add a UIView in Storyboard
- set its class to AKTagsInputView
- connect the outlet to ViewController
- put this
```
- (void)setTagsInputView:(AKTagsInputView *)tagsInputView
{
    _tagsInputView = tagsInputView;
    
	_tagsInputView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	_tagsInputView.lookupTags = @[@"ios", @"iphone", @"objective-c", @"development", @"cocoa", @"xcode", @"icloud"];
	_tagsInputView.selectedTags = [NSMutableArray arrayWithArray:@[@"some", @"predefined", @"tags"]];
	_tagsInputView.enableTagsLookup = YES;
}
```

###Demo
(click on the gif below to watch HD youtube demo)


[![CLICK TO WATCH HD DEMO](http://cdn.makeagif.com/media/6-01-2014/anzpi7.gif)](http://www.youtube.com/watch?v=WURx-ZjOATQ)




