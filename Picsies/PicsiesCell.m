//
//  PicsiesCell.m
//  Picsies
//
//  Created by DavitPiloyan on 2/19/16.
//  Copyright © 2016 Picsies. All rights reserved.
//

#import "PicsiesCell.h"
#import "UIImageView+WebCache.h"
#import <FBSDKMessengerShareKit/FBSDKMessengerShareKit.h>

@interface PicsiesCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (nonatomic) UIView *popupView;

@property (nonatomic) UIButton *fbbutton;

@end

@implementation PicsiesCell

- (void)awakeFromNib {
    
    // Initialization code
    
    self.popupView = [[UIView alloc]initWithFrame:self.bounds];
    
    self.popupView.backgroundColor = [UIColor whiteColor];
    self.popupView.alpha = .7;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closePopup:)];
    [self.popupView addGestureRecognizer:tapGesture];
    self.popupView.hidden = YES;
    [self.contentView addSubview:self.popupView];
    
    CGFloat buttonWidth = 50;
    UIButton *button = [FBSDKMessengerShareButton circularButtonWithStyle:FBSDKMessengerShareButtonStyleBlue
                                                                    width:buttonWidth];
    self.fbbutton = button;
    [button addTarget:self action:@selector(shareButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake((CGRectGetWidth(self.bounds)-50)/2, (CGRectGetHeight(self.bounds)-50)/2, 50, 50);
    [self.contentView addSubview:button];
    self.fbbutton.hidden = YES;

}

- (void)hideViews:(BOOL)hide {
    self.popupView.hidden = hide;
    self.fbbutton.hidden = hide;
}

- (void)setData:(NSURL *)imageURL {
    [self.imageView sd_setImageWithURL:imageURL placeholderImage:[self imageWithColor:[UIColor colorWithWhite:239.f/255.f alpha:1]]];
}

-(UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)closePopup:(UITapGestureRecognizer *)recognizer {
    [self hideViews:YES];
    
}

- (void)shareButtonPressed:(UIButton *)sender {
    FBSDKMessengerShareOptions *options = [[FBSDKMessengerShareOptions alloc] init];
    options.renderAsSticker = YES;
    [FBSDKMessengerSharer shareImage:self.imageView.image withOptions:options];
    [self hideViews:NO];
}

@end
