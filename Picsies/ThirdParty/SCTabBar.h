//
//  SCTabBarNew.h
//  picsart
//
//  Created by Arman Margaryan on 5/1/15.
//  Copyright (c) 2015 Socialin Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SCTabBar;

@protocol SCTabBarDelegateNew <NSObject>

- (void)tabBar:(SCTabBar*)tabBar didSelectTabAtIndex:(NSUInteger)index byUser:(BOOL)byUser;

@end

@interface SCTabBarTabData : NSObject<NSCopying>
+(instancetype)dataWithTitle:(NSString *)title image:(UIImage *)image;
-(instancetype)initWithTitle:(NSString *)title image:(UIImage *)image;
@property(nonatomic) NSString *title;
@property(nonatomic) UIImage *image;
@end

@interface SCTabBar : UIView


@property (nonatomic) NSUInteger selectedTabIndex;

@property (nonatomic, weak) id <SCTabBarDelegateNew> delegate;

- (instancetype)initWithFrame:(CGRect)frame tabs:(NSArray<SCTabBarTabData *> *)tabs;

- (id)initWithFrame:(CGRect)frame tabTitles:(NSArray*)tabTitles;

- (void)setProgress:(float)progress fromTapping:(BOOL)fromTapping;

@end
