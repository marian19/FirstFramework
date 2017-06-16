//
//  ErrorUtility.h
//  FirstFramework
//
//  Created by Marian on 6/16/17.
//  Copyright © 2017 Marian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ErrorUtility : NSObject
+ (NSError *) errorWithCode:(int)code localizedDescriptionKey:(NSString *)localizedDescriptionKey localizedFailureReasonErrorKey:(NSString *)localizedFailureReasonErrorKey localizedRecoverySuggestionErrorKey:(NSString *)localizedRecoverySuggestionErrorKey;

+(NSError*)getReachMaxNumberRequestsError;
@end
