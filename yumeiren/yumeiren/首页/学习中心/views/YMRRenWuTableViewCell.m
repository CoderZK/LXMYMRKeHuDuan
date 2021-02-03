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
@end

@implementation YMRRenWuTableViewCell

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
        
        
    }
    return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 70;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YMRRenWuTwoCell * cell =[tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    
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
