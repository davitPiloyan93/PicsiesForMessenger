//
//  UIColor+Socialin.h
//  picsart
//
//  Created by Arthur on 9/18/14.
//  Copyright (c) 2014 Socialin Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface UIColor (Socialin)

+ (UIColor *)lightBlueTintColor;
+ (UIColor *)lightGrayTableBGColor;
+ (UIColor *)lightOrangeColor;
+ (UIColor *)orangeTintColor;
+ (UIColor *)lightBlueHighlightColor;
+ (UIColor *)transparentBlackColor;

//textColors
+ (UIColor *)lightGrayTextColor;
+ (UIColor *)grayTextColor;
+ (UIColor *)colorWithHexString:(NSString *)hexString;

+ (UIColor *)randomColor;

+ (UIColor *)colorFromHex:(int)color withOpacity:(int)opacity;
+ (UIColor *)colorFromHex:(int)color;

- (NSString *)hexString;

- (BOOL)isEqualToColor:(UIColor*)color accuracy:(float)accuracy;

- (UIColor*)supplementaryColor;

@end
