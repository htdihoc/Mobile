//
//  DetailMeetingModel.h
//  SmartOffice
//
//  Created by Kaka on 5/17/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import "SOBaseModel.h"

@interface DetailMeetingModel : SOBaseModel

@end


//{duration : Thời gian họp hh24:mm - hh24:mm,
//	roomId : id phòng họp,roomName : Tên phòng họp,
//	subject : Chủ đề cuộc họp (title),
//	content : nội dung cuộc họp (sumary),
//	note : ghi chú,custome : trang phục,
//	contactPerson : đầu mối liên hệ,
//	preMeetingTask : công việc chuẩn bị,
//	recurrence:	Check có phải định kỳ không? 0: khong theo dinh ky, 1. hang tuan, 2 hang thang, 3 hang nam,
//	creatorId : id người tạo,
//	creatorName : tên người tạo,
//	startHour : giờ bắt đầu,
//	endHour : giờ kết thúc,
//	startMinute : phút bắt đầu,
//	endMinute : phút kết thúc,
//	meetingId: id cuộc họp,
//	startTime : thời gian bắt đầu cuộc họp dd/mm/yyyy hh24:mm:ss,
//	endTime : thời gian kết thúc cuộc họp dd/mm/yyyy hh24:mm:ss,
//	type:0 - lịch cá nhân; 1 - lịch đơn vị,
//	listParticipates [{ employeeId : id thành phần tham gia,employeeName : tên thành phần tham gia,employeeCode : mã nhân viên,email : email,mobilePhone : sđt,orgId : id đơn vị,orgName : tên đơn vị,isPresident: 1 - chủ trì; #1 - không phải chủ trì,isParticipate:1 - tham gia; #1 - ko fai tham gia,isPrepare: 1 - chuẩn bị; #1 - ko fai chuẩn bị,}],listFileAttachment [{fileAttachmentId : id file,fileName : tên file,filePath : path file,storage : storage lưu file,dataFile : data file,}]
//}



