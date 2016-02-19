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
#import <FBSDKMessengerShareKit/FBSDKMessengerShareKit.h>

#define offset 4
#define itemsPerRow 3
#define padding 16

@interface PicsiesCollectionViewController ()

@property (nonatomic) NSMutableArray *itemsIconsUrls;

@property (nonatomic,weak) UIView *PopupView;

@property (nonatomic) UIButton *fbbutton;

@property (nonatomic) PicsiesCell *currentSelectedCell;



@end

@implementation PicsiesCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupShopItemIconsUrls];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([PicsiesCell class]) bundle:nil] forCellWithReuseIdentifier:@"picsiesCellIdentifier"];
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
    
//    if (cell != self.currentSelectedCell) {
//        self.PopupView.hidden = YES;
//        self.fbbutton.hidden = YES;
//    } else {
//        self.PopupView.hidden = NO;
//        self.fbbutton.hidden = NO;
//    }
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat itemSide = ([UIScreen mainScreen].bounds.size.width - (itemsPerRow + 1) * (padding - offset)) / itemsPerRow;
    return CGSizeMake(itemSide, itemSide);
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.currentSelectedCell = (PicsiesCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if (self.PopupView) {
        UIView *fbbutton = self.PopupView.superview.subviews[2];
        [fbbutton removeFromSuperview];
        [self.PopupView removeFromSuperview];
    }
    UIView *popUpView = [[UIView alloc]initWithFrame:self.currentSelectedCell.bounds];
    self.PopupView = popUpView;
    popUpView.backgroundColor = [UIColor whiteColor];
    popUpView.alpha = .7;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closePopup:)];
    [popUpView addGestureRecognizer:tapGesture];
    
    [self.currentSelectedCell addSubview:popUpView];
    CGFloat buttonWidth = 50;
    UIButton *button = [FBSDKMessengerShareButton circularButtonWithStyle:FBSDKMessengerShareButtonStyleBlue
                                                                    width:buttonWidth];
    self.fbbutton = button;
    [button addTarget:self action:@selector(shareButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    button.center = CGPointMake(CGRectGetWidth(self.currentSelectedCell.frame) / 2.f, CGRectGetHeight(self.currentSelectedCell.frame) / 2.f);
    [self.currentSelectedCell addSubview:button];
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

@end
