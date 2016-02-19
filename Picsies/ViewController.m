//
//  ViewController.m
//  Picsies
//
//  Created by DavitPiloyan on 2/19/16.
//  Copyright © 2016 Picsies. All rights reserved.
//

#import "ViewController.h"
#import "SCPagingTabController.h"
#import "SCWrapperScrollView.h"
#import "ContentController.h"

@interface ViewController () < SCPagingTabControllerDataSource,
                                SCPagingTabControllerDelegate,
                                UIScrollViewDelegate>

@property (nonatomic,weak) SCWrapperScrollView *scrollViewWrapper;
@property (nonatomic,weak) SCPagingTabController *tabController;
@property (nonatomic,weak) UIViewController *bannerControler;
@property (nonatomic) BOOL tabSelected;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];


}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
        [self initTabController];
}

- (BOOL)automaticallyAdjustsScrollViewInsets {
    return NO;
}

- (void)initTabController {
    SCWrapperScrollView* scrollViewWrapper = [[SCWrapperScrollView alloc] initWithFrame:self.view.bounds];
    self.scrollViewWrapper = scrollViewWrapper;
    self.scrollViewWrapper.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view insertSubview:self.scrollViewWrapper atIndex:0];
    
    UIViewController* bannerControler = [[UIViewController alloc] init];
    self.bannerControler = bannerControler;
    [self addChildViewController:self.bannerControler];
    [self.scrollViewWrapper addSubview:self.bannerControler.view];
    self.bannerControler.view.frame = (CGRect){CGPointZero, self.view.bounds.size.width, 160};
//    self.bannerControler.view.backgroundColor = [UIColor blueColor];

    self.bannerControler.view.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.bannerControler didMoveToParentViewController:self];
    
    SCPagingTabController* tabController = [[SCPagingTabController alloc] initWithTabTitles:self.tabTitles];
    
//    tabController.view.backgroundColor = [UIColor grayColor];
    
    self.tabController = tabController;
    self.tabController.dataSource = self;
    self.tabController.delegate = self;
    [self addChildViewController:self.tabController];
    [self.view addSubview:self.tabController.view];
    self.tabController.view.frame = self.view.bounds;
    self.tabController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.tabController didMoveToParentViewController:self];
    
    self.scrollViewWrapper.scrollContainerInsets = UIEdgeInsetsMake(self.bannerControler.view.frame.size.height ,
                                                                    0, 0, 0);
    self.scrollViewWrapper.scrollContainerView = self.tabController.view;
    self.scrollViewWrapper.delegate = self;
}

- (NSArray *)tabTitles {
    NSMutableArray *titles = [[NSMutableArray alloc] init];
    for (int i = 0; i < 10; i++) {
        [titles addObject:[NSString stringWithFormat:@"Name%@",@(i)]];
    }
//    for (SCSocialinShopTabItem *shopTab in [SCSocialin sharedInstance].socialin_props.shopTabs) {
//        if ((shopTab.tag && ![shopTab.tag isEqualToString:@""]) ||
//            [shopTab.price isEqualToString:@"free"] ||
//            [shopTab.price isEqualToString:@"paid"] ||
//            (shopTab.tags && shopTab.tags.count > 0)) {
//            [titles addObject:shopTab.title];
//        }
//    }
    return [titles copy];
}

- (UIViewController *)pagingTabController:(SCPagingTabController *)pagingViewController
                    viewControllerAtIndex:(NSUInteger)index {
    ContentController* collection = [[ContentController alloc] init];
    
//    SCSocialinShopTabItem *tabItem = [SCSocialin sharedInstance].socialin_props.shopTabs[index];
//    
//    if (tabItem.tags) {
//        collection = [self shopCategoryController:tabItem];
//    } else if ([tabItem.price isEqualToString:@"free"]) {
//        collection = [SCShopItemsBaseCollection createShopFreeItemsViewController];
//    } else if ([tabItem.price isEqualToString:@"paid"]) {
//        collection = [SCShopItemsBaseCollection createShopPaidItemsViewController];
//    } else if ([tabItem.tag isEqualToString:@"installed"]) {
//        collection = [SCShopItemsBaseCollection createShopInstalledViewController];
//    } else if (tabItem.tag != nil && ![tabItem.tag isEqualToString:@""] ) {
//        collection = [SCNetViewController shopItemByTag:tabItem.tag sourceTab:tabItem.tag source:nil];
//    }
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
//    [self setNavigationBarBackgroundDependsOffset];
    
    UIView* cover = self.bannerControler.view;
    float offset = scrollView.contentOffset.y;
    float coverH = cover.bounds.size.height;
    if (offset <= 0) {
        float s = (coverH - offset) / coverH;
        
        cover.transform = CGAffineTransformMakeScale(s, s);
        cover.center = CGPointMake(cover.center.x, cover.bounds.size.height / 2 + (cover.bounds.size.height - cover.frame.size.height) / 2);
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self stoppedScrolling];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView
                  willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        [self stoppedScrolling];
    }
}

- (void)stoppedScrolling {
    return; //TODO
    
    float newOffsetY = -self.scrollViewWrapper.contentInset.top;
    if (self.scrollViewWrapper.contentOffset.y > self.scrollViewWrapper.scrollContainerInsets.top / 2) {
        newOffsetY = self.scrollViewWrapper.scrollContainerInsets.top + 1; //TODO
    }
    CGPoint offset = self.scrollViewWrapper.contentOffset;
    offset.y = newOffsetY;
    [self.scrollViewWrapper setContentOffset:offset animated:YES];
}


- (void)dealloc {
    self.scrollViewWrapper.delegate = nil;
}





@end
