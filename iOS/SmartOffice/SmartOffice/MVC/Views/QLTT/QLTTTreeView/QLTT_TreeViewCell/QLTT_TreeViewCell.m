
//The MIT License (MIT)
//
//Copyright (c) 2014 Rafał Augustyniak
//
//Permission is hereby granted, free of charge, to any person obtaining a copy of
//this software and associated documentation files (the "Software"), to deal in
//the Software without restriction, including without limitation the rights to
//use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
//the Software, and to permit persons to whom the Software is furnished to do so,
//subject to the following conditions:
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
//FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
//COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
//IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
//CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import "QLTT_TreeViewCell.h"


@interface QLTT_TreeViewCell ()
{
    BOOL _isTap;
    BOOL _selectedCell;
}
@property (weak, nonatomic) IBOutlet UILabel *customTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *additionButton;

@end

@implementation QLTT_TreeViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.selectedBackgroundView = [UIView new];
    self.backgroundColor = [UIColor whiteColor];
    [self.additionButton setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
}

- (void)prepareForReuse
{
    [super prepareForReuse];

    self.additionButtonHidden = NO;
}
- (void)setImageForCell:(BOOL)isParent
{
    if (isParent) {
        [self setPlusIconForCell];
    }
    else
    {
        [self.additionButton setImage:nil forState:UIControlStateNormal];
    }
}
- (void)setHighlighted:(BOOL)highlighted
{
    if (highlighted) {
        self.textLabel.textColor = [UIColor whiteColor];
    } else {
        self.textLabel.textColor = [UIColor blackColor];
    }
}
- (void)setupWithTitle:(NSString *)title level:(NSInteger)level additionButtonHidden:(BOOL)additionButtonHidden
{
    self.customTitleLabel.text = title;
    self.additionButtonHidden = additionButtonHidden;
    CGFloat left = 16 * level + 8;
    self.cst_Left.constant = left;

}
- (void)setState:(BOOL)state
{
    _isTap = state;
}

#pragma mark - Properties

- (void)setAdditionButtonHidden:(BOOL)additionButtonHidden
{
    [self setAdditionButtonHidden:additionButtonHidden animated:NO];
}

- (void)setAdditionButtonHidden:(BOOL)additionButtonHidden animated:(BOOL)animated
{
    _additionButtonHidden = additionButtonHidden;
    [UIView animateWithDuration:animated ? 0.2 : 0 animations:^{
        self.additionButton.hidden = additionButtonHidden;
    }];
}

- (void)setImageForAcessoryCell
{
    if (_isTap) {
        [self setImageMinusIconForCell];
    }
    else
    {
        [self setPlusIconForCell];
    }
}
- (void)setImageMinusIconForCell
{
    [self.additionButton setImage:[UIImage imageNamed:@"minusIcon"] forState:UIControlStateNormal];
}
- (void)setPlusIconForCell
{
    [self.additionButton setImage:[UIImage imageNamed:@"plusIcon"] forState:UIControlStateNormal];
}
#pragma mark - Actions

- (IBAction)additionButtonTapped:(UIButton *)sender
{
    _isTap = !_isTap;
    [self setImageForAcessoryCell];
    if (self.additionButtonTapAction) {
        self.additionButtonTapAction(sender);
    }
}

@end
