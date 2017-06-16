//
//  ErrorUtility.m
//  FirstFramework
//
//  Created by Marian on 6/16/17.
//  Copyright © 2017 Marian. All rights reserved.
//

#import "ErrorUtility.h"

@implementation ErrorUtility

+ (NSError *) errorWithCode:(int)code localizedDescriptionKey:(NSString *)localizedDescriptionKey localizedFailureReasonErrorKey:(NSString *)localizedFailureReasonErrorKey localizedRecoverySuggestionErrorKey:(NSString *)localizedRecoverySuggestionErrorKey{

    
    NSDictionary *userInfo = @{
                               NSLocalizedDescriptionKey: NSLocalizedString(localizedDescriptionKey, nil),
                               NSLocalizedFailureReasonErrorKey: NSLocalizedString(localizedFailureReasonErrorKey, nil),NSLocalizedRecoverySuggestionErrorKey:NSLocalizedString(localizedRecoverySuggestionErrorKey, nil)
                               };
    
    return  [NSError errorWithDomain:NSCocoaErrorDomain
                                         code:code
                                     userInfo:userInfo];
}

+(NSError*)getReachMaxNumberRequestsError{
    
    
    return [ErrorUtility errorWithCode:-8 localizedDescriptionKey:@"Operation was unsuccessful." localizedFailureReasonErrorKey:@"You Reach the max number of concurrent requests." localizedRecoverySuggestionErrorKey:nil];
}

@end
