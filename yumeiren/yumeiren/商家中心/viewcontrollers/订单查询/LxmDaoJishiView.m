//
//  LxmDaoJishiView.m
//  yumeiren
//
//  Created by 李晓满 on 2019/11/4.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LxmDaoJishiView.h"

@implementation LxmDaoJishiView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.layer.masksToBounds = YES;
        self.clipsToBounds = YES;
        [self addSubview:self.daojishiLabel];
        [self.daojishiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self).offset(15);
            make.trailing.equalTo(self).offset(-15);
            make.center.equalTo(self);
        }];
    }
    return self;
}

- (UILabel *)daojishiLabel {
    if (!_daojishiLabel) {
        _daojishiLabel = [UILabel new];
        _daojishiLabel.textColor = CharacterDarkColor;
        _daojishiLabel.numberOfLines = 0;
        _daojishiLabel.font = [UIFont systemFontOfSize:14];
    }
    return _daojishiLabel;
}

@end
