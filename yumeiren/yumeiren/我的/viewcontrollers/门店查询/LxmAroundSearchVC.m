
//
//  LxmAroundSearchVC.m
//  yumeiren
//
//  Created by 李晓满 on 2019/10/30.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LxmAroundSearchVC.h"

@interface LxmAroundSearchVC ()<AMapSearchDelegate>

@property (nonatomic, strong) UIView *lineView;//

@property (nonatomic, strong) AMapSearchAPI *search;//高德地图搜索对象

@property (nonatomic, strong) NSMutableArray <AMapPOI *>*locations;//搜索结果数组

@end

@implementation LxmAroundSearchVC

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = BGGrayColor;
    }
    return _lineView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"附近地址";
    [self initSubviews];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.locations = [NSMutableArray array];
    self.search = [[AMapSearchAPI alloc] init];
    self.search.delegate = self;
    AMapPOIAroundSearchRequest *request = [[AMapPOIAroundSearchRequest alloc] init];
    request.location            = self.location;
    request.keywords            = self.keywords;
    /* 按照距离排序. */
    request.sortrule            = 0;
    request.requireExtension    = YES;
    [self.search AMapPOIAroundSearch:request];
}

/**
 初始化子视图
 */
- (void)initSubviews {
    [self.view addSubview:self.lineView];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self.view);
        make.height.equalTo(@1);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView.mas_bottom);
        make.leading.bottom.trailing.equalTo(self.view);
    }];
}


/* POI 搜索回调. */
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response {
    [SVProgressHUD dismiss];
    if (response.pois.count == 0) {
        [self.locations removeAllObjects];
        return;
    }
    [self.locations removeAllObjects];
    [self.locations addObjectsFromArray:response.pois];
    [self.tableView reloadData];
    //解析response获取POI信息，具体解析见 Demo
    NSLog(@"%@",self.locations);
    for (AMapPOI *poi  in self.locations) {
        NSLog(@"%@--lng: %lf--lat: %lf",poi.name,poi.location.longitude,poi.location.latitude);
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.locations.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
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
    }
    cell.textLabel.textColor = CharacterDarkColor;
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.imageView.image = [UIImage imageNamed:@"md_local"];
    AMapPOI *poi = self.locations[indexPath.row];
    NSString *str = [NSString stringWithFormat:@"%@%@%@%@",poi.province,poi.city,poi.district,poi.address];
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:str];
    [att setColor:[UIColor colorWithRed:255/255.0 green:211/255.0 blue:206/255.0 alpha:1] forSubText:self.keywords];
    cell.textLabel.attributedText = att;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    AMapPOI *poi = self.locations[indexPath.row];
    NSString *str = [NSString stringWithFormat:@"%@%@%@%@",poi.province,poi.city,poi.district,poi.address];
    if (self.didselectBlock) {
        self.didselectBlock(poi, str);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

@end
