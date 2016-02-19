//
//  SCScrollViewContainer.h
//  picsart
//
//  Created by Arman Margaryan on 5/3/15.
//  Copyright (c) 2015 Socialin Inc. All rights reserved.
//

#ifndef picsart_SCScrollViewContainer_h
#define picsart_SCScrollViewContainer_h

@protocol SCScrollViewContainer <NSObject>

@property(nonatomic) BOOL adjustScrollTopInset;

- (UIScrollView*)scrollView;

@end

#endif
