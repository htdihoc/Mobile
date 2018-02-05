//
//  TextDetailModel.h
//  SmartOffice
//
//  Created by Kaka on 5/16/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import "SOBaseModel.h"
#import "MemberModel.h"

@interface TextDetailModel : SOBaseModel{
	
}
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *content;
@property (strong, nonatomic) NSString *departSentSign;
@property (strong, nonatomic) NSString *creator;
@property (strong, nonatomic) NSString *createDate;
@property (strong, nonatomic) NSString *sendDate;
@property (strong, nonatomic) NSString *textId;
@property (assign, nonatomic) NSInteger urgencyCode;
@property (strong, nonatomic) NSString *urgencyName;

@property (assign, nonatomic) NSInteger securityCode;
@property (strong, nonatomic) NSString *securityName;

@property (assign, nonatomic) NSInteger state;
@property (strong, nonatomic) NSString *areaString;
@property (strong, nonatomic) NSString *promulgatingDepart;
@property (strong, nonatomic) NSArray<MemberModel> *listSubmitter;

@end




//
//
//{
//	"result": {
//		"mess": {
//			"errorCode": 200,
//			"message": "ThĂ nh cĂ´ng"
//		},
//		"data": {
//			"title": "Tao file ky",
//			"content": "Tao file ky",
//			"departSentSign": "Thá»§ trÆ°á»Ÿng Ä‘Æ¡n vá»‹ - Ban GiĂ¡m Ä‘á»‘c - Trung tĂ¢m Pháº§n má»m VÄƒn phĂ²ng Ä‘iá»‡n tá»¬ - TT PM 1 - Trung tĂ¢m Pháº§n má»m Viettel 1",
//			"departSentSignFullPathVof2": "Thá»§ trÆ°á»Ÿng Ä‘Æ¡n vá»‹ - Ban GiĂ¡m Ä‘á»‘c - Trung tĂ¢m Pháº§n má»m VÄƒn phĂ²ng Ä‘iá»‡n tá»¬ - TT PM 1 - Trung tĂ¢m Pháº§n má»m Viettel 1",
//			"departSentSignId": "7385",
//			"creator": "Nguyá»…n PhĂºc Äá»©c",
//			"createDate": "03/04/2017 15:22:59",
//			"email": "6485",
//			"phoneNumber": "0983015813",
//			"state": "1",
//			"urgencyCode": "1",
//			"urgencyName": "BĂ¬nh thÆ°á»ng",
//			"securityCode": "1",
//			"securityName": "BĂ¬nh thÆ°á»ng",
//			"typeId": "13",
//			"typeName": "Káº¿t luáº¬n",
//			"promulgatingDepart": "Trung tĂ¢m Pháº§n má»m VÄƒn phĂ²ng Ä‘iá»‡n tá»¬ - TT PM 1 - Trung tĂ¢m Pháº§n má»m Viettel 1",
//			"areaId": 7,
//			"areaString": "Káº¿ hoáº¡ch",
//			"signLevel": "0",
//			"code": "KL-PM1TTVPDT",
//			"fileMainSign": [
//							 {
//								 "fileAttachmentId": 120477,
//								 "fileName": "To trinh dieu chinh ke hoach san xuat 06 clip viral 4G.pdf",
//								 "filePath": "/Text/2017/4/3/90144/0b234807-314f-4079-9d13-00324017acb8.pdf",
//								 "storage": "storage8591",
//								 "lFilePage": 5,
//								 "lFileSize": 3571137
//							 }
//							 ],
//			"fileAttachFromSign": [],
//			"fileAttachFromDoc": [],
//			"listSubmitter": [
//							  {
//								  "textProcessId": "411583",
//								  "departSentSignFullPathVof2": "TrÆ°á»Ÿng Trung tĂ¢m - Trung tĂ¢m Pháº§n má»m VÄƒn phĂ²ng Ä‘iá»‡n tá»¬ - TT PM 1 - Trung tĂ¢m Pháº§n má»m Viettel 1",
//								  "email": "6485",
//								  "departmentName": "TrÆ°á»Ÿng Trung tĂ¢m - Trung tĂ¢m Pháº§n má»m VÄƒn phĂ²ng Ä‘iá»‡n tá»¬ - TT PM 1 - Trung tĂ¢m Pháº§n má»m Viettel 1",
//								  "departmentSignId": "6683",
//								  "signer": "Nguyá»…n PhĂºc Äá»©c",
//								  "signerId": "6485",
//								  "signerIdVO1": "26201",
//								  "signerCode": "010993",
//								  "status": 0,
//								  "senderId": 26201,
//								  "senderName": "Nguyá»…n PhĂºc Äá»©c",
//								  "receivedId": "259217",
//								  "haveImageSign": "0",
//								  "signatureType": "3",
//								  "signLevel": "0",
//								  "aliasName": "Nguyá»…n PhĂºc Äá»©c",
//								  "strCardNumner": "010993",
//								  "isCreateSignWeb2": 1,
//								  "orgVhrSignName": "Trung tĂ¢m Pháº§n má»m VÄƒn phĂ²ng Ä‘iá»‡n tá»¬ - TT PM 1 - Trung tĂ¢m Pháº§n má»m Viettel 1",
//								  "stateUserSign": 0,
//								  "mobile": "0983015813",
//								  "empVhrId": 6485,
//								  "empVhrName": "Nguyá»…n PhĂºc Äá»©c",
//								  "lstFilesCommentSign": [],
//								  "isReplaceSigner": 1
//							  }
//							  ],
//			"listReviewer": [],
//			"listInnitialSigner": [],
//			"lstStaffSend": [
//							 {
//								 "isSecrectaryVo1": false,
//								 "receiverId": "6485",
//								 "receiverName": "Nguyá»…n PhĂºc Äá»©c",
//								 "orgName": "Thá»§ trÆ°á»Ÿng Ä‘Æ¡n vá»‹ - Ban GiĂ¡m Ä‘á»‘c - Trung tĂ¢m Pháº§n má»m VÄƒn phĂ²ng Ä‘iá»‡n tá»¬ - TT PM 1 - Trung tĂ¢m Pháº§n má»m Viettel 1",
//								 "orgId": "259219"
//							 },
//							 {
//								 "isSecrectaryVo1": false,
//								 "receiverId": "18927",
//								 "receiverName": "Pháº¡m XuĂ¢n HoĂ ng",
//								 "orgName": "Thá»§ trÆ°á»Ÿng Ä‘Æ¡n vá»‹ - Ban GiĂ¡m Ä‘á»‘c - Trung tĂ¢m Pháº§n má»m Sáº£n pháº©m má»›i - TT PM 1 - Trung tĂ¢m Pháº§n má»m Viettel 1",
//								 "orgId": "259228"
//							 },
//							 {
//								 "isSecrectaryVo1": false,
//								 "receiverId": "422850",
//								 "receiverName": "LĂª Cao CÆ°á»ng",
//								 "orgName": "Trá»£ lĂ½ nghiá»‡p vá»¥ - NhĂ³m sáº£n pháº©m 2 - Trung tĂ¢m Pháº§n má»m VÄƒn phĂ²ng Ä‘iá»‡n tá»¬ - TT PM 1 - Trung tĂ¢m Pháº§n má»m Viettel 1",
//								 "orgId": "259223"
//							 },
//							 {
//								 "isSecrectaryVo1": false,
//								 "receiverId": "449648",
//								 "receiverName": "BĂ¹i TrÆ°á»ng Vinh",
//								 "orgName": "Thá»§ trÆ°á»Ÿng Ä‘Æ¡n vá»‹ - Ban GiĂ¡m Ä‘á»‘c - Trung tĂ¢m Pháº§n má»m Khai thĂ¡c dá»¯ liá»‡u - TT PM 1 - Trung tĂ¢m Pháº§n má»m Viettel 1",
//								 "orgId": "259251"
//							 },
//							 {
//								 "isSecrectaryVo1": false,
//								 "receiverId": "488816",
//								 "receiverName": "Nguyá»…n Thá»‹ Thu",
//								 "orgName": "Trá»£ lĂ½ nghiá»‡p vá»¥ - NhĂ³m Dá»± Ă¡n - Trung tĂ¢m Pháº§n má»m TĂ¬ch há»£p - TT PM 1 - Trung tĂ¢m Pháº§n má»m Viettel 1",
//								 "orgId": "259248"
//							 },
//							 {
//								 "isSecrectaryVo1": false,
//								 "receiverId": "495224",
//								 "receiverName": "Pháº¡m Thá»‹ Háº¡nh",
//								 "orgName": "Trá»£ lĂ½ nghiá»‡p vá»¥ - NhĂ³m Dá»± Ă¡n - Trung tĂ¢m Pháº§n má»m VÄƒn phĂ²ng Ä‘iá»‡n tá»¬ - TT PM 1 - Trung tĂ¢m Pháº§n má»m Viettel 1",
//								 "orgId": "259225"
//							 }
//							 ],
//			"textId": 90144,
//			"isLienKe": 0,
//			"creatorId": 26201,
//			"officePublishedId": 259217,
//			"autoPublicText": "0",
//			"autoPromulgateText": "1",
//			"autoSendText": "1",
//			"AUTO_PROMULGATE_TEXT": 1,
//			"AUTO_SEND_TEXT": 1,
//			"isCreateSignWeb2": 1,
//			"stateUserSign": 0,
//			"creatorIdVof2": 6485,
//			"sendDate": "03/04/2017 15:22:59"
//		}
//	}
//}
