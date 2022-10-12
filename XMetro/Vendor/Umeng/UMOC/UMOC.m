//
//  UMOC.m
//  XMetro
//
//  Created by Yue Zhang on 2022/10/12.
//

#import "UMOC.h"

@implementation UMOC
+ (void)config {
    //[NSURLProtocol registerClass:[UMURLProtocol class]];
    
    UMAPMConfig *config = [UMAPMConfig defaultConfig];
    config.networkEnable = YES;
    [UMCrashConfigure setAPMConfig:config];
    [UMConfigure initWithAppkey:@"6343ddf288ccdf4b7e4574be" channel:@"App Store"];
}

+ (void)registerPush:(NSDictionary * __nullable)launchOptions delegate:(id<UNUserNotificationCenterDelegate>) delegate{
    UMessageRegisterEntity *entity = [[UMessageRegisterEntity alloc] init];
    entity.types = UMessageAuthorizationOptionBadge | UMessageAuthorizationOptionSound | UMessageAuthorizationOptionAlert;
    [UMessage registerForRemoteNotificationsWithLaunchOptions:launchOptions Entity:entity completionHandler:^(BOOL granted, NSError * _Nullable error) {
        
    }];
    [UNUserNotificationCenter currentNotificationCenter].delegate = delegate;
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
