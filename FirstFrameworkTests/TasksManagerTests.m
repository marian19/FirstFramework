//
//  TasksManagerTests.m
//  FirstFramework
//
//  Created by Marian on 6/16/17.
//  Copyright © 2017 Marian. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TasksManager.h"

@interface TasksManagerTests : XCTestCase
@property (nonatomic, strong) TasksManager *tasksManager;

@end

@implementation TasksManagerTests

- (void)setUp {
    [super setUp];
    self.tasksManager = [TasksManager sharedTasksManager];
}

- (void)tearDown {
    self.tasksManager = nil;
    [super tearDown];
}

- (void)testSharedManagerIsNotEqualToInitManager {
    XCTAssertFalse([[TasksManager new] isEqual:self.tasksManager]);
}

- (void)testGetDataWithUrlInvokesSuccessCompletionBlockWithDataOnSuccess{
    __block id blockResponseData = nil;
    __block id blockError = nil;
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request should succeed"];
    
    [self.tasksManager dataTaskWithURL:@"https://api.github.com/search/repositories?q=swift&sort=stars&order=desc" method:HTTPRequestGET withParameters:nil successCompletionHandler:^(NSData* responseData) {
        
        blockResponseData = responseData;
        [expectation fulfill];

    } failureCompletionHandler:^(NSError *error) {
        blockError = error;
        [expectation fulfill];

    }];
    
    [self waitForExpectationsWithTimeout:10.0 handler:nil];
    
    XCTAssertNil(blockError);
    XCTAssertNotNil(blockResponseData);
}

- (void)testGetDataWithUrlInvokesFailureCompletionBlockWithErrorOnFailure {
    __block id blockError = nil;
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request should fail"];
    
    [self.tasksManager dataTaskWithURL:@"https://api.github.com/search/repositoriesq=swift&sort=stars&order=desc" method:HTTPRequestGET withParameters:nil successCompletionHandler:^(NSData* responseData) {
        [expectation fulfill];

        
    } failureCompletionHandler:^(NSError *error) {
        
        blockError = error;
        [expectation fulfill];
        
        
    }];
    
    [self waitForExpectationsWithTimeout:10.0 handler:nil];
    XCTAssertNotNil(blockError);
}

- (void)testdownloadImageFromURLInvokesSuccessCompletionBlockWithDataOnSuccess {
    __block id blockResponseData = nil;
    __block id blockError = nil;
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request should succeed"];
    
    [self.tasksManager downloadImageFromURL:@"https://goo.gl/vusyxe" successCompletionHandler:^(NSData *imageData) {
        
        blockResponseData = imageData;
        [expectation fulfill];
        
    } failureCompletionHandler:^(NSError *error) {
        blockError = error;

    }];
    
    [self waitForExpectationsWithTimeout:10.0 handler:nil];
    
    XCTAssertNil(blockError);
    XCTAssertNotNil(blockResponseData);
}

- (void)testdownloadImageFromURLInvokesFailureCompletionBlockWithErrorOnFailure {
    __block id blockError = nil;
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request should fail"];
    
    [self.tasksManager downloadImageFromURL:@"https://goo0.gl/vusyxe" successCompletionHandler:^(NSData *imageData) {
        [expectation fulfill];

        
    } failureCompletionHandler:^(NSError *error) {
        
        blockError = error;
        [expectation fulfill];
        
        
    }];
    
    [self waitForExpectationsWithTimeout:10.0 handler:nil];
    XCTAssertNotNil(blockError);
}

@end
