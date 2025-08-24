//
//  AirbnkSDK.h
//  AirbnkSDK
//
//  Created by laiwh on 2020/12/11.
//  Copyright © 2020 com.seamoon. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "LockRecord.h"

typedef NS_ENUM(NSInteger, LockState) {
    LockStateLocked =0,
    LockStateUnLock,
    LockStateLockedOpen,
    LockStateLockedClose,
    LockStateUnLockOpen,
    LockStateUnLockClose,
    LockStateJammed,
};

typedef NS_ENUM(NSInteger, LockVoltage) {
    LockVoltageHigh = 0,
    LockVoltageMiddle,
    LockVoltageLow,
    LockVoltageEmpty
};

typedef NS_ENUM(NSInteger, LockVoltageType) {
    LockVoltageTypeCharge = 0,
    LockVoltageTypeDrybattery,
};

typedef NS_ENUM(NSInteger, LockRecordType) {
    LockRecordTypeNormal = 0,
    LockRecordTypeEEProm,
};

@protocol AirbnkSDKDelegate <NSObject>

@optional

/// didConnectLock
/// @param sninfo sninfo description
-(void) didConnectLock:(nullable NSString*) sninfo;

/// didDisConnectLock
/// @param sninfo sninfo description
-(void) didDisConnectLock:(nullable NSString*) sninfo;

/// responeseLockStatus
/// @param state state description
-(void) responeseLockStatus:(LockState) state;

/// responseLockVoltage
/// @param voltage voltage description
-(void) responseLockVoltage:(LockVoltage) voltage;

/// responseConfigLock
/// @param state state description
-(void) responseConfigLock:(BOOL) state;

/// responseLockRecords
/// @param records records description
-(void) responseLockRecords:(nullable NSArray<LockRecord*>*) records;

/// responseBindLock
/// @param status status description
-(void) responseBindLock:(BOOL) status;

/// responseRemoveBindLock
/// @param status status description
-(void) responseRemoveBindLock:(BOOL) status;

/// responseRegisterStatus
/// @param status status description
/// @param progress process description
/// @param fpId fpId description
-(void) responseRegisterStatus:(NSInteger) status progress:(NSInteger) progress fingerprintId:(NSInteger) fpId;

/// responseDeleteFingerprint
/// @param state state description
-(void) responseDeleteFingerprint:(BOOL) state;

/// responseAddPassword
/// @param state state description
-(void) responseAddPassword:(BOOL) state;

/// responseDeletePassword
/// @param state state description
-(void) responseDeletePassword:(BOOL) state;

/// responseFingerprints
/// @param fingerprints fingerprints description
-(void) responseFingerprints:(nullable NSArray*) fingerprints;

/// responseUpgradeFirmWare
/// @param state state description
/// @param progress progress description
-(void) responseUpgradeFirmWare:(BOOL) state progress:(float) progress;

/// responseSyncTimeBle
/// @param state state description
-(void) responseSyncTimeBle:(BOOL) state;

/// responseUpdateBindKey
/// @param state state description
-(void) responseUpdateBindKey:(BOOL) state newSnInfo:(nullable NSString*) newSnInfo;

/// responseGetLockTime
/// @param state state description
/// @param locktime locktime description
-(void) responseGetLockTime:(BOOL) state locktime:(NSInteger) locktime;

/// responseDeleteRecords
/// @param state state description
-(void) responseDeleteRecords:(BOOL) state;

/// responeseFail
/// @param errorCode errorCode description
-(void) responeseFail:(NSInteger) errorCode;

/// blestatus
/// @param status status description
-(void) blestatus:(NSUInteger) status;

@end


@interface AirbnkSDK : NSObject
/// initAirbnkSDK
+(void) initAirbnkSDK:(nullable NSString*) sdkKey;

/// handleDelegate
/// @param sdkDelegate sdkDelegate description
+(void) handleDelegate:(nullable id<AirbnkSDKDelegate>)sdkDelegate;

/// connectToLock
/// @param sninfo sninfo description
+(void) connectToLock:(nullable NSString*) sninfo;

/// disconnectToLock
/// @param sninfo sninfo description
+(void) disconnectToLock:(nullable NSString*) sninfo;

/// getLockStatus
/// @param sninfo sninfo description
+(void) getLockStatus:(nullable NSString*) sninfo;

/// getLockVoltage
/// @param sninfo sninfo description
+(void) getLockVoltage:(nullable NSString*) sninfo;

/// unlock
/// @param sninfo sninfo description
+(void) unlock:(nullable NSString*) sninfo;

/// lock
/// @param sninfo sninfo description
+(void) lock:(nullable NSString*) sninfo;

/// configLock
/// @param sninfo sninfo description
/// @param direction direction description
/// @param autoLock autoLock description
/// @param autoTime autoTime description
/// @param doorSensor doorSensor description
/// @param doorSensorAutoLockTime doorSensorAutoLockTime description
/// @param handRotation handRotation description
/// @param latchTime latchTime description
+(void) configLock:(nullable NSString*) sninfo openDirection:(NSInteger) direction autoLock:(NSInteger) autoLock autoLockTime:(NSInteger) autoTime doorSensor:(NSInteger) doorSensor doorSensorAutoLockTime:(NSInteger) doorSensorAutoLockTime handRotation:(NSInteger) handRotation latchTime:(NSInteger) latchTime;

/// getLockRecords
/// @param snInfo snInfo description
/// @param type type description
+(void) getLockRecords:(nullable NSString*)snInfo recordType:(LockRecordType) type;

/// deleteLockRecords
/// @param snInfo snInfo description
+(void) deleteLockRecords:(nullable NSString*)snInfo;

/// bindLock
/// @param snInfo snInfo description
/// @param lockSninfo lockSninfo description
+(void) bindLock:(nullable NSString*)snInfo lockSninfo:(nullable NSString*) lockSninfo;

/// removeBindLock
/// @param snInfo snInfo description
+(void) removeBindLock:(nullable NSString*)snInfo;

/// registerFingerprint
/// @param snInfo snInfo description
+(void) registerFingerprint:(nullable NSString*)snInfo;

/// deleteFingerprint
/// @param snInfo snInfo description
/// @param fpId fpId description
+(void) deleteFingerprint:(nullable NSString*)snInfo fingerprintId:(NSInteger) fpId;

/// addPassword
/// @param snInfo snInfo description
/// @param pwdIndex pwdIndex description
/// @param password password description
/// @param startTime startTime description
/// @param endTime endTime description
/// @param once once description
+(void) addPassword:(nullable NSString*)snInfo pwdIndex:(NSUInteger) pwdIndex password:(nullable NSString*) password startTime:(NSUInteger) startTime endTime:(NSUInteger) endTime isOnce:(BOOL) once;

/// deletePassword
/// @param snInfo snInfo description
/// @param pwdIndex pwdIndex description
+(void) deletePassword:(nullable NSString*)snInfo pwdIndex:(NSUInteger) pwdIndex;

/// getFingerprints
/// @param snInfo snInfo description
+(void) getFingerprints:(nullable NSString*)snInfo;

/// getOneTimePassWord
/// @param snInfo snInfo description
+(nullable NSString*) getOneTimePassWord:(nullable NSString*)snInfo;

/// getsyncTime
/// @param snInfo snInfo description
+(nullable NSString*) getsyncTime:(nullable NSString*)snInfo;

/// syncTimeBle
/// @param snInfo snInfo description
+(void) syncTimeBle:(nullable NSString*)snInfo;

/// upgradeFirmWare
/// @param firmware firmware description
/// @param snInfo snInfo description
+(void) upgradeFirmWare:(nullable NSData*) firmware deviceSnInfo:(nullable NSString*) snInfo;

/// updateBindKey
/// @param snInfo snInfo description
/// @param newSercetKey newSercetKey description
/// @param appid appid description
+(void) updateBindKey:(nullable NSString*)snInfo newSercetKey:(nullable NSString*)newSercetKey appid:(nullable NSString*) appid;

/// setLocalTime
/// @param localTime localTime description
/// @param snInfo snInfo description
+(void) setLocalTime:(NSUInteger) localTime deviceSnInfo:(nullable NSString*) snInfo;

/// getLockTime
/// @param snInfo snInfo description
+(void) getLockTime:(nullable NSString*) snInfo;

/// getSnWithSnInfo
/// @param snInfo snInfo description
+(nonnull NSString*) getSnWithSnInfo:(nullable NSString*) snInfo;

@end
