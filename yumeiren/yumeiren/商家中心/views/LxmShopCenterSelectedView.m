//
//  LxmShopCenterSelectedView.m
//  yumeiren
//
//  Created by 李晓满 on 2019/7/28.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LxmShopCenterSelectedView.h"

@interface LxmShopCenterSelectedView () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *selectTabelview;//选择tableView

@end

@implementation LxmShopCenterSelectedView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.selectTabelview];
        [self addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)btnClick {
    [self dismiss];
}

- (UITableView *)selectTabelview {
    if (!_selectTabelview) {
        _selectTabelview = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        _selectTabelview.delegate = self;
        _selectTabelview.dataSource = self;
        _selectTabelview.separatorStyle = UITableViewCellSeparatorStyleNone;
        _selectTabelview.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    }
    return _selectTabelview;
}

- (void)setDataArr:(NSArray<NSString *> *)dataArr {
    _dataArr = dataArr;
    [_selectTabelview reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
        UIView * line = [[UIView alloc] init];
        line.backgroundColor = BGGrayColor;
        [cell addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.leading.trailing.equalTo(cell);
            make.height.equalTo(@0.5);
        }];
        UIImageView *iconImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
        iconImgView.image = [UIImage imageNamed:@"xuanze"];
        cell.accessoryView = iconImgView;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UIImageView *iconImgView = (UIImageView *)cell.accessoryView;
    iconImgView.hidden = self.currentIndex != indexPath.row;
    cell.textLabel.textColor = CharacterDarkColor;
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.text = _dataArr[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.currentIndex = indexPath.row;
    [self.selectTabelview reloadData];
    [self dismiss];
    if (self.didSelectedIndex) {
        self.didSelectedIndex(self.currentIndex);
    }
}

- (void)showAtView:(UIView *)view {
    self.frame = view.bounds;
    self.backgroundColor = UIColor.clearColor;
    CGFloat height = self.dataArr.count * 44;
    self.selectTabelview.frame = CGRectMake(0, -height, self.frame.size.width, height);
    
    [view addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.3];
        CGRect rect = self.selectTabelview.frame;
        rect.origin.y = 0;
        self.selectTabelview.frame =  rect;
    }];
}

- (void)dismiss {
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundColor = UIColor.clearColor;
        CGRect rect = self.selectTabelview.frame;
        rect.origin.y = -rect.size.height;
        self.selectTabelview.frame =  rect;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
@end
