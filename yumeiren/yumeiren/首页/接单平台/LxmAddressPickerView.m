//
//  LxmAddressPickerView.m
//  yumeiren
//
//  Created by 李晓满 on 2019/8/29.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LxmAddressPickerView.h"
#import "LxmJieDanPublishAlertView.h"

@interface LxmAddressPickerView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)  UIView *contentView;

@property (nonatomic, strong) UIView *topView;

@property (nonatomic, strong) UITableView *tableView1;

@property (nonatomic, strong) UITableView *tableView2;

@property (nonatomic, strong) UITableView *tableView3;

@property (nonatomic, strong) NSString *province;//省

@property (nonatomic, strong) NSString *city;//市

@property (nonatomic, strong) NSString *area;//区

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) NSMutableArray <NSString *>*provinceArr;//省

@property (nonatomic, strong) NSMutableArray <NSString *>*cityArr;//市

@property (nonatomic, strong) NSMutableArray <NSString *>*areaArr;//区

@end


@implementation LxmAddressPickerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIButton * bgBtn =[[UIButton alloc] initWithFrame:self.bounds];
        [bgBtn addTarget:self action:@selector(bgBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        bgBtn.tag = 110;
        [self addSubview:bgBtn];
        
        self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height - 300 - TableViewBottomSpace, frame.size.width, 300 + TableViewBottomSpace)];
        self.contentView.backgroundColor=[UIColor whiteColor];
        [self addSubview:self.contentView];
        
        UIView * accView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 39.5)];
        accView.backgroundColor = [UIColor whiteColor];
        [_contentView addSubview:accView];
        
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, frame.size.width - 120, 40)];
        self.titleLabel.text = @"请选择省";
        self.titleLabel.textColor = MainColor;
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [accView addSubview:self.titleLabel];
        
        
        UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 39.5, ScreenW, 0.5)];
        lineView.backgroundColor = BGGrayColor;
        [accView addSubview:lineView];
        
        self.tableView1 = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, _contentView.bounds.size.width, _contentView.bounds.size.height - 40 - TableViewBottomSpace)];
        self.tableView1.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView1.delegate = self;
        self.tableView1.dataSource = self;
        self.tableView1.hidden = NO;
        [_contentView addSubview:self.tableView1];
        
        self.tableView2 = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, _contentView.bounds.size.width, _contentView.bounds.size.height - 40 - TableViewBottomSpace)];
        self.tableView2.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView2.delegate = self;
        self.tableView2.dataSource = self;
        self.tableView2.hidden = YES;
        [_contentView addSubview:self.tableView2];
        
        self.tableView3 = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, _contentView.bounds.size.width, _contentView.bounds.size.height - 40 - TableViewBottomSpace)];
        self.tableView3.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView3.delegate = self;
        self.tableView3.dataSource = self;
        self.tableView3.hidden = YES;
        [_contentView addSubview:self.tableView3];
        
        self.provinceArr = [NSMutableArray array];
        self.cityArr = [NSMutableArray array];
        self.areaArr = [NSMutableArray array];
        
        
    }
    return self;
}

-(void)bgBtnClick:(UIButton *)btn {
    if (btn.tag == 110) {
        [self hide];
    } else if(btn.tag == 111) {
        if ([self.delegate respondsToSelector:@selector(cancelBtnClick)]) {
            [self.delegate cancelBtnClick];
        }
    } else {
        if (self.province.isValid && self.city.isValid && self.area.isValid) {
            if ([self.delegate respondsToSelector:@selector(sureBtnClickReturnProvince:City:Area:)]) {
                [self.delegate sureBtnClickReturnProvince:self.province City:self.city Area:self.area];
            }
        } else {
            [SVProgressHUD showErrorWithStatus:@"请选择省市区"];
        }
    }
}

- (void)show {
    UIWindow * window = [UIApplication sharedApplication].delegate.window;
    [window addSubview:self];
    [window bringSubviewToFront:self];
    
    self.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.0];
    CGRect rect = _contentView.frame;
    rect.origin.y = self.bounds.size.height;
    _contentView.frame = rect;
    [self.provinceArr removeAllObjects];
    [self.cityArr removeAllObjects];
    [self.areaArr removeAllObjects];
    self.province = nil;
    self.city = nil;
    self.area = nil;
    [self loadProvince];
    WeakObj(self);
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        self.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.3];
        CGRect rect = selfWeak.contentView.frame;
        rect.origin.y = selfWeak.bounds.size.height - selfWeak.contentView.frame.size.height;
        selfWeak.contentView.frame = rect;
        
    } completion:nil];
}

-(void)hide {
    WeakObj(self);
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.0];
        CGRect rect = selfWeak.contentView.frame;
        rect.origin.y = self.bounds.size.height;
        selfWeak.contentView.frame = rect;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


#pragma mark - UITableviewDatasource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.provinceArr.count > 0) {
        return self.provinceArr.count;
    }
    if (self.cityArr.count > 0) {
        return self.cityArr.count;
    }
    if (self.areaArr.count > 0) {
        return self.areaArr.count;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LxmJieDanPublishCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LxmJieDanPublishCell"];
    if (!cell) {
        cell = [[LxmJieDanPublishCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmJieDanPublishCell"];
    }
    if (self.provinceArr.count > 0) {
        cell.titleLabel.text = [NSString stringWithFormat:@"%@",self.provinceArr[indexPath.row]];
    }
    if (self.cityArr.count > 0) {
        cell.titleLabel.text = [NSString stringWithFormat:@"%@",self.cityArr[indexPath.row]];
    }
    if (self.areaArr.count > 0) {
        cell.titleLabel.text = [NSString stringWithFormat:@"%@",self.areaArr[indexPath.row]];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView == _tableView1) {
        if (!self.province.isValid) {
            self.province = [NSString stringWithFormat:@"%@",self.provinceArr[indexPath.row]];
            [self loadCityData:self.province okBlock:nil];
        }
    } else if (tableView == _tableView2) {
        if (!self.city.isValid && self.cityArr.count > 0) {
            self.city = [NSString stringWithFormat:@"%@",self.cityArr[indexPath.row]];
            [self loadAreaData:self.city okBlock:nil];
        }
    } else {
        if (!self.area.isValid && self.areaArr.count > 0) {
            self.area = [NSString stringWithFormat:@"%@",self.areaArr[indexPath.row]];
            if ([self.delegate respondsToSelector:@selector(sureBtnClickReturnProvince:City:Area:)]) {
                [self.delegate sureBtnClickReturnProvince:self.province City:self.city Area:self.area];
            }
        }
    }
}

/**
 获取省列表
 */
- (void)loadProvince {
    [SVProgressHUD show];
    [LxmNetworking networkingPOST:get_province parameters:@{@"token":SESSION_TOKEN} returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        if ([responseObject[@"key"] integerValue] == 1000) {
            [self.provinceArr removeAllObjects];
            NSArray *tempArr = responseObject[@"result"][@"list"];
            if ([tempArr isKindOfClass:NSArray.class] && tempArr.count > 0) {
                [self.provinceArr addObjectsFromArray:tempArr];
            }
            self.titleLabel.text = @"请选择省";
            self.tableView1.hidden = NO;
            self.tableView2.hidden = YES;
            self.tableView3.hidden = YES;
            [self.tableView1 reloadData];
        } else {
            [UIAlertController showAlertWithmessage:responseObject[@"message"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
    }];
}

/**
 获取市列表
 */
- (void)loadCityData:(NSString *)province okBlock:(void(^)(void))okBlock {
    [SVProgressHUD show];
    [LxmNetworking networkingPOST:get_city parameters:@{@"token":SESSION_TOKEN,@"province":province} returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        if ([responseObject[@"key"] integerValue] == 1000) {
            [self.cityArr removeAllObjects];
            [self.provinceArr removeAllObjects];
            NSArray *tempArr = responseObject[@"result"][@"list"];
            if ([tempArr isKindOfClass:NSArray.class] && tempArr.count > 0) {
                [self.cityArr addObjectsFromArray:tempArr];
            }
            self.titleLabel.text = @"请选择市";
            self.tableView1.hidden = YES;
            self.tableView2.hidden = NO;
            self.tableView3.hidden = YES;
            [self.tableView2 reloadData];
            if (okBlock) {
                okBlock();
            }
        } else {
            [UIAlertController showAlertWithmessage:responseObject[@"message"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
    }];
}

/**
 获取县列表
 */
- (void)loadAreaData:(NSString *)city okBlock:(void(^)(void))okBlock {
    [SVProgressHUD show];
    [LxmNetworking networkingPOST:get_district parameters:@{@"token":SESSION_TOKEN,@"city":city} returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        if ([responseObject[@"key"] integerValue] == 1000) {
            [self.cityArr removeAllObjects];
            [self.provinceArr removeAllObjects];
            [self.areaArr removeAllObjects];
            NSArray *tempArr = responseObject[@"result"][@"list"];
            if ([tempArr isKindOfClass:NSArray.class] && tempArr.count > 0) {
                [self.areaArr addObjectsFromArray:tempArr];
            }
            self.titleLabel.text = @"请选择区";
            self.tableView1.hidden = YES;
            self.tableView2.hidden = YES;
            self.tableView3.hidden = NO;
            [self.tableView3 reloadData];
            if (okBlock) {
                okBlock();
            }
        } else {
            [UIAlertController showAlertWithmessage:responseObject[@"message"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
    }];
}

@end
