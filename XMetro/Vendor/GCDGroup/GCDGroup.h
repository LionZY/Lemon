//
//  GCDGroup.h
//  XMetro
//
//  Created by Yue Zhang on 2022/10/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GCDGroup : NSObject
+ (dispatch_group_t)create;
+ (void)enter:(dispatch_group_t)group;
+ (void)leave:(dispatch_group_t)group;
+ (void)notify:(dispatch_group_t)group;
@end

NS_ASSUME_NONNULL_END
