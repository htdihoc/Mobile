//
//  PersionaModel.m
//  SmartOffice
//
//  Created by Kaka on 4/12/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "PersionaModel.h"
#import "SumWorkModel.h"
#import "SumDocModel.h"


@implementation PersionaModel
- (instancetype)init{
	self = [super init];
	if (self) {
		self.performWorkModel = [[SumWorkModel alloc] init];
		self.shippedWorkModel = [[SumWorkModel alloc] init];

		self.listSchedule = @[].mutableCopy;
		self.docModel = [[SumDocModel alloc] init];
		self.listDoc = [[NSMutableArray alloc] initWithCapacity:3];
	}
	return self;
}

- (void)updateDataForListDocFromSumDoc:(SumDocModel *)model{
	if (!model) {
		return;
	}
	//Refresh Doc
	[_listDoc removeAllObjects];
	if (model.countTextWaitSign > 0) {
		[_listDoc addObject:@(DocType_Waiting)];
	}
	if (model.countTextWaitingInitial > 0) {
		[_listDoc addObject:@(DocType_Flash)];
	}
	if (model.countTextSigned > 0) {
		[_listDoc addObject:@(DocType_Express)];
	}

}
@end
