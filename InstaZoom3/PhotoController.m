//
//  PhotoController.m
//  InstaZoom3
//
//  Created by James Dean on 9/14/14.
//  Copyright (c) 2014 james. All rights reserved.
//

#import "PhotoController.h"
#import <SAMCache/SAMCache.h>

@implementation PhotoController


+ (void) imageForPhoto: (NSDictionary *)photo size:(NSString *)size completion:(void(^) (UIImage *image))completion{
    
    
    if (photo == nil || size == nil || completion == nil) {
        NSLog(@"crashed: something was nil ");
        return;
    }
    NSString *key = [[NSString alloc]initWithFormat:@"%@-%@",photo[@"id"],size];
    UIImage *image = [[SAMCache sharedCache]imageForKey:key];
    NSURL *url = [[NSURL alloc]initWithString:photo[@"images"][size][@"url"]];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    if (image) {
        completion(image);
        return;
    }
    
    
    NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        
        NSData *data = [[NSData alloc]initWithContentsOfURL:location];
        
        UIImage *image = [[UIImage alloc]initWithData:data];
        [[SAMCache sharedCache]setImage:image forKey:key];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(image);
            
        });
        
    }];
    [task resume];
    
    
    
}

@end
