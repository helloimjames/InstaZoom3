//
//  DetailViewController.m
//  InstaZoom3
//
//  Created by James Dean on 9/14/14.
//  Copyright (c) 2014 james. All rights reserved.
//

#import "DetailViewController.h"
#import "PhotoController.h"

@interface DetailViewController ()
@property(nonatomic)UIImageView *imageView;
@property (nonatomic) UIDynamicAnimator *animator;

@end

@implementation DetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithWhite:1.0 alpha:.95];
    
    self.imageView =[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, -320.0f, 320.0f)];
    [self.view addSubview:self.imageView];
    [PhotoController imageForPhoto:self.photo size:@"standard_resolution" completion:^(UIImage *image) {
        self.imageView.image = image;
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(close)];
    [self.view addGestureRecognizer:tap];
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];

    
}

//-(void)viewDidLayoutSubviews{
//    [super viewDidLayoutSubviews];
//    CGSize size = self.view.bounds.size;
//    CGSize imageSize = CGSizeMake(size.width, size.width);
//    self.imageView.frame = CGRectMake(0.0, (size.height - imageSize.height)/2.0, imageSize.width, imageSize.height);
//

    
    
//}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    UISnapBehavior *snap = [[UISnapBehavior alloc] initWithItem:self.imageView snapToPoint:self.view.center];
    [self.animator addBehavior:snap];

}

-(void)close{
    [self dismissViewControllerAnimated:YES completion:nil];


}

@end
