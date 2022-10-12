//
//  UMOC.m
//  XMetro
//
//  Created by Yue Zhang on 2022/10/12.
//

#import "UMOC.h"

@implementation UMOC
+ (void)config {
    [UMCommonLogManager setUpUMCommonLogManager];
    [UMConfigure setLogEnabled:NO];
    [UMConfigure initWithAppkey:@"6343ddf288ccdf4b7e4574be" channel:@"App Store"];
}

+ (void)registerPush:(UIApplication *)application launchOptions:(NSDictionary * __nullable)launchOptions delegate:(id<UNUserNotificationCenterDelegate>) delegate {
    UMessageRegisterEntity *entity = [UMessageRegisterEntity new];
    entity.types = UMessageAuthorizationOptionBadge | UMessageAuthorizationOptionSound | UMessageAuthorizationOptionAlert;
    [UNUserNotificationCenter currentNotificationCenter].delegate = delegate;
    [UMessage registerForRemoteNotificationsWithLaunchOptions:launchOptions Entity:entity completionHandler:^(BOOL granted, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if(error) {
                NSLog(@"%@", error);
            }
        });
    }];
}

+ (NSString *)deviceTokenStr:(NSData *)deviceToken {
    if (![deviceToken isKindOfClass:[NSData class]]) return nil;
    const unsigned *tokenBytes = (const unsigned *)[deviceToken bytes];
    NSString *hexToken = [NSString stringWithFormat:@"%08x%08x%08x%08x%08x%08x%08x%08x",
                          ntohl(tokenBytes[0]), ntohl(tokenBytes[1]), ntohl(tokenBytes[2]),
                          ntohl(tokenBytes[3]), ntohl(tokenBytes[4]), ntohl(tokenBytes[5]),
                          ntohl(tokenBytes[6]), ntohl(tokenBytes[7])];
    return hexToken;
}
@end
