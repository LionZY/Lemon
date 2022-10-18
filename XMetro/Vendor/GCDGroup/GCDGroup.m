//
//  GCDGroup.m
//  XMetro
//
//  Created by Yue Zhang on 2022/10/17.
//

#import "GCDGroup.h"

@implementation GCDGroup
+ (dispatch_group_t)create {
    return dispatch_group_create();
}

+ (void)enter:(dispatch_group_t)group {
    dispatch_group_enter(group);
}

+ (void)leave:(dispatch_group_t)group {
    dispatch_group_leave(group);
}

+ (void)notify:(dispatch_group_t)group {
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{ });
}
@end
