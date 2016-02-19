//
//  SCViewController.h
//  picsart
//
//  Created by Hovhannes Safaryan on 11/3/14.
//  Copyright (c) 2014 Socialin Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIPopoverPresentationController (SCAdditions)

@property (nonatomic) UINavigationController *sc_parentNavigationController;

@end

@interface UIViewController (SCAdditions)

//finds UIPopoverPresentationController in parentViewControllers
@property (nonatomic, readonly) UIPopoverPresentationController *sc_popoverPresentationController;

-(void)addChildViewController:(UIViewController *)childViewController atIndex:(int)childIndex;

-(void)addChildViewController:(UIViewController *)childViewController toView:(UIView *)view;

-(void)addChildViewController:(UIViewController *)childViewController toView:(UIView *)view atIndex:(int)childIndex;
-(void)removeViewControllerFromParent;

- (BOOL)parentViewControllerIsContainer;

- (void)callWhenNoTransition:(void(^)())completion;

+ (UIViewController *)topmostPresentedViewController;

@end
