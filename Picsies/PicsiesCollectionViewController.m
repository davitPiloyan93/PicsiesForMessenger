//
//  ContentController.m
//  Picsies
//
//  Created by DavitPiloyan on 2/19/16.
//  Copyright © 2016 Picsies. All rights reserved.
//

#import "PicsiesCollectionViewController.h"
#import "PicsiesCell.h"
#import "StickersClient.h"
#import "Sticker.h"
#import "PicsiesPreviewView.h"
#import "UIImageView+WebCache.h"
#import <FBSDKMessengerShareKit/FBSDKMessengerShareKit.h>

#define offset 4

#define padding 16

@interface PicsiesCollectionViewController ()

@property (nonatomic) NSMutableArray *itemsIconsUrls;
@property (nonatomic) PicsiesPreviewView *stickerPreviewView;

@property (nonatomic,weak) UIView *PopupView;

@property (nonatomic) UIButton *fbbutton;

@property (nonatomic) NSIndexPath *currentIndexPath;



@end

@implementation PicsiesCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupShopItemIconsUrls];
 
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([PicsiesCell class]) bundle:nil] forCellWithReuseIdentifier:@"picsiesCellIdentifier"];
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setupStickerPreviewView];

}

- (void)setupStickerPreviewView {
    if (self.stickerPreviewView) {
        return;
    }
    
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];;
    self.stickerPreviewView = [[PicsiesPreviewView alloc] initWithFrame:window.bounds];
    [window addSubview:self.stickerPreviewView];
    self.stickerPreviewView.hidden = YES;
    
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(cellLongPressHandler:)];
    [self.collectionView addGestureRecognizer:longPressGesture];
}



- (void)setupShopItemIconsUrls {
    self.itemsIconsUrls = [[NSMutableArray alloc] initWithCapacity:10];
    if (self.sticker.shop_item_preview_count > 0) {
        int itemIconsCount = self.sticker.shop_item_preview_count;
        NSString* itemIconBaseUrl = self.sticker.shopItemIconUrl;
        for (int i = 1; i < itemIconsCount+1; i++) {
            NSString* itemIconUrl = [NSString stringWithFormat:@"%@%d.png", itemIconBaseUrl, i];
            [self.itemsIconsUrls addObject:itemIconUrl];
        }
    }
}


#pragma mark UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.itemsIconsUrls.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    PicsiesCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"picsiesCellIdentifier" forIndexPath:indexPath];
    [cell setData:self.itemsIconsUrls[indexPath.row]];
    
    if (self.currentIndexPath.row == indexPath.row) {
        [self showViews:YES];
    } else {
        [self showViews:NO];
    }
    
    return cell;
}

- (void)showViews:(BOOL)show {
    self.PopupView.hidden = show;
    self.fbbutton.hidden = show;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {

    int itemsPerRow = 2;
    if ([UIScreen mainScreen].bounds.size.height>600.f) {
        itemsPerRow = 3;
    }
    CGFloat itemSide = ([UIScreen mainScreen].bounds.size.width - (itemsPerRow + 1) * (padding - offset)) / itemsPerRow;
    return CGSizeMake(itemSide, itemSide);
}

- (void)cellLongPressHandler:(UIGestureRecognizer *)gr {
    static NSInteger position = -1;
    if (gr.state == UIGestureRecognizerStateChanged || gr.state == UIGestureRecognizerStateBegan) {
        [self.stickerPreviewView show:YES];
        CGPoint p = [gr locationInView:self.collectionView];
        NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:p];
        if (indexPath != nil) {
            NSInteger idx = indexPath.item;
            if (idx != position) {
                position = idx;
                id detailItem = self.itemsIconsUrls[idx];
                
                [self.stickerPreviewView.imageView sd_setImageWithURL:detailItem];
            }
        }
    } else {
        position = -1;
        self.stickerPreviewView.imageView.image = nil;
        [self.stickerPreviewView hide:YES];
    }
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.currentIndexPath = indexPath;
    PicsiesCell *currentSelectedCell = (PicsiesCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if (self.PopupView) {
        UIView *fbbutton = self.PopupView.superview.subviews[2];
        [fbbutton removeFromSuperview];
        [self.PopupView removeFromSuperview];
    }
    UIView *popUpView = [[UIView alloc]initWithFrame:currentSelectedCell.bounds];
    self.PopupView = popUpView;
    popUpView.backgroundColor = [UIColor whiteColor];
    popUpView.alpha = .7;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closePopup:)];
    [popUpView addGestureRecognizer:tapGesture];
    
    [currentSelectedCell addSubview:popUpView];
    CGFloat buttonWidth = 50;
    UIButton *button = [FBSDKMessengerShareButton circularButtonWithStyle:FBSDKMessengerShareButtonStyleBlue
                                                                    width:buttonWidth];
    self.fbbutton = button;
    [button addTarget:self action:@selector(shareButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    button.center = CGPointMake(CGRectGetWidth(currentSelectedCell.frame) / 2.f, CGRectGetHeight(currentSelectedCell.frame) / 2.f);
    [currentSelectedCell addSubview:button];
    return YES;
}

- (void)shareButtonPressed:(UIButton *)fbButton {
    FBSDKMessengerShareOptions *options = [[FBSDKMessengerShareOptions alloc] init];
    options.renderAsSticker = YES;
    [FBSDKMessengerSharer shareImage:[((PicsiesCell *)fbButton.superview) cellImageView].image withOptions:options];
    [self.PopupView removeFromSuperview];
    [fbButton removeFromSuperview];
    self.fbbutton = nil;
}


- (void)closePopup:(UITapGestureRecognizer *)tapGesture {
//    UIView *fbbutton = tapGesture.view.superview.subviews[2];
    [self.fbbutton removeFromSuperview];
    self.fbbutton = nil;
    [tapGesture.view removeFromSuperview];
}

- (void)dealloc {
    if (self.stickerPreviewView) {
        [self.stickerPreviewView removeFromSuperview];
    }
}

@end
