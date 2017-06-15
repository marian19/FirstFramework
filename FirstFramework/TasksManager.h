//
//  TasksManager.h
//  MHTTP
//
//  Created by Marian on 6/14/17.
//  Copyright © 2017 Marian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Task.h"

@interface TasksManager : NSObject

+ (TasksManager *)sharedHTTPClient;

-(void) executingTasksInSerialOrder:(BOOL)isFIFO;



- (void)dataTaskWithURL:(NSString *)urlString method:(HTTPRequestMethod)HTTPRequestMethod withParameters:(NSDictionary*)parameters successCompletionHandler:(void (^)(id  responseObject))success failureCompletionHandler:(void (^)(NSError * error))failure;




@end
