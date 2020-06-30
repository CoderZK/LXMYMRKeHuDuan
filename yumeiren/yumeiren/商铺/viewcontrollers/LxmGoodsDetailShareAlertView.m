//
//  LxmGoodsDetailShareAlertView.m
//  yumeiren
//
//  Created by 李晓满 on 2019/7/23.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LxmGoodsDetailShareAlertView.h"

@implementation LxmShareButtonItem

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViews];
        [self setConstrains];
    }
    return self;
}

- (UIImageView *)itemImgView {
    if (!_itemImgView) {
        _itemImgView = [[UIImageView alloc] init];
    }
    return _itemImgView;
}

- (UILabel *)itemLabel {
    if (!_itemLabel) {
        _itemLabel = [[UILabel alloc] init];
        _itemLabel.textColor = CharacterDarkColor;
        _itemLabel.font = [UIFont systemFontOfSize:13];
    }
    return _itemLabel;
}

/**
 初始化子视图
 */
- (void)initSubViews {
    [self addSubview:self.itemImgView];
    [self addSubview:self.itemLabel];
}

/**
 添加约束
 */
- (void)setConstrains {
    [self.itemImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(20);
        make.centerX.equalTo(self);
        make.width.height.equalTo(@40);
    }];
    [self.itemLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.itemImgView.mas_bottom).offset(10);
        make.centerX.equalTo(self);
    }];
    [self layoutIfNeeded];
}

@end


@interface LxmGoodsDetailShareAlertView ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic, strong) UIButton *bgButton;//背景按钮

@property (nonatomic, strong) UIButton *finishButton;//完成

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) UIView *lineView1;

@end

@implementation LxmGoodsDetailShareAlertView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.bgButton = [[UIButton alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [self.bgButton addTarget:self action:@selector(bgButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.bgButton];
        [self addSubview:self.contentView];
        [self.contentView addSubview:self.collectionView];
        [self.contentView addSubview:self.bottomView];
        [self.bottomView addSubview:self.finishButton];
        [self.collectionView addSubview:self.lineView];
        [self.collectionView addSubview:self.lineView1];
        [self setConstrains];
    }
    return self;
}
/**
 初始化子视图
 */

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.itemSize = CGSizeMake(floor(ScreenW/4.0), 110);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        [_collectionView registerClass:LxmShareButtonItem.class forCellWithReuseIdentifier:@"LxmShareButtonItem"];
    }
    return _collectionView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 5;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LxmShareButtonItem *buttonItem = [collectionView dequeueReusableCellWithReuseIdentifier:@"LxmShareButtonItem" forIndexPath:indexPath];
    if (indexPath.item == 0) {
        buttonItem.itemImgView.image = [UIImage imageNamed:@"pyq"];
        buttonItem.itemLabel.text = @"微信朋友圈";
    } else if (indexPath.item == 1) {
        buttonItem.itemImgView.image = [UIImage imageNamed:@"wx"];
        buttonItem.itemLabel.text = @"微信好友";
    } else if (indexPath.item == 2) {
        buttonItem.itemImgView.image = [UIImage imageNamed:@"qqkj"];
        buttonItem.itemLabel.text = @"QQ空间";
    } else if (indexPath.item == 3) {
        buttonItem.itemImgView.image = [UIImage imageNamed:@"qqhy"];
        buttonItem.itemLabel.text = @"手机QQ";
    } else {
        buttonItem.itemImgView.image = [UIImage imageNamed:@"fzlj"];
        buttonItem.itemLabel.text = @"复制链接";
    }
    return buttonItem;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.didSelectShareItemBlock) {
        self.didSelectShareItemBlock(indexPath.item);
    }
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = LineColor;
    }
    return _lineView;
}

- (UIView *)lineView1 {
    if (!_lineView1) {
        _lineView1 = [UIView new];
        _lineView1.backgroundColor = LineColor;
    }
    return _lineView1;
}


- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenH, ScreenW, 270 + TableViewBottomSpace)];
        _contentView.backgroundColor = BGGrayColor;
    }
    return _contentView;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, - TableViewBottomSpace - 50, ScreenW, TableViewBottomSpace + 50)];
        _bottomView.backgroundColor = [UIColor whiteColor];
    }
    return _bottomView;
}

- (UIButton *)finishButton {
    if (!_finishButton) {
        _finishButton = [[UIButton alloc] init];
        [_finishButton setBackgroundImage:[UIImage imageNamed:@"tabbarwhite"] forState:UIControlStateNormal];
        [_finishButton setTitle:@"取消" forState:UIControlStateNormal];
        [_finishButton setTitleColor:CharacterDarkColor forState:UIControlStateNormal];
        _finishButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_finishButton addTarget:self action:@selector(bgButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _finishButton;
}

/**
 添加约束
 */
- (void)setConstrains {
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self.contentView);
        make.bottom.equalTo(self.bottomView.mas_top);
    }];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.bottom.trailing.equalTo(self.contentView);
        make.height.equalTo(@(TableViewBottomSpace + 50));
    }];
    [self.finishButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.trailing.equalTo(self.bottomView);
        make.height.equalTo(@50);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(109.5);
        make.leading.equalTo(self.contentView).offset(15);
        make.trailing.equalTo(self.contentView).offset(-15);
        make.height.equalTo(@1);
    }];
    [self.lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bottomView).offset(-1);
        make.leading.equalTo(self.contentView).offset(15);
        make.trailing.equalTo(self.contentView).offset(-15);
        make.height.equalTo(@1);
    }];
}

- (void)show {
    self.backgroundColor = UIColor.clearColor;
    [[UIApplication sharedApplication].delegate.window addSubview:self];
    _contentView.frame = CGRectMake(0, ScreenH, ScreenW, 270 + TableViewBottomSpace);
    [_contentView layoutIfNeeded];
    WeakObj(self);
    [UIView animateWithDuration:0.4 animations:^{
        selfWeak.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        self.contentView.frame = CGRectMake(0, ScreenH - (270 + TableViewBottomSpace), ScreenW, 270 + TableViewBottomSpace);
    } completion:^(BOOL finished) {
        
    }];
}

- (void)dismiss {
    WeakObj(self);
    self.bgButton.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundColor = UIColor.clearColor;
        self.contentView.frame = CGRectMake(0, ScreenH, ScreenW, 270 + TableViewBottomSpace);
    } completion:^(BOOL finished) {
        [selfWeak removeFromSuperview];
        self.bgButton.userInteractionEnabled = YES;
    }];
}

- (void)bgButtonClick {
    [self dismiss];
}


@end
