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
    [self.contentView addSubview:button];
    self.fbbutton.hidden = YES;

}

-(void)layoutSubviews {
    [super layoutSubviews];
    self.fbbutton.frame = CGRectMake((CGRectGetWidth(self.contentView.bounds)-50)/2, (CGRectGetHeight(self.contentView.bounds)-50)/2, 50, 50);
}

- (void)hideViews:(BOOL)hide animation:(BOOL)animation {
    if (animation) {
        if (hide) {
            [UIView animateWithDuration:0.4 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:1 options:0 animations:^{
                self.fbbutton.transform = CGAffineTransformMakeScale(0.0001, 0.0001);
                self.popupView.hidden = YES;
            } completion:^(BOOL finished) {
                
                self.fbbutton.hidden = YES;
                self.fbbutton.transform = CGAffineTransformIdentity;
            }];
        } else {
            self.fbbutton.transform = CGAffineTransformMakeScale(0.0001, 0.0001);
            self.fbbutton.hidden = NO;
            self.popupView.hidden = NO;
            [UIView animateWithDuration:0.4 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:1 options:0 animations:^{
                self.fbbutton.transform = CGAffineTransformIdentity;
            } completion:nil];
        }
    } else {
        self.popupView.hidden = hide;
        self.fbbutton.hidden = hide;
    }
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
    [self hideViews:YES animation:NO];
}

- (void)shareButtonPressed:(UIButton *)sender {
    FBSDKMessengerShareOptions *options = [[FBSDKMessengerShareOptions alloc] init];
    options.renderAsSticker = YES;
    [FBSDKMessengerSharer shareImage:self.imageView.image withOptions:options];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self hideViews:YES animation:NO];
    });
}

@end
