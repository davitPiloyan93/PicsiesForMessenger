//
//  UIColor+Socialin.m
//  picsart
//
//  Created by Arthur on 9/18/14.
//  Copyright (c) 2014 Socialin Inc. All rights reserved.
//

#import "UIColor+Socialin.h"

@implementation UIColor(Socialin)


+(UIColor *)randomColor {
    CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}

+ (UIColor *)lightBlueTintColor {
    return [UIColor colorWithRed:0.0/255.0
                           green:178.0/255.0
                            blue:245.0/255.0
                           alpha: 1.0];
}

+ (UIColor *)lightGrayTableBGColor {
    return [UIColor colorWithWhite:245.0 / 255.0 alpha:1];
}

+ (UIColor *)lightOrangeColor {
    return [UIColor colorWithRed:253.0/255.0
                           green:152.0/255.0
                            blue:125.0/255.0
                           alpha: 1.0];
}

+ (UIColor *)orangeTintColor {
    return [UIColor colorWithRed:253 / 255.0
                           green:89 / 255.0
                            blue:48 / 255.0
                           alpha:1];
}

+ (UIColor *)lightBlueHighlightColor {
    return [UIColor colorWithRed:98.0/255  green:202.0/255 blue:241.0/255 alpha:0.5];
}

+ (UIColor *)lightGrayTextColor {
    return [UIColor colorWithRed:188.0 / 255.0 green:190.0 / 255.0 blue:192.0 / 255.0 alpha:1];
}

+ (UIColor *)grayTextColor {
    return [UIColor colorWithWhite:123.0 / 255.0 alpha:1];
}

+ (UIColor *)colorWithHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    //    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

+ (UIColor *)transparentBlackColor {
    return [UIColor colorWithWhite:0.0 alpha:0.99];
}

- (NSString *)hexString {
    const CGFloat *components = CGColorGetComponents(self.CGColor);

    CGFloat r = components[0];
    CGFloat g = components[1];
    CGFloat b = components[2];

    return [NSString stringWithFormat:@"%02lX%02lX%02lX",
                                      lroundf(r * 255),
                                      lroundf(g * 255),
                                      lroundf(b * 255)];
}

+ (UIColor *)colorFromHex:(int)color {
    return [UIColor colorFromHex:color withOpacity:255];
}

+ (UIColor *)colorFromHex:(int)color withOpacity:(int)opacity {
    CGFloat red   = (0xFF & (color >> 16)) / 255.f;
    CGFloat green = (0xFF & (color >> 8)) / 255.f;
    CGFloat blue  = (0xFF & color) / 255.f;
    CGFloat alpha = opacity / 255.f;
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

- (BOOL)isEqualToColor:(UIColor*)color accuracy:(float)accuracy {
    CGFloat r1;
    CGFloat g1;
    CGFloat b1;
    [self getRed:&r1 green:&g1 blue:&b1 alpha:NULL];
    
    CGFloat r2;
    CGFloat g2;
    CGFloat b2;
    [color getRed:&r2 green:&g2 blue:&b2 alpha:NULL];
    
    float distance = sqrt((r2 - r1) * (r2 - r1) + (g2 - g1) * (g2 - g1) + (b2 - b1) * (b2 - b1));
    
    return (distance < accuracy);
}

- (UIColor*)supplementaryColor {
    CGFloat r;
    CGFloat g;
    CGFloat b;
    CGFloat a;
    [self getRed:&r green:&g blue:&b alpha:&a];
    CGFloat minRGB = MIN(r, MIN(g,b));
    CGFloat maxRGB = MAX(r, MAX(g,b));
    CGFloat minPlusMax = minRGB + maxRGB;
    return [UIColor colorWithRed:minPlusMax - r green:minPlusMax - g blue:minPlusMax - b alpha:a];
}

@end
