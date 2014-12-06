//
//  PhotoController.h
//  InstaZoom3
//
//  Created by James Dean on 9/14/14.
//  Copyright (c) 2014 james. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoController : UIViewController
+ (void) imageForPhoto: (NSDictionary *)photo size:(NSString *)size completion:(void(^) (UIImage *image))completion;
@end
