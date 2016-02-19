//
//  SCTabBarNew.m
//  picsart
//
//  Created by Arman Margaryan on 5/1/15.
//  Copyright (c) 2015 Socialin Inc. All rights reserved.
//

#define MIN_TAB_WIDTH 80
#define MAX_TAB_WIDTH 300

#import "SCTabBar.h"
#import "UIColor+Socialin.h"
#import "NSArray+SCAdditions.h"
//#import "UIImage+ImageEffects.h"


@implementation SCTabBarTabData

+(instancetype)dataWithTitle:(NSString *)title image:(UIImage *)image {
    return [[SCTabBarTabData alloc] initWithTitle:title image:image];
}

- (instancetype)initWithTitle:(NSString *)title image:(UIImage *)image {
    self = [super init];
    _title = title;
    _image = image;
    return self;
}

-(id)copyWithZone:(NSZone *)zone {
    return  [[SCTabBarTabData alloc] initWithTitle:self.title image:self.image];
}

@end

@interface SCTabBarItem : UIButton
@property(nonatomic) UIImage *originalImage;
@end

@implementation SCTabBarItem

- (id)initWithTabData:(SCTabBarTabData *)tabData
{
    self = [super initWithFrame:CGRectMake(0, 0, 100, 40)];
    if (self) {
        self.originalImage = tabData.image;
        [self setTitle:tabData.title forState:UIControlStateNormal];
        [self setColor:[UIColor colorWithWhite:137.0 / 255.0 alpha:1]];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        
        self.titleLabel.numberOfLines = 1;
        self.titleLabel.clipsToBounds = YES;
        self.titleLabel.adjustsFontSizeToFitWidth = YES;
        [self setContentEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 5)];
        self.titleLabel.minimumScaleFactor = 0.5f;
        
        UIEdgeInsets titleEdgeInsets = self.titleEdgeInsets;
        self.titleEdgeInsets = UIEdgeInsetsMake(titleEdgeInsets.top,
                                                titleEdgeInsets.left + 10,
                                                titleEdgeInsets.right,
                                                titleEdgeInsets.bottom);
    }
    return self;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    float h = self.bounds.size.height;
    if (h < 48) {
        CGRect rect = CGRectInset(self.bounds, 0, h - 48);
        return CGRectContainsPoint(rect, point);
    } else {
        return [super pointInside:point withEvent:event];
    }
}

-(void)setColor:(UIColor *)color {
    [self setTitleColor:color forState:UIControlStateNormal];
    [self setImage:[self imageWithTintColor:self.originalImage andColor:color] forState:UIControlStateNormal];
}

-(UIImage *)imageWithTintColor:(UIImage *)image andColor:(UIColor *)tintColor {
    UIGraphicsBeginImageContextWithOptions(image.size, NO, [[UIScreen mainScreen] scale]);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, image.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
    // draw alpha-mask
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGContextDrawImage(context, rect, image.CGImage);
    // draw tint color, preserving alpha values of original image
    CGContextSetBlendMode(context, kCGBlendModeSourceIn);
    [tintColor setFill];
    CGContextFillRect(context, rect);
    UIImage *coloredImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return coloredImage;
}


@end



@interface SCTabBar ()

@property (nonatomic) NSArray<SCTabBarTabData *> *tabsData;

@property (nonatomic, weak) SCTabBarItem* selectedTab;

@property (nonatomic) NSArray* tabs;

@property (nonatomic) UIFont* font;

@property (nonatomic, weak) UIScrollView* scrollView;

@property (nonatomic, weak) UIView* underlineView;

@property (nonatomic) float tabWidth;

@property (nonatomic) float progress;

//Transition
@property (nonatomic, weak) SCTabBarItem* fromTabBarItem;
@property (nonatomic, weak) SCTabBarItem* toTabBarItem;

@end

@implementation SCTabBar

-(instancetype)initWithFrame:(CGRect)frame tabs:(NSArray<SCTabBarTabData *> *)tabs {
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor blackColor];
        self.font = [UIFont boldSystemFontOfSize:12];
        
        UIScrollView* scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        self.scrollView = scrollView;
        self.scrollView.clipsToBounds = NO;
        self.scrollView.scrollsToTop = NO;
        [self addSubview:self.scrollView];
        
        UIView* underLineView = [UIView new];
        self.underlineView = underLineView;
        self.underlineView.backgroundColor = [UIColor orangeTintColor];
        self.underlineView.userInteractionEnabled = NO;
        [self.scrollView addSubview:self.underlineView];
        
        self.tabsData = tabs;

    }
    return self;
}

- (id)initWithFrame:(CGRect)frame tabTitles:(NSArray<NSString *> *)tabTitles {
    NSArray *tabsData = [tabTitles mapObjectsWithBlock:^id(NSString *obj, NSUInteger idx) {
        return  [[SCTabBarTabData alloc] initWithTitle:obj image:nil];
    }];
    return [self initWithFrame:frame tabs:tabsData];
}

- (void)selectTabAtIndex:(NSUInteger)index {
    _selectedTab = self.tabs[index];
    [self setProgress:index];
    [self.scrollView scrollRectToVisible:_selectedTab.frame animated:YES];
}

- (void)setSelectedTabIndex:(NSUInteger)selectedTabIndex {
    [self selectTabAtIndex:selectedTabIndex];
    [self.delegate tabBar:self didSelectTabAtIndex:selectedTabIndex byUser:NO];
}

-(void)setTabsData:(NSArray<SCTabBarTabData *> *)tabsData {
    _tabsData = tabsData;
    [self updateTabs];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self relayout];
}

- (SCTabBarItem*)createTabWithTabData:(SCTabBarTabData *)tabData {
    SCTabBarItem* item = [[SCTabBarItem alloc] initWithTabData:tabData];
    item.titleLabel.font = self.font;
    [item addTarget:self action:@selector(handleTabClick:) forControlEvents:UIControlEventTouchUpInside];
    return item;
}

- (void)recalculateTabWidth {
    float maxTitleWidth = 0;
    for (SCTabBarTabData *tabData in self.tabsData) {
        SCTabBarItem *tabBarItem = [[SCTabBarItem alloc] initWithTabData:tabData];
        [tabBarItem setNeedsLayout];
        [tabBarItem layoutIfNeeded];
        CGSize size = [tabBarItem intrinsicContentSize];
        if (size.width > maxTitleWidth) {
            maxTitleWidth = size.width;
        }
    }
    
    float tabWidth = MIN(MAX_TAB_WIDTH, MAX(MIN_TAB_WIDTH, maxTitleWidth));
    float preferredWidth = self.bounds.size.width / self.tabs.count;
    
    _tabWidth = MAX(preferredWidth, tabWidth);
}

- (void)relayout {
    [self recalculateTabWidth];
    for (int i = 0; i < self.tabs.count; ++i) {
        CGRect frame = CGRectMake(i * self.tabWidth, 0, self.tabWidth, self.bounds.size.height);
        UIButton* tab = self.tabs[i];
        tab.frame = frame;
    }
    CGSize contentSize = CGSizeMake(self.tabs.count * self.tabWidth, self.bounds.size.height);
    
    CGRect scrollViewFrame = self.bounds;
    scrollViewFrame.size.width = MIN(contentSize.width, scrollViewFrame.size.width);
    self.scrollView.frame = scrollViewFrame;
    
    self.scrollView.center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
    self.scrollView.contentSize = contentSize;
    
    [self setProgress:_progress];
}

- (void)updateTabs {
    for (UIButton* tab in self.tabs) {
        [tab removeFromSuperview];
    }
    NSMutableArray* newTabs = [NSMutableArray arrayWithCapacity:self.tabsData.count];
    for (int i = 0; i < self.tabsData.count; ++i) {
        UIButton* tab = [self createTabWithTabData:self.tabsData[i]];
        tab.tag = i;
        [newTabs addObject:tab];
        [self.scrollView addSubview:tab];
    }
    self.tabs = [newTabs copy];
    [self.scrollView bringSubviewToFront:self.underlineView];
}

- (void)setProgress:(float)progress {
    _progress = progress;
    float x = self.tabWidth * progress;
    float y = self.scrollView.bounds.size.height - 3;
    float w = self.tabWidth;
    float h = 3;
    self.underlineView.frame = CGRectMake(x, y, w, h);
    
    //tab title colors
    
    SCTabBarItem* fromItem = nil;
    SCTabBarItem* toItem = nil;
    
    int fromIndex = ceil(progress);
    int toIndex = floor(progress);
    
    UIColor* defaultColor = [UIColor colorWithWhite:137.0 / 255.0 alpha:1];
    
    if (fromIndex >= 0 && fromIndex < self.tabs.count) {
        fromItem = self.tabs[fromIndex];
        if (fromItem != self.fromTabBarItem) {
            [self.fromTabBarItem setColor:defaultColor];
            self.fromTabBarItem = fromItem;
        }
    }
    
    if (toIndex >= 0 && toIndex < self.tabs.count) {
        toItem = self.tabs[toIndex];
        if (fromItem != self.fromTabBarItem) {
            [self.toTabBarItem setColor:defaultColor];
            self.toTabBarItem = fromItem;
        }
    }
    
    float startWhite = 137;
    float endWhite = 255;
    
    float whiteDiff = (endWhite - startWhite);
    float relativeProgress = progress - floor(progress);
    float colorProgress = whiteDiff * relativeProgress;
    
    UIColor* fromColor = [UIColor colorWithWhite:(startWhite + colorProgress) / 255 alpha:1];
    UIColor* toColor = [UIColor colorWithWhite:(endWhite - colorProgress) / 255 alpha:1];
    
    [fromItem setColor:fromColor];
    [toItem setColor:toColor];
}

- (void)handleTabClick:(UIButton*)sender {
    [self selectTabAtIndex:sender.tag];
    [self.delegate tabBar:self didSelectTabAtIndex:sender.tag byUser:YES];
}

@end
