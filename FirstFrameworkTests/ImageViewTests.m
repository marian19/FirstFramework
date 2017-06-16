//
//  ImageViewTests.m
//  FirstFramework
//
//  Created by Marian on 6/16/17.
//  Copyright © 2017 Marian. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "UIImageView+FirstFramework.h"

@interface ImageViewTests : XCTestCase
@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation ImageViewTests

- (void)setUp {
    [super setUp];
    self.imageView = [UIImageView new];

}

- (void)tearDown {
    self.imageView = nil;
    [super tearDown];
}

- (void)testThatImageCanBeDownloadedFromURL {
    XCTAssertNil(self.imageView.image);
    [self.imageView setImageWithURL:@"https://goo.gl/vusyxe"];
    [self expectationForPredicate:[NSPredicate predicateWithFormat:@"image != nil"]
              evaluatedWithObject:self.imageView
                          handler:nil];
    [self waitForExpectationsWithTimeout:20 handler:nil];
}



@end
