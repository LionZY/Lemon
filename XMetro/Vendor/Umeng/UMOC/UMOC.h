//
//  UMOC.h
//  XMetro
//
//  Created by Yue Zhang on 2022/10/12.
//

#import <UIKit/UIKit.h>
#import "UmengHeaders.h"

NS_ASSUME_NONNULL_BEGIN

@interface UMOC : NSObject
+ (void)config;
+ (void)registerPush:(UIApplication *)application launchOptions:(NSDictionary * __nullable)launchOptions delegate:(id<UNUserNotificationCenterDelegate>) delegate;
+ (NSString *)deviceTokenStr:(NSData *)deviceToken;
@end

NS_ASSUME_NONNULL_END
