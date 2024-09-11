//
//  XBSBugly.m
//  XBSBugly
//
//  Created by SSR on 2024/9/11.
//

#import "XBSBugly.h"
#import <Bugly/Bugly.h>
#import <Bugly/BuglyLog.h>
#import <Bugly/BuglyConfig.h>

NSString * const XBSBuglyAppID = @"41e7a3c1b3";
NSString * const XBSBuglyAppKey = @"c2299ab6-1680-4c45-a84a-a01b75e13709";

@interface XBSBugly () <BuglyDelegate>
@end

@implementation XBSBugly


+ (void)buglyInit {
    
    BuglyConfig *config = [[BuglyConfig alloc] init];
    
#if DEBUG
    config.debugMode = YES;
    config.channel = @"Cyxbs Debug";
#else
    config.debugMode = NO;
    config.channel = @"Cyxbs";
#endif
    
    config.blockMonitorEnable = YES;
    config.blockMonitorTimeout = 5;
    config.symbolicateInProcessEnable = YES;
    config.unexpectedTerminatingDetectionEnable = YES;
    config.viewControllerTrackingEnable = YES;
    config.delegate = self;
    config.reportLogLevel = BuglyLogLevelVerbose;
    config.consolelogEnable = YES;
    
    [Bugly startWithAppId:XBSBuglyAppID config:config];
    
}

// MARK: <BuglyDelegate>

- (NSString * BLY_NULLABLE)attachmentForException:(NSException * BLY_NULLABLE)exception {
    NSString *str = [NSString stringWithFormat:@"[Bugly] attachmentForException name:%@ reason:%@ info:%@", exception.name, exception.reason, exception.userInfo.debugDescription];
    
    NSLog(str);
    
    return str;
}

- (NSString * BLY_NULLABLE)attachmentForSigkill {
    NSString *str = [NSString stringWithFormat:@"[Bugly] attachmentForSigkill"];
    
    NSLog(str);
    
    return str;
}

- (BOOL) h5AlertForTactic:(NSDictionary *)tacticInfo {
    
    NSString *str = [NSString stringWithFormat:@"[Bugly] h5AlertForTactic: %@", tacticInfo.debugDescription];
    
    NSLog(str);
    
    return NO;
}

@end
