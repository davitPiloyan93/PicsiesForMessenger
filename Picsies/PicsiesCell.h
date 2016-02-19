//
//  PicsiesCell.h
//  Picsies
//
//  Created by DavitPiloyan on 2/19/16.
//  Copyright © 2016 Picsies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PicsiesCell : UICollectionViewCell

- (void)setData:(NSURL *)imageURL;

- (UIImageView *)cellImageView;

@end
