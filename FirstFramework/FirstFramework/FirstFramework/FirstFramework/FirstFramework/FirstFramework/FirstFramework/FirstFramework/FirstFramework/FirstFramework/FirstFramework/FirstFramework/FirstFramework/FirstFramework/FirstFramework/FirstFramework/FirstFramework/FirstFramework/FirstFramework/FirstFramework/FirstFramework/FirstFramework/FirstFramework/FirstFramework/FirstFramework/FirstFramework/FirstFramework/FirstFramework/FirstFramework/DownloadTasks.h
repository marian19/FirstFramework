//
//  DownloadTasks.h
//  MHTTP
//
//  Created by Marian on 6/14/17.
//  Copyright © 2017 Marian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Task.h"

@interface DownloadTasks : Task

- (void)downloadTaskWithURL:(NSString *)urlString progress:(void (^)(double  fractionCompleted))progress successCompletionHandler:(void (^)(id  filePath))success failureCompletionHandler:(void (^)(NSError * error))failure;

@end
