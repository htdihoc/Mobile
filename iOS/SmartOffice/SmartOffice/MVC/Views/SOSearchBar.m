//
//  SOSearchBar.m
//  SmartOffice
//
//  Created by Kaka on 4/13/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "SOSearchBar.h"
#import "NSString+SizeOfString.h"
@implementation SOSearchBar

- (void)awakeFromNib{
	[super awakeFromNib];
    self.hasCentredPlaceholder = YES;
	[[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setDefaultTextAttributes:@{
																								 NSFontAttributeName: AppFont_MainFontWithSize(15),
																								 }];
	self.layer.borderWidth = 1;
	self.layer.borderColor = RGB(227, 227, 232).CGColor;
	self.barTintColor = RGB(227, 227, 232);
	self.returnKeyType = UIReturnKeyDone;
}
- (void)setPlaceholder:(NSString *)placeholder
{
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:@""];
    [self setPositionAdjustment:UIOffsetMake(-25, 0) forSearchBarIcon:UISearchBarIconSearch];

    NSString *strSearchHere = placeholder;

    NSAttributedString * subString = [[NSAttributedString alloc] initWithString:strSearchHere attributes:nil];
    [attributedString appendAttributedString:subString];
    
    NSString *strLongText = @"Long Text Long Text Long Text Long Text Long Text Long Text Long Text Long Text Long Text Long Text Long Text Long Text Long Text Long Text Long Text Long Text Long Text Long Text ";
    
    NSDictionary * attributesLong =  @{ NSForegroundColorAttributeName : [UIColor clearColor]};
    NSAttributedString * subStringLong = [[NSAttributedString alloc] initWithString:strLongText attributes:attributesLong];
    [attributedString appendAttributedString:subStringLong];
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineBreakMode = NSLineBreakByWordWrapping;
    style.alignment = NSTextAlignmentLeft;
    [attributedString addAttribute:NSParagraphStyleAttributeName
                 value:style
                 range:NSMakeRange(0, attributedString.length)];
    
    UITextField *searchTextField = [self valueForKey:@"_searchField"];
    
    searchTextField.attributedPlaceholder = attributedString;
    searchTextField.textAlignment = NSTextAlignmentRight;
    searchTextField.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"searchIcon"]];
    UILabel *label = [searchTextField valueForKey:@"_placeholderLabel"];

    label.layer.transform = CATransform3DMakeScale(0.95, 1.0, 1.0);
}

- (void)setHasCentredPlaceholder:(BOOL)hasCentredPlaceholder
{
    _hasCentredPlaceholder = hasCentredPlaceholder;
    
    SEL centerSelector = NSSelectorFromString([NSString stringWithFormat:@"%@%@", @"setCenter", @"Placeholder:"]);
    if ([self respondsToSelector:centerSelector])
    {
        NSMethodSignature *signature = [[UISearchBar class] instanceMethodSignatureForSelector:centerSelector];
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
        [invocation setTarget:self];
        [invocation setSelector:centerSelector];
        [invocation setArgument:&_hasCentredPlaceholder atIndex:2];
        [invocation invoke];
    }
    
}
- (NSInteger)getNumberOfCharacters:(NSString *)content
{
    [self layoutIfNeeded];
    UITextField *textField = [self valueForKey: @"_searchField"];
    UIFont *font = textField.font;
    NSString *text = content;
    
    CGRect label1Frame = self.frame;
    
    NSUInteger numberOfCharsInLabel1 = NSNotFound;
    for (long i = [text length]; i >= 0; i--) {
        NSString *substring = [text substringToIndex:i];
        
        if ([substring widthOfString:font] <= (CGRectGetWidth(label1Frame)-50)) {
            numberOfCharsInLabel1 = i;
            break;
        }
    }
    
    if (numberOfCharsInLabel1 == NSNotFound) {
        // TODO: Handle this case.
    }
    return numberOfCharsInLabel1;
}

@end
