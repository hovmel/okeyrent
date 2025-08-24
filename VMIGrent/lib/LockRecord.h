//
//  LockRecord.h
//  LockLib
//
//  Created by AirbnkGuest on 2018/10/16.
//  Copyright © 2018年 com.seamoon. All rights reserved.
//

#import <Foundation/Foundation.h>
#define PackerHead 0xAA

@interface LockRecord : NSObject
@property (nonatomic, assign) NSUInteger time;
@property (nonatomic, strong) NSString* type; // unlock & lock
@property (nonatomic, assign) NSUInteger fId;
@property (nonatomic, strong) NSString* recordId;
@property (nonatomic, assign) NSUInteger recordType;
@property (nonatomic, strong) NSString* deviceId;//sn或用户Id
@property (nonatomic, strong) NSString* operatorId;//唯一时间戳

+(NSArray<LockRecord *> *) transferDataToRecords:(NSData *)data;

@end


