//
//  Task.h
//  MHTTP
//
//  Created by Marian on 6/14/17.
//  Copyright © 2017 Marian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Enumrations.h"


@interface Task : NSObject<NSURLSessionDelegate>
+ (Task *)sharedTask;

-(void)dataTaskWithURL:(NSString *)urlString method:(HTTPRequestMethod)HTTPRequestMethod withParameters:(NSDictionary*)parameters successCompletionHandler:(void (^)(NSData*  responseData))success failureCompletionHandler:(void (^)(NSError * error))failure;
@end
