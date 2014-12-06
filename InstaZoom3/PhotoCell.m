//
//  PhotoCell.m
//  InstaZoom
//
//  Created by James Dean on 9/13/14.
//  Copyright (c) 2014 james. All rights reserved.
//

#import "PhotoCell.h"
#import <SAMCache/SAMCache.h>
#import "PhotoController.h"
@implementation PhotoCell

-(void)setPhoto:(NSDictionary *)photo{
    _photo = photo;
    //NSURL *url = [[NSURL alloc]initWithString:_photo[@"images"][@"thumbnail"][@"url"]];
    //[self downloadPhotoWithURL:url];
    [PhotoController imageForPhoto:_photo size:@"thumbnail" completion:^(UIImage *image) {
        self.imageView.image = image;
        //NSLog(@"%@", image);
    }];
        
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = [[UIImageView alloc]init];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(like)];
        tap.numberOfTapsRequired = 2;
        [self addGestureRecognizer:tap];
        
        
        
        
        [self.contentView addSubview:self.imageView];
        
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.imageView.frame = self.contentView.bounds;
    
}

-(void)downloadPhotoWithURL:(NSURL *)url{
    
    NSString *key = [[NSString alloc]initWithFormat:@"%@-thumbnail",self.photo[@"id"]];
    UIImage *photo = [[SAMCache sharedCache]imageForKey:key];
    
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    if (photo) {
        self.imageView.image = photo;
        NSLog(@"%@", photo);
        return;
    }
    
    
    NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        
        NSData *data = [[NSData alloc]initWithContentsOfURL:location];
        
        UIImage *image = [[UIImage alloc]initWithData:data];
        [[SAMCache sharedCache]setImage:image forKey:key];

        dispatch_async(dispatch_get_main_queue(), ^{
            self.imageView.image = image;
           
        });
        
    }];
    [task resume];

    
}
-(void)like{
    
    NSURLSession *session  = [NSURLSession sharedSession];
    NSString *accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"accessToken"];
    NSString *urlString = [[NSString alloc] initWithFormat:@"https://api.instagram.com/v1/media/%@/likes?access_token=%@",self.photo[@"id"], accessToken];
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"POST";
    NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showLikeCompletion];
        });
        
    }];
    
    [task resume];
    
}

-(void)showLikeCompletion{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"liked!" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
    
    [alert show];
    double delayInSeconds = 0.8;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^{
        [alert dismissWithClickedButtonIndex:0 animated:YES];
    });
    
}

@end
