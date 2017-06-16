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
#import "ErrorUtility.h"

@implementation TasksManager
NSOperationQueue *taskQueue;

+ (TasksManager *) sharedTasksManager
{
    static TasksManager *_sharedTasksManager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedTasksManager = [[TasksManager alloc] init];
        taskQueue = [[NSOperationQueue alloc] init];
        
    });
    
    return _sharedTasksManager;
}

-(void) executingTasksInSerialOrder:(BOOL)isFIFO{
    if (isFIFO) {
        taskQueue.maxConcurrentOperationCount = 1;
    }
    
}


- (void)dataTaskWithURL:(NSString *)urlString method:(HTTPRequestMethod)HTTPRequestMethod withParameters:(NSDictionary*)parameters successCompletionHandler:(void (^)(NSData*  responseData))success failureCompletionHandler:(void (^)(NSError * error))failure{
    
    
    NSError *error = [self isValidRequest];
    if (error == nil) {
        [taskQueue addOperationWithBlock:^{
            
            [self extendingBackGroundTaskTime];
            
            [[Task sharedTask] dataTaskWithURL:urlString method:HTTPRequestMethod withParameters:parameters successCompletionHandler:^(NSData* responseData) {
                success(responseData);
                
            } failureCompletionHandler:^(NSError *error) {
                failure(error);
                NSLog(@"error %@",error.description);
                
            }];
        }];
        
    }else{
        NSLog(@"error %@",error.description);
        
        failure(error);
    }
    
}

-(NSError*)isValidRequest{
    
    NSError *error = nil;
    
    NSUInteger numberOfRequest = taskQueue.operationCount;
    
    Reachability *reachability = Reachability.reachabilityForInternetConnection;
    
    BOOL isReachabilityStartNotifier = reachability.startNotifier;
    if (isReachabilityStartNotifier) {
        
        if ([reachability currentReachabilityStatus] == NotReachable) {
            
            
            error = [ErrorUtility errorWithCode:-8 localizedDescriptionKey:@"Operation was unsuccessful." localizedFailureReasonErrorKey:@"Check your internet Connection" localizedRecoverySuggestionErrorKey:nil];
            
        }else if ([reachability currentReachabilityStatus] == ReachableViaWiFi) {
            
            if (numberOfRequest > 6) {
                
                error = [ErrorUtility getReachMaxNumberRequestsError];
                
            }
            
        }else if ([reachability currentReachabilityStatus] == ReachableViaWWAN) {
            if (numberOfRequest > 2) {
                
                error = [ErrorUtility getReachMaxNumberRequestsError];
                
            }
            
        }
        if (error != nil) {
            NSLog(@"error %@",error.description);
            
        }
    }
    [reachability stopNotifier];
    return error;
}



-(void) extendingBackGroundTaskTime{
    UIBackgroundTaskIdentifier backgroundTask  = 0;
    
    UIApplication  *app = [UIApplication sharedApplication];
    
    backgroundTask = [app beginBackgroundTaskWithExpirationHandler:^{
        [taskQueue cancelAllOperations];
        [app endBackgroundTask:backgroundTask];
        
    }];
    
    
}

-(void)downloadImageFromURL:(NSString *)urlString successCompletionHandler:(void (^)(NSData* imageData))success failureCompletionHandler:(void (^)(NSError * error))failure{
    
    [self extendingBackGroundTaskTime];
    
    [taskQueue addOperationWithBlock:^{
        
        NSURL *imageURL = [NSURL URLWithString:urlString];
        NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
        if(imageData != nil){
            success(imageData);
        }else{
            NSError* error = [ErrorUtility errorWithCode:-7 localizedDescriptionKey:@"Faild to download the image." localizedFailureReasonErrorKey:@"This is probably a result of Apple's new app transport security denying a non-HTTPS request " localizedRecoverySuggestionErrorKey:@"Try to add <key>NSAppTransportSecurity </key><><dict><key>NSAllowsArbitraryLoads</key><true/></dict> to your plist"];
            
            failure(error);
        }
    }];
    
}
@end
