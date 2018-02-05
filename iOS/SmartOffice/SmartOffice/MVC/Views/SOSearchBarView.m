//
//  SOSearchBarView.m
//  SmartOffice
//
//  Created by NguyenVanTu on 7/31/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import "SOSearchBarView.h"
#import "IQKeyboardManager.h"
@interface SOSearchBarView() <UITextFieldDelegate>

@end

@implementation SOSearchBarView
@synthesize text = _text;

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.searchBar.delegate = self;
    [self.searchBar setTintColor: AppColor_MainAppTintColor];
    self.searchBar.returnKeyType = UIReturnKeySearch;

}
- (void)setText:(NSString *)text
{
    _text = text;
    self.searchBar.text = text;
}
- (NSString *)text
{
    if (!_text) {
        return @"";
    }
    return _text;
}
- (void)setPlaceholder:(NSString *)placeHolder
{
    _placeholder = placeHolder;
    UIColor *color = [UIColor lightGrayColor];
    self.searchBar.attributedPlaceholder =
    [[NSAttributedString alloc] initWithString:placeHolder
                                    attributes:@{
                                                 NSForegroundColorAttributeName: color,
                                                 NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-Italic" size:15]
                                                 }
     ];
    self.searchBar.placeholder = placeHolder;
}
- (IBAction)changeText:(UITextField *)sender {
    self.text = sender.text;
    if ([self.delegate respondsToSelector:@selector(textField:textDidChange:)]) {
        [self.delegate textField:sender textDidChange:sender.text];
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if ([self.delegate respondsToSelector:@selector(textFieldShouldBeginEditing:)]) {
        return [self.delegate textFieldShouldBeginEditing:textField];
    }
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
	[IQKeyboardManager sharedManager].enable = YES;
    if ([self.delegate respondsToSelector:@selector(textFieldDidBeginEditing:)]) {
        [self.delegate textFieldDidBeginEditing:textField];
    }
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if ([self.delegate respondsToSelector:@selector(textFieldShouldEndEditing:)]) {
        return [self.delegate textFieldShouldEndEditing:textField];
    }
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([self.delegate respondsToSelector:@selector(textFieldDidEndEditing:)]) {
        [self.delegate textFieldDidEndEditing:textField];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([self.delegate respondsToSelector:@selector(textField:shouldChangeCharactersInRange:replacementString:)]) {
        return [self.delegate textField:textField shouldChangeCharactersInRange:range replacementString:string];
    }
    return YES;
}
-(BOOL)textFieldShouldClear:(UITextField *)textField
{
    self.text = @"";
    if ([self.delegate respondsToSelector:@selector(textFieldShouldClear:)]) {
        return [self.delegate textFieldShouldClear:textField];
    }
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    if ([self.delegate respondsToSelector:@selector(textFieldShouldReturn:)]) {
        return [self.delegate textFieldShouldReturn:textField];
    }
    return YES;
}


#pragma mark - Handle Keyboard
- (void)dismissKeyboard{
	[_searchBar resignFirstResponder];
}
@end
