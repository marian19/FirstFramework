//
//  Task.m
//  MHTTP
//
//  Created by Marian on 6/14/17.
//  Copyright © 2017 Marian. All rights reserved.
//

#import "Task.h"
#import "ErrorUtility.h"


@implementation Task

+ (Task *)sharedTask
{
    static Task *_sharedTask = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedTask = [[Task alloc] init];
    });
    
    return _sharedTask;
}

-(void)dataTaskWithURL:(NSString *)urlString method:(HTTPRequestMethod)HTTPRequestMethod withParameters:(NSDictionary*)parameters successCompletionHandler:(void (^)(NSData*  responseData))success failureCompletionHandler:(void (^)(NSError * error))failure{
    
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSMutableURLRequest *request = [NSMutableURLRequest new];
    
    [request setTimeoutInterval:600.0];


    if (HTTPRequestMethod == HTTPRequestGET){
        [request setHTTPMethod:@"GET"];
        
        if (parameters) {
            // request body
            if ([urlString rangeOfString:@"?"].location == NSNotFound) {
               urlString = [urlString stringByAppendingString:@"?"];
            }
          
            
            for (NSInteger i = 0; i < parameters.count; i++) {
                NSString *currentKey = [parameters.allKeys objectAtIndex:i];
                NSString *currentValue = [parameters.allValues objectAtIndex:i];
                NSString *subString;
                if (i == parameters.count -1)
                {
                    subString = [NSString stringWithFormat:@"%@=%@" ,currentKey ,currentValue];
                }
                else
                {
                    subString = [NSString stringWithFormat:@"%@=%@&" ,currentKey ,currentValue];
                }
                urlString = [urlString stringByAppendingString:[subString stringByReplacingOccurrencesOfString:@" " withString:@"%20"]];
            }
        }
        
        // request url
        [request setURL:[NSURL URLWithString:urlString]];
        
    }
    else{
        if (HTTPRequestMethod == HTTPRequestPOST)
            [request setHTTPMethod:@"POST"];
        else if (HTTPRequestMethod == HTTPRequestPUT)
            [request setHTTPMethod:@"PUT"];
        else if (HTTPRequestMethod == HTTPRequestDELETE)
            [request setHTTPMethod:@"DELETE"];
        
        if (parameters){
            
            NSString *postString = @"";
            NSArray * keys  = [parameters allKeys];
            for(int x = 0 ; x < [keys count] ; x++){
                
                postString = [postString stringByAppendingString:[NSString stringWithFormat:@"%@=%@&" , [keys objectAtIndex:x] , [parameters objectForKey:[keys objectAtIndex:x]]]];
                
            }
            
            [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
            
        }
        
        [request setURL:url];
        
    }
    
    NSLog(@"url %@" , request.URL);
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error) {
            NSHTTPURLResponse *httpResp = (NSHTTPURLResponse*) response;
            
            if (httpResp.statusCode == 200) {
                success(data);
            }else{
            
                error = [ErrorUtility errorWithCode:(int)httpResp.statusCode localizedDescriptionKey:[NSString stringWithFormat:@"%ld %@" ,(long)httpResp.statusCode ,httpResp.description] localizedFailureReasonErrorKey:nil localizedRecoverySuggestionErrorKey:nil];
                
                failure(error);
            }
            
        }else{
            NSLog(@"error %@",error.description);
            
            failure(error);
        }
        
        
    }];
    [postDataTask resume];
}


@end
