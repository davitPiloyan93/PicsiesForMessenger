//
//  PicsiesCell.m
//  Picsies
//
//  Created by DavitPiloyan on 2/19/16.
//  Copyright © 2016 Picsies. All rights reserved.
//

#import "PicsiesCell.h"
#import "UIImageView+WebCache.h"

@interface PicsiesCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation PicsiesCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setData:(NSURL *)imageURL {
    [self.imageView sd_setImageWithURL:imageURL];
}

- (UIImageView *)cellImageView {
    return self.imageView;
}

@end
