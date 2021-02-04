//
//  YMRRenWuTableViewCell.m
//  yumeiren
//
//  Created by zk on 2021/2/3.
//  Copyright © 2021 李晓满. All rights reserved.
//

#import "YMRRenWuTableViewCell.h"
#import "YMRRenWuTwoCell.h"

@interface YMRRenWuTableViewCell()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *TV;
@property (nonatomic, strong) LxmEmptyView *emptyView;//空界面


@end

@implementation YMRRenWuTableViewCell

- (LxmEmptyView *)emptyView {
    if (!_emptyView) {
        _emptyView = [[LxmEmptyView alloc] init];
        _emptyView.textLabel.text = @"您当前没有数据";
        _emptyView.imgView.image = [UIImage imageNamed:@"weikong"];
        _emptyView.hidden = YES;
    }
    return _emptyView;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
 
        UIView * view = [[UIView alloc] init];
        [self.contentView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(15);
            make.right.equalTo(self.contentView).offset(-15);
            make.top.equalTo(self.contentView).offset(5);
            make.bottom.equalTo(self.contentView).offset(-5);
        }];
        view.backgroundColor = [UIColor whiteColor];
        view.layer.shadowColor = [UIColor blackColor].CGColor;
            // 设置阴影偏移量
        view.layer.shadowOffset = CGSizeMake(0,0);
            // 设置阴影透明度
        view.layer.shadowOpacity = 0.08;
            // 设置阴影半径
        view.layer.shadowRadius = 10;
        view.layer.cornerRadius = 10;
        
        
        self.TV = [[UITableView alloc] init];
        self.TV.backgroundColor = [UIColor clearColor];
        self.TV.layer.cornerRadius = 10;
        self.TV.clipsToBounds = YES;
       
        
        self.contentView.backgroundColor = self.backgroundColor = [UIColor clearColor];
        
        self.TV.delegate = self;
        self.TV.dataSource = self;
        self.TV.scrollEnabled = NO;
        [self.contentView addSubview:self.TV];
        [self.TV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(15);
            make.right.equalTo(self.contentView).offset(-15);
            make.top.equalTo(self.contentView).offset(5);
            make.bottom.equalTo(self.contentView).offset(-5);
        }];
       
        [self.TV registerNib:[UINib nibWithNibName:@"YMRRenWuTwoCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
        self.TV.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        [self.contentView addSubview:self.emptyView];
        [self.emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.equalTo(self.contentView);
        }];
        
        
    }
    return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 70;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YMRRenWuTwoCell * cell =[tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.model = self.dataArr[indexPath.row];
    
    if (indexPath.row <3) {
        [cell.numberBt setImage:[UIImage imageNamed:[NSString stringWithFormat:@"dnegji%ld",indexPath.row]] forState:UIControlStateNormal];
        [cell.numberBt setTitle:@"" forState:UIControlStateNormal];
        cell.imageV.image = [UIImage imageNamed:[NSString stringWithFormat:@"left%ld",indexPath.row]];
    }else {
        [cell.numberBt setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        cell.imageV.image = [UIImage imageNamed:@""];
        [cell.numberBt setTitle:[NSString stringWithFormat:@"%ld",indexPath.row +1] forState:UIControlStateNormal];
    }
    
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    
}

- (void)setDataArr:(NSArray<YMRXueXiModel *> *)dataArr {
    _dataArr = dataArr;
    if (self.dataArr.count == 0) {
        self.emptyView.hidden = NO;
    }else {
        self.emptyView.hidden = YES;
    }
    [self.TV reloadData];
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
