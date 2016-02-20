//
//  ViewController.m
//  Picsies
//
//  Created by DavitPiloyan on 2/19/16.
//  Copyright © 2016 Picsies. All rights reserved.
//

#import "ViewController.h"
#import <FBSDKMessengerShareKit/FBSDKMessengerShareKit.h>
#import "SCPagingTabController.h"
#import "SCWrapperScrollView.h"
#import "PicsiesCollectionViewController.h"
#import "StickersSliderViewController.h"
#import "StickersClient.h"

@interface ViewController () < SCPagingTabControllerDataSource,
                                SCPagingTabControllerDelegate,
                                StickersSliderDelegate,
                                UIScrollViewDelegate>

@property (nonatomic,weak) SCWrapperScrollView *scrollViewWrapper;
@property (nonatomic,weak) SCPagingTabController *pagingTabController;
@property (nonatomic,weak) StickersSliderViewController *stickerSliderVC;
@property (nonatomic) BOOL tabSelected;
@property (nonatomic) UIActivityIndicatorView *indicatorView;
@property (nonatomic) NSArray *stickers;
@property (nonatomic) UIView *noNetworkView;
@property (nonatomic) BOOL dsadsa;



@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self requestItems];
}

- (void)createNoNetworkView {
    if (self.noNetworkView) {
        self.noNetworkView.hidden = NO;
        return;
    }
    self.noNetworkView = [[UIView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:self.noNetworkView];
    self.noNetworkView.backgroundColor = [UIColor whiteColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, (CGRectGetHeight(self.view.bounds)-80) /2, CGRectGetWidth(self.view.bounds), 30.f)];
    label.text = @"Oops! prblems with Network";
    label.font = [UIFont systemFontOfSize:17.f];
    label.textColor = [UIColor colorWithWhite:130.f/255.f alpha:1];
    label.textAlignment = NSTextAlignmentCenter;
    [self.noNetworkView addSubview:label];
    
    UIButton *retryButton = [[UIButton alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.view.bounds) - 70)/2, (CGRectGetHeight(self.view.bounds)- 70)/2 +40 , 70, 70)];
    [retryButton setImage:[UIImage imageNamed:@"retry"] forState:UIControlStateNormal];
    [retryButton addTarget:self action:@selector(retryAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.noNetworkView addSubview:retryButton];
    
}

- (void)requestItems {

    [self.indicatorView startAnimating];
    StickersClient *client = [[StickersClient alloc] init];
    __weak ViewController *weakSelf = self;
    [client stickersWithComplitionBlock:^(NSArray * items) {
        
        if (items.count) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                weakSelf.stickers = items;
                [weakSelf.indicatorView stopAnimating];
                [weakSelf.indicatorView removeFromSuperview];
                weakSelf.indicatorView = nil;
                [weakSelf initTabController];
                weakSelf.noNetworkView.hidden = YES;
                
            });
            
        } else {
            [weakSelf.indicatorView stopAnimating];
            [weakSelf.indicatorView removeFromSuperview];
            weakSelf.indicatorView = nil;
            [weakSelf createNoNetworkView];
        }
    }];

}

- (void)retryAction:(UIButton *)sender {
    self.noNetworkView.hidden = YES;
    [self requestItems];
}

- (UIActivityIndicatorView *)indicatorView {
    if (_indicatorView == nil) {
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _indicatorView.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));
        [self.view addSubview:_indicatorView];
    }
    return _indicatorView;
}

- (BOOL)automaticallyAdjustsScrollViewInsets {
    return NO;
}

- (void)initTabController {
    SCWrapperScrollView* scrollViewWrapper = [[SCWrapperScrollView alloc] initWithFrame:CGRectMake(0, 30.f, self.view.bounds.size.width, self.view.bounds.size.height)];
    self.scrollViewWrapper = scrollViewWrapper;
    self.scrollViewWrapper.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view insertSubview:self.scrollViewWrapper atIndex:0];
    
    StickersSliderViewController* stickerSliderVC = [[StickersSliderViewController alloc] init];
    self.stickerSliderVC = stickerSliderVC;
    self.stickerSliderVC.delegate = self;
    NSMutableArray *items = [[NSMutableArray alloc] init];
    for (Sticker *item in self.stickers) {
        
           NSString *bannerUrl = [NSString stringWithFormat:@"%@1.jpg", item.shopItemBannerUrl];
        [items addObject:bannerUrl];
    }
    self.stickerSliderVC.banners = items;
    self.stickerSliderVC.view.frame = (CGRect){CGPointZero, (CGSize){CGRectGetWidth(self.view.bounds), 188}};
    [self addChildViewController:self.stickerSliderVC];
    [self.scrollViewWrapper addSubview:self.stickerSliderVC.view];
    [self.stickerSliderVC didMoveToParentViewController:self];
    
    SCPagingTabController* tabController = [[SCPagingTabController alloc] initWithTabTitles:self.tabTitles];
    
    self.pagingTabController = tabController;
    self.pagingTabController.dataSource = self;
    self.pagingTabController.delegate = self;
    [self addChildViewController:self.pagingTabController];
    [self.view addSubview:self.pagingTabController.view];
    self.pagingTabController.view.frame = self.view.bounds;
    self.pagingTabController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.pagingTabController didMoveToParentViewController:self];
    
    self.scrollViewWrapper.scrollContainerInsets = UIEdgeInsetsMake(self.stickerSliderVC.view.frame.size.height,
                                                                    0, 0, 0);
    self.scrollViewWrapper.scrollContainerView = self.pagingTabController.view;
    self.scrollViewWrapper.delegate = self;
}

- (NSArray *)tabTitles {
    NSMutableArray *titles = [[NSMutableArray alloc] init];
    
    for (Sticker *sticker in self.stickers) {
        [titles addObject:[NSString stringWithFormat:@"%@",sticker.shop_item_name]];
    }

    return [titles copy];
}

- (UIViewController *)pagingTabController:(SCPagingTabController *)pagingViewController
                    viewControllerAtIndex:(NSUInteger)index {
    
    
    PicsiesCollectionViewController* collection = [[PicsiesCollectionViewController alloc] init];
    collection.sticker = self.stickers[index];
    
    return collection;
}

- (void)pagingTabController:(SCPagingTabController *)tabController
      didShowViewController:(UIViewController *)viewController
                    atIndex:(NSUInteger)index {
    UICollectionView* collectionView = [(id)viewController collectionView];
    collectionView.scrollsToTop = NO;
    self.scrollViewWrapper.scrollView = collectionView;
    self.tabSelected = NO;
}

- (void)pagingTabSelectedAtIndex:(NSUInteger)index byUser:(BOOL)byUser{
    if (byUser) {
        self.tabSelected = YES;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    UIView* cover = self.stickerSliderVC.view;
    float offset = scrollView.contentOffset.y;
    float coverH = cover.bounds.size.height;
    if (offset <= 0) {
        float s = (coverH - offset) / coverH;
        
        cover.transform = CGAffineTransformMakeScale(s, s);
        cover.center = CGPointMake(cover.center.x, cover.bounds.size.height / 2 + (cover.bounds.size.height - cover.frame.size.height) / 2);
    }
}

- (void)stickerSliderVC:(StickersSliderViewController *)stickerSliderVC selectedAtIndx:(NSUInteger)index {
    NSLog(@"index : %@", @(index));
    self.tabSelected = YES;
    [self.pagingTabController setVisibleIndex:index animated:NO];
}

- (void)dealloc {
    self.scrollViewWrapper.delegate = nil;
}

@end
