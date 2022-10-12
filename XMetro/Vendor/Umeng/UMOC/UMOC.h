//
//  UMOC.h
//  XMetro
//
//  Created by Yue Zhang on 2022/10/12.
//

#import <Foundation/Foundation.h>
#import <UMCommon/UMCommon.h>
#import <UMCommonLog/UMCommonLogManager.h>
#import <UMCommon/MobClick.h>
#import <UMAPM/UMAPMConfig.h>
#import <UMAPM/UMCrashConfigure.h>
#import <UMPush/UMessage.h>

NS_ASSUME_NONNULL_BEGIN

@interface UMOC : NSObject
+ (void)config;
+ (void)registerPush:(NSDictionary * __nullable)launchOptions delegate:(id<UNUserNotificationCenterDelegate>) delegate;
+ (NSString *)deviceTokenStr:(NSData *)deviceToken;
@end

NS_ASSUME_NONNULL_END
