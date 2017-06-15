//
//  TasksManager.m
//  MHTTP
//
//  Created by Marian on 6/14/17.
//  Copyright © 2017 Marian. All rights reserved.
//

#import "TasksManager.h"
#import "Reachability.h"
#import "UIKit/UIKit.h"

@implementation TasksManager
NSOperationQueue *taskQueue;

+ (TasksManager *)sharedHTTPClient
{
    static TasksManager *_sharedHTTPClient = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedHTTPClient = [[TasksManager alloc] init];
        taskQueue = [[NSOperationQueue alloc] init];
        
    });
    
    return _sharedHTTPClient;
}

-(void) executingTasksInSerialOrder:(BOOL)isFIFO{
    if (isFIFO) {
        taskQueue.maxConcurrentOperationCount = 1;
    }
    
}




- (void)dataTaskWithURL:(NSString *)urlString method:(HTTPRequestMethod)HTTPRequestMethod withParameters:(NSDictionary*)parameters successCompletionHandler:(void (^)(id  responseObject))success failureCompletionHandler:(void (^)(NSError * error))failure{
    
    NSError *error = [self isValidRequest];
    if (error == nil) {
        [self extendingBackGroundTaskTime];
        
        [taskQueue addOperationWithBlock:^{
            
            [[Task new] dataTaskWithURL:urlString method:HTTPRequestMethod withParameters:parameters successCompletionHandler:^(id responseObject) {
                success(responseObject);
            } failureCompletionHandler:^(NSError *error) {
                failure(error);
            }];
        }];
        
    }else{
        failure(error);
    }
}




-(NSError*)isValidRequest{
    
    NSError *error = nil;
    
    NSUInteger numberOfRequest = taskQueue.operationCount;
    
    if ([[Reachability new] currentReachabilityStatus] == ReachableViaWiFi) {
        
        if (numberOfRequest == 6) {
            return  error = [self getReachMaxNumberRequestsError];
        }
        
    }else if ([[Reachability new] currentReachabilityStatus] == ReachableViaWWAN) {
        if (numberOfRequest == 2) {
            return  error = [self getReachMaxNumberRequestsError];
        }
        
    }else  {
        NSDictionary *userInfo = @{
                                   NSLocalizedDescriptionKey: NSLocalizedString(@"Operation was unsuccessful.", nil),
                                   NSLocalizedFailureReasonErrorKey: NSLocalizedString(@"Connection Error", nil)
                                   };
        
        return [NSError errorWithDomain:NSCocoaErrorDomain
                                   code:-57
                               userInfo:userInfo];
        
    }
    
    return error;
}

-(NSError*)getReachMaxNumberRequestsError{
    NSDictionary *userInfo = @{
                               NSLocalizedDescriptionKey: NSLocalizedString(@"Operation was unsuccessful.", nil),
                               NSLocalizedFailureReasonErrorKey: NSLocalizedString(@"You Reach the max number of concurrent requests.", nil)
                               };
    
    return [NSError errorWithDomain:NSCocoaErrorDomain
                               code:-57
                           userInfo:userInfo];
}

-(void) extendingBackGroundTaskTime{
    UIBackgroundTaskIdentifier backgroundTask  = 0;
    
    UIApplication  *app = [UIApplication sharedApplication];
    
    backgroundTask = [app beginBackgroundTaskWithExpirationHandler:^{
        [taskQueue cancelAllOperations];
        [app endBackgroundTask:backgroundTask];
        
    }];
    
    
}
@end
