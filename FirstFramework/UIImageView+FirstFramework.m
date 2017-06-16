//
//  UIImageView+FirstFramework.m
//  FirstFramework
//
//  Created by Marian on 6/16/17.
//  Copyright © 2017 Marian. All rights reserved.
//

#import "UIImageView+FirstFramework.h"
#import "TasksManager.h"

@implementation UIImageView (FirstFramework)
UIActivityIndicatorView *activityIndicator;

- (void)addActivityIndicatorWithStyle:(UIActivityIndicatorViewStyle)activityStyle {
    
    if (!activityIndicator) {
        activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:activityStyle];
        
        activityIndicator.autoresizingMask = UIViewAutoresizingNone;
        
        [self updateActivityIndicatorFrame];
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self addSubview:activityIndicator];
        }];
    }
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [activityIndicator startAnimating];
    }];
    
}

-(void)updateActivityIndicatorFrame {
    if (activityIndicator) {
        CGRect activityIndicatorBounds = activityIndicator.bounds;
        float x = (self.frame.size.width - activityIndicatorBounds.size.width) / 2.0;
        float y = (self.frame.size.height - activityIndicatorBounds.size.height) / 2.0;
        activityIndicator.frame = CGRectMake(x, y, activityIndicatorBounds.size.width, activityIndicatorBounds.size.height);
    }
}

- (void)removeActivityIndicator {
    if (activityIndicator) {
        [activityIndicator removeFromSuperview];
        activityIndicator = nil;
    }
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    [self updateActivityIndicatorFrame];
}

- (void)setImageWithURL:(NSString *)url {
    
    [self addActivityIndicatorWithStyle:UIActivityIndicatorViewStyleGray];

    __weak typeof(self) weakSelf = self;

    [[TasksManager sharedTasksManager] downloadImageFromURL:url successCompletionHandler:^(NSData *imageData) {
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [weakSelf removeActivityIndicator];

            self.image = [UIImage imageWithData:imageData];

        }];
    
    } failureCompletionHandler:^(NSError *error) {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [weakSelf removeActivityIndicator];
            
        }];
    }];
    
}
@end
