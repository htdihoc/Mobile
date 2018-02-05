//
//  ContentFilterCell.m
//  SmartOffice
//
//  Created by Kaka on 4/14/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "ContentFilterCell.h"

@implementation ContentFilterCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Load From Nib
+ (ContentFilterCell *)cellFromNibNamed:(NSString *)nibName {
	/*
	NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:nibName owner:self options:NULL];
	NSEnumerator *nibEnumerator = [nibContents objectEnumerator];
	ContentFilterCell *customCell = nil;
	NSObject* nibItem = nil;
	while ((nibItem = [nibEnumerator nextObject]) != nil) {
		if ([nibItem isKindOfClass:[ContentFilterCell class]]) {
			customCell = (ContentFilterCell *)nibItem;
			break; // we have a winner
		}
	}
	 */
	NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"BDCustomCell" owner:self options:nil];
	ContentFilterCell *customCell = [topLevelObjects objectAtIndex:0];
	return customCell;
}

#pragma mark - SetData
- (void)setData:(NSString *)content showCheckmark:(BOOL)show{
	_lblContent.text = content;
	_imgCheckmark.hidden = !show;
}

@end
