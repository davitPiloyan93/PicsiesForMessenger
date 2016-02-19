//
//  ViewController.m
//  Picsies
//
//  Created by DavitPiloyan on 2/19/16.
//  Copyright © 2016 Picsies. All rights reserved.
//

#import "ViewController.h"
#import <FBSDKMessengerShareKit/FBSDKMessengerShareKit.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *button = [FBSDKMessengerShareButton rectangularButtonWithStyle:FBSDKMessengerShareButtonStyleBlue];
    [button addTarget:self action:@selector(sendAction) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"Send" forState:UIControlStateNormal];
    [self.view addSubview:button];
    button.center = self.view.center;
    
    //[FBSDKMessengerSharer messengerPlatformCapabilities] & FBSDKMessengerPlatformCapabilityImage)
    //NSLog(@"Error - Messenger platform capabilities don't include image sharing");
}

-(void)sendAction {
    FBSDKMessengerShareOptions *options = [[FBSDKMessengerShareOptions alloc] init];
    options.renderAsSticker = YES;
    
    [FBSDKMessengerSharer shareImage:[UIImage imageNamed:@"test_icon"] withOptions:options];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
