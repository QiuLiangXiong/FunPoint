//
//  UIImageView+QLXExt.m
//  fcuhConsumer
//
//  Created by 邱良雄 on 15/8/7.
//  Copyright (c) 2015年 avatar. All rights reserved.
//

#import "UIImageView+QLXExt.h"
#import "QLXExt.h"
@implementation UIImageView(QLXExt)

+ (instancetype)create{
    UIImageView * iv = [[self alloc] init];
    iv.contentMode = UIViewContentModeScaleAspectFill;
    iv.clipsToBounds = true;
    return iv;
}

+ (instancetype)createWithImageName:(NSString* ) name{
    return [self createWithImage:[UIImage imageNamed:name]];
}

+ (instancetype)createWithImage:(UIImage* ) image{
    UIImageView * iv = [self create];
    iv.image = image;
    return iv;
}



-(void)setScaleToFitWithImage:(UIImage *)image{
    if (self.bounds.size.width + self.bounds.size.height != 0) {
        [self setImage:[image scaleToSize:self.bounds.size]];
    }else {
        [self setImage:image];
    }
}

-(void) sizeToFitImage{
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.image.size);
    }];
}



@end
