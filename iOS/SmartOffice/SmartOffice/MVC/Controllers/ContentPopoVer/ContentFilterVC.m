//
//  ContentFilterVC.m
//  SmartOffice
//
//  Created by Kaka on 4/14/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "ContentFilterVC.h"
#import "ContentFilterCell.h"
#import "FullWidthSeperatorTableView.h"

@interface ContentFilterVC (){
	
}

@end

static NSString *CELL_ID = @"ContentFilterCell_ID";
@implementation ContentFilterVC

- (instancetype)initWithFilterSelected:(NSInteger)filterType content:(NSArray *)contents{
	self = [[ContentFilterVC alloc] initWithNibName:@"ContentFilterVC" bundle:nil];
	if (self) {
		self.filterType = filterType;
		self.listContent = contents;
		self.view.frame = CGRectMake(0, 0, 240, 44 * self.listContent.count - 1);
		self.view.layer.cornerRadius = 0.5;
	}
	return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	[self.tblContent registerNib:[UINib nibWithNibName:@"ContentFilterCell" bundle:nil] forCellReuseIdentifier:CELL_ID];
	[self.tblContent reloadData];
	[self.tblContent setScrollEnabled:NO];
	[self.view setNeedsDisplay];
	
	
	//Margin footer line on UITableViewCell
	/*
	if ([self.tblContent respondsToSelector:@selector(setSeparatorInset:)]) {
		[self.tblContent setSeparatorInset:UIEdgeInsetsZero];
	}
	
	if ([self.tblContent respondsToSelector:@selector(setLayoutMargins:)]) {
		[self.tblContent setLayoutMargins:UIEdgeInsetsZero];
	}
	*/
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark - UITableView DataSource
//Row
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	return _listContent.count;

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	return 44.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	ContentFilterCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_ID];
	if (cell == nil) {
		cell = (ContentFilterCell *)[ContentFilterCell cellFromNibNamed:@"ContentFilterCell"];
	}
	if (_filterType == indexPath.row) {
		[cell setData:_listContent[indexPath.row] showCheckmark:YES];
		//[tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
	}else{
		[cell setData:_listContent[indexPath.row] showCheckmark:NO];
	}
	return cell;
}

#pragma mark - UITableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	ContentFilterCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
	selectedCell.imgCheckmark.hidden = NO;
	_filterType = indexPath.row;
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	[tableView reloadData];
	if (_delegate) {
		[_delegate didSelectedFilterVC:self withFilterType:_filterType];
	}
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
	ContentFilterCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
	selectedCell.imgCheckmark.hidden = YES;
}


@end
