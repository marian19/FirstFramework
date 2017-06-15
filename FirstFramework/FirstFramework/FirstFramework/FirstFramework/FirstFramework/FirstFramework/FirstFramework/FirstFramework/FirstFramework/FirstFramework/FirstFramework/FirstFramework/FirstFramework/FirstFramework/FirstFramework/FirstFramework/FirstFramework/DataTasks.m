//
//  DataTasks.m
//  MHTTP
//
//  Created by Marian on 6/14/17.
//  Copyright © 2017 Marian. All rights reserved.
//

#import "DataTasks.h"

@implementation DataTasks


- (void)dataTaskWithURL:(NSString *)urlString method:(HTTPRequestMethod)HTTPRequestMethod withParameters:(NSDictionary*)parameters successCompletionHandler:(void (^)(id  responseObject))success failureCompletionHandler:(void (^)(NSError * error))failure{
    
  AFURLSessionManager *manager = [self getSessionManager];
    
    NSMutableURLRequest *request  =  [[AFHTTPRequestSerializer serializer] requestWithMethod:[self methodTypeFromEnum:HTTPRequestMethod] URLString:urlString parameters:parameters error:nil];

    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
            failure(error);
        } else {
            NSLog(@"%@ %@", response, responseObject);
            success(responseObject);
        }
    }];
    [dataTask resume];
    
}

- (void)jsonDataTaskWithURL:(NSString *)urlString method:(HTTPRequestMethod)HTTPRequestMethod withParameters:(NSDictionary *)parameters
   successCompletionHandler:(void (^)(id))success failureCompletionHandler:(void (^)(NSError *))failure{
    
    AFURLSessionManager *manager = [self getSessionManager];
    
     NSMutableURLRequest *request =  [[AFJSONRequestSerializer serializer] requestWithMethod:[self methodTypeFromEnum:HTTPRequestMethod] URLString:urlString parameters:parameters error:nil];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
            failure(error);
        } else {
            NSLog(@"%@ %@", response, responseObject);
            success(responseObject);
        }
    }];
    [dataTask resume];


    
    
}

-(NSString*) methodTypeFromEnum:(HTTPRequestMethod)enumVal
{
    NSArray *imageTypeArray = [[NSArray alloc] initWithObjects:kImageTypeArray];
    return [imageTypeArray objectAtIndex:enumVal];
}
@end

