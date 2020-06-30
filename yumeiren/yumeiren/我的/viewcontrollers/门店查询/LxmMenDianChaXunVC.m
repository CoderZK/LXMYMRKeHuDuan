//
//  LxmMenDianChaXunVC.m
//  yumeiren
//
//  Created by 李晓满 on 2019/9/6.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LxmMenDianChaXunVC.h"
#import "LxmPanButton.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import "LxmAroundSearchVC.h"

@interface LxmMenDianChaXunVC ()<MAMapViewDelegate,AMapLocationManagerDelegate,UITextFieldDelegate,AMapSearchDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIView *lineView;//

@property (nonatomic, strong) UIView *headerView;

@property (nonatomic, strong) LxmPanButton *addBtn;

@property (nonatomic, strong) LxmMenDianChaXunView *nameView;

@property (nonatomic, strong) LxmMenDianChaXunView *addressView;

@property (nonatomic, strong) UIButton *searchButton;//搜索按钮

@property (nonatomic, strong) MAMapView *mapView;

@property (nonatomic, strong) AMapLocationManager *locationManager;//当前定位对象

@property (nonatomic, strong) UIView *chaXunView;

@property (nonatomic, strong) UITableView *chaXunTableView;

@property (nonatomic, strong) NSMutableArray <LxmMenDianChaXunListModel *>*dataArr;

@property (nonatomic, strong) AMapSearchAPI *search;//高德地图搜索对象

@property (nonatomic, strong) AMapPOIKeywordsSearchRequest *request;//高德地图关键字搜索请求对象

@property (nonatomic, strong) NSString * keywords;//搜索关键字

@property (nonatomic, strong) NSMutableArray <AMapPOI *>*locations;//搜索结果数组

@property (nonatomic, strong) UIImageView *locationImageView;

@property (nonatomic, strong) AMapPOI *currentPoi;//当前点

@end

@implementation LxmMenDianChaXunVC

- (UIImageView *)locationImageView {
    if (!_locationImageView) {
        _locationImageView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenW * 0.5 - 15, 203 + 130 - 15, 30, 30)];
        _locationImageView.image = [UIImage imageNamed:@"currentlocal"];
    }
    return _locationImageView;
}

- (MAMapView *)mapView {
    if (!_mapView) {
        _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(15, 203, ScreenW - 30, 260)];
        _mapView.showsCompass = NO;
        _mapView.mapType = MAMapTypeStandard;
        _mapView.showsScale = NO;
        _mapView.delegate = self;
        _mapView.zoomLevel = 14.1;
        _mapView.layer.cornerRadius = 5;
        _mapView.layer.masksToBounds = YES;
        _mapView.userInteractionEnabled = NO;
    }
    return _mapView;
}

- (UIView *)chaXunView {
    if (!_chaXunView) {
        _chaXunView = [[UIView alloc] initWithFrame:CGRectMake(20, 203 + 5, ScreenW - 40, self.view.bounds.size.height - 230 - StateBarH - 44 - 10)];
        _chaXunView.backgroundColor = UIColor.whiteColor;
        _chaXunView.layer.shadowColor = [CharacterDarkColor colorWithAlphaComponent:0.4].CGColor;
        _chaXunView.layer.shadowRadius = 5;
        _chaXunView.layer.shadowOpacity = 0.5;
        _chaXunView.layer.shadowOffset = CGSizeMake(0, 0);
        _chaXunView.hidden = YES;
    }
    return _chaXunView;
}

- (UITableView *)chaXunTableView {
    if (!_chaXunTableView) {
        _chaXunTableView = [[UITableView alloc] initWithFrame:CGRectMake(15, 203, ScreenW - 30, self.view.bounds.size.height - 230 - StateBarH - 44) style:UITableViewStylePlain];
        _chaXunTableView.delegate = self;
        _chaXunTableView.dataSource = self;
        _chaXunTableView.separatorColor = BGGrayColor;
        _chaXunTableView.backgroundColor = [UIColor whiteColor];
        _chaXunTableView.layer.cornerRadius = 5;
        _chaXunTableView.layer.masksToBounds = YES;
        _chaXunTableView.hidden = YES;
    }
    return _chaXunTableView;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = BGGrayColor;
    }
    return _lineView;
}

- (UIView *)headerView {
    if (!_headerView) {//203 + 260
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 203 + 260)];
        _headerView.backgroundColor = [UIColor whiteColor];
    }
    return _headerView;
}


- (LxmMenDianChaXunView *)nameView {
    if (!_nameView) {
        _nameView = [[LxmMenDianChaXunView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 94)];
        _nameView.titleLabel.text = @"门店名称";
        _nameView.putinTF.placeholder = @"请输入门店名称";
        _nameView.rightButton.hidden = YES;
    }
    return _nameView;
}

- (LxmMenDianChaXunView *)addressView {
    if (!_addressView) {
        _addressView = [[LxmMenDianChaXunView alloc] initWithFrame:CGRectMake(0, 94, ScreenW - 80, 94)];
        _addressView.layer.cornerRadius = 5;
        _addressView.layer.masksToBounds = YES;
        _addressView.titleLabel.text = @"门店地址";
        _addressView.putinTF.placeholder = @"请输入门店地址";
        _addressView.putinTF.delegate = self;
        _addressView.putinTF.returnKeyType = UIReturnKeySearch;
        [_addressView.rightButton addTarget:self action:@selector(clearClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addressView;
}


- (UIButton *)searchButton {
    if (!_searchButton) {
        _searchButton = [[UIButton alloc] initWithFrame:CGRectMake(ScreenW - 80, 94+52, 65, 40)];
        [_searchButton setBackgroundImage:[UIImage imageNamed:@"pink"] forState:UIControlStateNormal];
        [_searchButton setTitle:@"搜索" forState:UIControlStateNormal];
        [_searchButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _searchButton.titleLabel.font = [UIFont systemFontOfSize:14];
        _searchButton.layer.cornerRadius = 8;
        _searchButton.layer.masksToBounds = YES;
        [_searchButton addTarget:self action:@selector(searchClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _searchButton;
}


- (void)addPublishBtn {
    self.addBtn = [LxmPanButton new];
    self.addBtn.iconImgView.image = [UIImage imageNamed:@"jiancha"];
    [self.view addSubview:self.addBtn];
    [self.addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.view).offset(-20);
        make.bottom.equalTo(self.view).offset(-100);
        make.width.height.equalTo(@60);
    }];
    WeakObj(self);
    self.addBtn.panBlock = ^{
        if (selfWeak.currentPoi) {
            [selfWeak searchShop];
        } else {
            [SVProgressHUD showErrorWithStatus:@"请输入门店地址!"];
            return ;
        }
        
    };
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"门店查询";
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.locations = [NSMutableArray array];
    
    self.tableView.tableHeaderView = self.headerView;
    [self initSubviews];
    [self addPublishBtn];
    [self initAMapLocation];
    
    self.dataArr = [NSMutableArray array];
    
    self.search = [[AMapSearchAPI alloc] init];
    self.search.delegate = self;
    self.request = [[AMapPOIKeywordsSearchRequest alloc] init];
    self.request.requireExtension    = YES;
    /*  搜索SDK 3.2.0 中新增加的功能，只搜索本城市的POI。*/
    self.request.cityLimit           = YES;
    self.request.requireSubPOIs      = YES;
}

/**
 初始化定位
 */
- (void)initAMapLocation {
    self.locationManager = [[AMapLocationManager alloc] init];
    [self.locationManager setDelegate:self];
    [self.locationManager setPausesLocationUpdatesAutomatically:NO];
    //开始定位
    [self.locationManager startUpdatingLocation];
}

/**
 获取焦点
 */
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    _chaXunView.hidden = NO;
    _chaXunTableView.hidden = NO;
    _mapView.hidden = YES;
    _locationImageView.hidden = YES;
    self.addBtn.hidden = YES;
    [self.dataArr removeAllObjects];
    [self.tableView reloadData];
    self.headerView.frame = CGRectMake(0, 0, ScreenW, self.view.bounds.size.height - 1);
}

/**
 边输入边搜索
 */
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (string.isValid) {
        if (textField.text.isValid) {
           self.request.keywords = [textField.text stringByAppendingString:string];
        } else {
            self.request.keywords = string;
        }
        [self.search AMapPOIKeywordsSearch:self.request];
    }
    return YES;
}

/**
 搜索
 */
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.headerView endEditing:YES];
    _chaXunView.hidden = YES;
    _chaXunTableView.hidden = YES;
    _mapView.hidden = NO;
    _locationImageView.hidden = NO;
    self.addBtn.hidden = NO;
    [self.chaXunTableView reloadData];
    self.headerView.frame = CGRectMake(0, 0, ScreenW, 203 + 260);
   
    if (!textField.text.isValid) {
        [SVProgressHUD showErrorWithStatus:@"请输入搜索内容!"];
        return NO;
    }
    self.request.keywords            = textField.text;
    [self.search AMapPOIKeywordsSearch:self.request];
    
    return YES;
}

- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location {
    //定位结果
    NSLog(@"location:{lat:%f; lon:%f; accuracy:%f}", location.coordinate.latitude, location.coordinate.longitude, location.horizontalAccuracy);
    self.mapView.centerCoordinate = location.coordinate;
    [self.locationManager stopUpdatingLocation];
}

/**
 * @brief 根据anntation生成对应的View
 * @param mapView 地图View
 * @param annotation 指定的标注
 * @return 生成的标注View
 */
- (MAAnnotationView*)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation {
    if ([annotation isKindOfClass:[MAPointAnnotation class]]) {
        static NSString *reuseIndetifier = @"annotationReuseIndetifier";
        MAAnnotationView *annotationView = (MAAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifier];
        if (annotationView == nil) {
            annotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseIndetifier];
        }
        annotationView.image = [UIImage imageNamed:@"fjdd"];
        //设置中心点偏移，使得标注底部中间点成为经纬度对应点
        annotationView.centerOffset = CGPointMake(0, -18);
        return annotationView;
    }
    return nil;
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
    [self.headerView addSubview:self.nameView];
    [self.headerView addSubview:self.addressView];
    [self.headerView addSubview:self.searchButton];
    [self.headerView addSubview:self.mapView];
    [self.headerView addSubview:self.chaXunView];
    [self.headerView addSubview:self.chaXunTableView];
    [self.headerView addSubview:self.locationImageView];
}

/* POI 搜索回调. */
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response {
    [SVProgressHUD dismiss];
    if (response.pois.count == 0) {
        [self.locations removeAllObjects];
        [self.chaXunTableView reloadData];
        return;
    }
    [self.locations removeAllObjects];
    [self.locations addObjectsFromArray:response.pois];
    [self.chaXunTableView reloadData];
    //解析response获取POI信息，具体解析见 Demo
    NSLog(@"%@",self.locations);
    for (AMapPOI *poi  in self.locations) {
        NSLog(@"%@--lng: %lf--lat: %lf",poi.name,poi.location.longitude,poi.location.latitude);
    }
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.chaXunTableView) {
        return self.locations.count;
    }
    return self.dataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.chaXunTableView) {
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
        }
        cell.textLabel.textColor = CharacterDarkColor;
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.imageView.image = [UIImage imageNamed:@"md_local"];
        AMapPOI *poi = self.locations[indexPath.row];
        NSString *str = [NSString stringWithFormat:@"%@%@%@%@",poi.province,poi.city,poi.district,poi.address];
        NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:str];
        [att setColor:[UIColor colorWithRed:255/255.0 green:211/255.0 blue:206/255.0 alpha:1] forSubText:self.request.keywords];
        cell.textLabel.attributedText = att;
        return cell;
    }
    LxmMenDianChaXunCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LxmMenDianChaXunCell"];
    if (!cell) {
        cell = [[LxmMenDianChaXunCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmMenDianChaXunCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.dataArr[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.chaXunTableView) {
        return 60;
    } else {
        if (self.dataArr.count == 0) {
            return 0.01;
        }
        return self.dataArr[indexPath.row].cellH;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.chaXunTableView) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        [self.headerView endEditing:YES];
        _chaXunView.hidden = YES;
        _chaXunTableView.hidden = YES;
        _mapView.hidden = NO;
        _locationImageView.hidden = NO;
        self.addBtn.hidden = NO;
        self.headerView.frame = CGRectMake(0, 0, ScreenW, 203 + 260);
        
        AMapPOI *poi = self.locations[indexPath.row];
        NSString *str = [NSString stringWithFormat:@"%@%@%@%@",poi.province,poi.city,poi.district,poi.address];
        self.addressView.putinTF.text = str;
        self.currentPoi = poi;
        self.mapView.centerCoordinate = CLLocationCoordinate2DMake(poi.location.latitude, poi.location.longitude);
    }
}

/**
 清空输入
 */
- (void)clearClick {
    self.addressView.putinTF.text = nil;
    self.request.keywords = nil;
    [self.locations removeAllObjects];
    [self.chaXunTableView reloadData];
}

/**
 搜索店铺
 */
- (void)searchShop {
    NSString *name = self.nameView.putinTF.text;
    NSString *address = self.addressView.putinTF.text;
    if (!name.isValid) {
        [SVProgressHUD showErrorWithStatus:@"请输入门店名称!"];
        return;
    }
    if (name.length > 20) {
        [SVProgressHUD showErrorWithStatus:@"门店名称长度在1~20个字符!"];
        return;
    }
    if (!address.isValid) {
        [SVProgressHUD showErrorWithStatus:@"请输入门店地址!"];
        return;
    }
    
    MACoordinateRegion region = _mapView.region;
//    CLLocationCoordinate2D left = CLLocationCoordinate2DMake(region.center.latitude - region.span.latitudeDelta * 0.5, region.center.longitude  - region.span.longitudeDelta * 0.5);
//    CLLocationCoordinate2D right = CLLocationCoordinate2DMake(region.center.latitude + region.span.latitudeDelta * 0.5, region.center.longitude  + region.span.longitudeDelta * 0.5);
//    NSLog(@"--1-%lf--1-%lf--2-%lf-2-%lf",left.latitude,left.longitude,right.latitude,right.longitude);
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"token"] = SESSION_TOKEN;
    dict[@"city"] = self.currentPoi.city;
    dict[@"longitude"] = [NSString stringWithFormat:@"%.6f",region.center.longitude];
    dict[@"latitude"] = [NSString stringWithFormat:@"%.6f",region.center.latitude];
//    dict[@"begin_longitude"] = [NSString stringWithFormat:@"%.6f",left.longitude];
//    dict[@"begin_latitude"] = [NSString stringWithFormat:@"%.6f",left.latitude];
//    dict[@"end_longitude"] = [NSString stringWithFormat:@"%.6f",right.longitude];
//    dict[@"end_latitude"] = [NSString stringWithFormat:@"%.6f",right.latitude];
    dict[@"shop_name"] = name;
    dict[@"address_detail"] = address;
    [SVProgressHUD show];
    [LxmNetworking networkingPOST:select_store parameters:dict returnClass:LxmMenDianChaXunRootModel.class success:^(NSURLSessionDataTask *task, LxmMenDianChaXunRootModel *responseObject) {
        [SVProgressHUD dismiss];
        if (responseObject.key.integerValue == 1000) {
            [self.dataArr removeAllObjects];
            [self.dataArr addObjectsFromArray:responseObject.result.list];
            NSMutableArray *tempArr = [NSMutableArray array];
            for (LxmMenDianChaXunListModel *m in self.dataArr) {
                MAPointAnnotation *point = [MAPointAnnotation new];
                point.coordinate = CLLocationCoordinate2DMake(m.latitude.doubleValue, m.longitude.doubleValue);
                [tempArr addObject:point];
            }
            [_mapView addAnnotations:tempArr];
            [self.tableView reloadData];
        } else {
            [UIAlertController showAlertWithmessage:responseObject.message];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
    }];
}

/// 点击搜索
- (void)searchClick {
    NSString *name = self.nameView.putinTF.text;
    NSString *address = self.addressView.putinTF.text;
    if (!name.isValid) {
        [SVProgressHUD showErrorWithStatus:@"请输入门店名称!"];
        return;
    }
    if (name.length > 20) {
        [SVProgressHUD showErrorWithStatus:@"门店名称长度在1~20个字符!"];
        return;
    }
    if (!address.isValid) {
        [SVProgressHUD showErrorWithStatus:@"请输入门店地址!"];
        return;
    }
    
    AMapGeocodeSearchRequest *geo = [[AMapGeocodeSearchRequest alloc] init];
    geo.address = address;
    [self.search AMapGeocodeSearch:geo];
}

- (void)onGeocodeSearchDone:(AMapGeocodeSearchRequest *)request response:(AMapGeocodeSearchResponse *)response {
    if (response.geocodes.count == 0) {
        [SVProgressHUD showErrorWithStatus:@"无搜索结果,请输入详细的地址!"];
        return;
    } else {
        LxmAroundSearchVC *aroundSearchVC = [[LxmAroundSearchVC alloc] init];
        aroundSearchVC.keywords = self.addressView.putinTF.text;
        aroundSearchVC.location = response.geocodes[0].location;
        aroundSearchVC.didselectBlock = ^(AMapPOI * _Nonnull poi, NSString * _Nonnull address) {
            _chaXunView.hidden = YES;
            _chaXunTableView.hidden = YES;
            _mapView.hidden = NO;
            _locationImageView.hidden = NO;
            self.addBtn.hidden = NO;
            self.headerView.frame = CGRectMake(0, 0, ScreenW, 203 + 260);
            
            self.addressView.putinTF.text = address;
            self.currentPoi = poi;
            self.mapView.centerCoordinate = CLLocationCoordinate2DMake(poi.location.latitude, poi.location.longitude);
        };
        [self.navigationController pushViewController:aroundSearchVC animated:YES];
    }
}

@end

@interface LxmMenDianChaXunView()

@end

@implementation LxmMenDianChaXunView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubviews];
        [self setContrains];
    }
    return self;
}

/**
 添加视图
 */
- (void)initSubviews {
    [self addSubview:self.titleLabel];
    [self addSubview:self.putinView];
    [self.putinView addSubview:self.putinTF];
    [self.putinView addSubview:self.rightButton];
}

/**
 添加约束
 */
- (void)setContrains {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.equalTo(self).offset(15);
        make.height.equalTo(@20);
    }];
    [self.putinView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(15);
        make.leading.equalTo(self).offset(15);
        make.trailing.equalTo(self).offset(-15);
        make.height.equalTo(@44);
    }];
    [self.putinTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.putinView);
        make.leading.equalTo(self.putinView).offset(15);
        make.trailing.equalTo(self.rightButton.mas_leading);
    }];
    [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.putinView);
        make.centerY.equalTo(self.putinView);
        make.width.height.equalTo(@44);
    }];
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.textColor = CharacterDarkColor;
        _titleLabel.font = [UIFont systemFontOfSize:15];
    }
    return _titleLabel;
}

- (UIView *)putinView {
    if (!_putinView) {
        _putinView = [UIView new];
        _putinView.layer.cornerRadius = 5;
        _putinView.layer.borderColor = LineColor.CGColor;
        _putinView.layer.borderWidth = 0.5;
        _putinView.layer.masksToBounds = YES;
    }
    return _putinView;
}

- (UITextField *)putinTF {
    if (!_putinTF) {
        _putinTF = [UITextField new];
        _putinTF.textColor = CharacterDarkColor;
        _putinTF.font = [UIFont systemFontOfSize:15];
    }
    return _putinTF;
}

- (UIButton *)rightButton {
    if (!_rightButton) {
        _rightButton = [UIButton new];
        [_rightButton setImage:[UIImage imageNamed:@"md_delete"] forState:UIControlStateNormal];
        _rightButton.imageEdgeInsets = UIEdgeInsetsMake(7, 7, 7, 7);
    }
    return _rightButton;
}

@end

/**
 cell
 */
@interface LxmMenDianChaXunCell ()

@property (nonatomic, strong) UILabel *titleLabel;//标题

@property (nonatomic, strong) UILabel *distanceLabel;//距离

@property (nonatomic, strong) UIImageView *iconImgView;//位置图标

@property (nonatomic, strong) UILabel *detailLabel;//详细位置

@end
@implementation LxmMenDianChaXunCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initSubViews];
        [self setConstrains];
    }
    return self;
}

/**
 添加视图
 */
- (void)initSubViews {
    [self addSubview:self.titleLabel];
    [self addSubview:self.distanceLabel];
    [self addSubview:self.iconImgView];
    [self addSubview:self.detailLabel];
    [self addSubview:self.lineView];
}

/**
 添加约束
 */
- (void)setConstrains {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(25);
        make.leading.equalTo(self).offset(15);
        make.trailing.equalTo(self).offset(-15);
    }];
    [self.distanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(15);
        make.leading.equalTo(self).offset(15);
        make.trailing.equalTo(self).offset(-15);
    }];
    [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.distanceLabel.mas_bottom).offset(15);
        make.leading.equalTo(self).offset(15);
        make.width.height.equalTo(@20);
    }];
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.iconImgView);
        make.leading.equalTo(self.iconImgView.mas_trailing).offset(10);
        make.trailing.equalTo(self).offset(-15);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(15);
        make.trailing.equalTo(self).offset(-15);
        make.bottom.equalTo(self);
        make.height.equalTo(@1);
    }];
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.textColor = UIColor.blackColor;
        _titleLabel.font = [UIFont boldSystemFontOfSize:16];
        _titleLabel.text = @"李老师美容美发会所";
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}

- (UILabel *)distanceLabel {
    if (!_distanceLabel) {
        _distanceLabel = [UILabel new];
        _distanceLabel.textColor = CharacterDarkColor;
        _distanceLabel.font = [UIFont systemFontOfSize:14];
        _distanceLabel.text = @"817m";
    }
    return _distanceLabel;
}

- (UIImageView *)iconImgView {
    if (!_iconImgView) {
        _iconImgView = [UIImageView new];
        _iconImgView.image = [UIImage imageNamed:@"local"];
    }
    return _iconImgView;
}

- (UILabel *)detailLabel {
    if (!_detailLabel) {
        _detailLabel = [UILabel new];
        _detailLabel.textColor = CharacterDarkColor;
        _detailLabel.font = [UIFont systemFontOfSize:12];
        _detailLabel.numberOfLines = 0;
    }
    return _detailLabel;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = BGGrayColor;
    }
    return _lineView;
}

- (void)setModel:(LxmMenDianChaXunListModel *)model {
    _model = model;
    _titleLabel.text = _model.show_name;
    _distanceLabel.text = [NSString stringWithFormat:@"%ldm",_model.distance.integerValue];
    _detailLabel.text = [NSString stringWithFormat:@"%@%@%@%@",_model.province,_model.city,_model.district,_model.address_detail];
}

@end
