//
//  DownloadTasks.m
//  MHTTP
//
//  Created by Marian on 6/14/17.
//  Copyright © 2017 Marian. All rights reserved.
//

#import "DownloadTasks.h"

@implementation DownloadTasks

- (void)downloadTaskWithURL:(NSString *)urlString progress:(void (^)(double  fractionCompleted))progress successCompletionHandler:(void (^)(id  filePath))success failureCompletionHandler:(void (^)(NSError * error))failure{


    AFURLSessionManager *manager = [self getSessionManager];

    NSURL *URL = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        

        
        progress(downloadProgress.fractionCompleted);
        
    } destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        // Do operation after download is complete
        if (error) {
            NSLog(@"Error: %@", error);
            failure(error);
        } else {
            NSLog(@"%@ %@", response, filePath);
            success(filePath);
        }
    }];
    [downloadTask resume];

}
@end
