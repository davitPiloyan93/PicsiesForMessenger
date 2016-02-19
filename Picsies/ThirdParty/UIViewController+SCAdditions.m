//
//  SCViewController.m
//  picsart
//
//  Created by Hovhannes Safaryan on 11/3/14.
//  Copyright (c) 2014 Socialin Inc. All rights reserved.
//

#import "UIViewController+SCAdditions.h"
#import <objc/runtime.h>

//this method intended for youtube cards, when opening video in full screen
BOOL hasAVPlayerView(UIView *view) {
    NSArray *subviews = view.subviews;
    if (subviews.count == 0){
        return [NSStringFromClass([view class]) isEqual:@"AVPlayerView"];
    } else {
        if (subviews.count == 1){
            UIView *firstView = subviews.firstObject;
            return [NSStringFromClass([firstView class]) isEqual:@"AVPlayerView"];

        }
    }
    return NO;
}

@implementation UIPopoverPresentationController (SCAdditions)

static char key;

- (UINavigationController *)sc_parentNavigationController {
    return objc_getAssociatedObject(self, &key);
}

- (void)setSc_parentNavigationController:(UINavigationController *)navigationController {
    objc_setAssociatedObject(self, &key, navigationController, OBJC_ASSOCIATION_ASSIGN);
}

@end


@implementation UIViewController (SCAdditions)

-(void)addChildViewController:(UIViewController *)childViewController atIndex:(int)childIndex  {
    [self addChildViewController:childViewController toView:self.view atIndex:childIndex];
}

-(void)addChildViewController:(UIViewController *)childViewController toView:(UIView *)view  {
    [self addChildViewController:childViewController toView:view atIndex:-1];
}

- (BOOL)parentViewControllerIsContainer {
    if (([self.parentViewController isKindOfClass:[UINavigationController class]]) ||
        ([self.parentViewController isKindOfClass:[UITabBarController class]])) {
            return  true;
        } else {
            return false;
        }
}

-(void)addChildViewController:(UIViewController *)childViewController toView:(UIView *)view atIndex:(int)childIndex {
    [self addChildViewController:childViewController];
    if (childIndex == -1) {
        [view addSubview:childViewController.view];
    } else {
        [view insertSubview:childViewController.view atIndex:childIndex];
    }
    [childViewController didMoveToParentViewController:self];
}

-(void)removeViewControllerFromParent {
    [self willMoveToParentViewController:nil];
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

-(BOOL)shouldAutorotate {
    return  hasAVPlayerView(self.view);
}

-(NSUInteger)supportedInterfaceOrientations {
    return hasAVPlayerView(self.view) == YES ? UIInterfaceOrientationMaskAll : UIInterfaceOrientationMaskPortrait;
}


+ (UIViewController *)topmostPresentedViewController {
    UIViewController* vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (vc.presentedViewController) {
        vc = vc.presentedViewController;
    }
    return vc;
}

- (void)callWhenNoTransition:(void(^)())completion {
    if (self.transitionCoordinator) {
        [self.transitionCoordinator animateAlongsideTransition:NULL completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
            completion();
        }];
    } else {
        completion();
    }
}

- (UIPopoverPresentationController *)sc_popoverPresentationController {
    UIPopoverPresentationController *popover = nil;
    UIViewController *vc = self;
    while (vc) {
        popover = vc.popoverPresentationController;
        vc = vc.parentViewController;
    }
    return popover;
}

@end
