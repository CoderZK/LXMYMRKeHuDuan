//
//  LxmDetailAddressVC.m
//  yumeiren
//
//  Created by 李晓满 on 2019/9/5.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LxmDetailAddressVC.h"
#import "LxmSearchView.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>

@interface LxmDetailAddressVC ()<AMapSearchDelegate,MAMapViewDelegate,UITextFieldDelegate,AMapLocationManagerDelegate>

@property (nonatomic, strong) LxmSearchPageView *serachView;//搜索栏

@property (nonatomic, strong) UIButton *searchButton;//搜索按钮

@property (nonatomic, strong) MAMapView *mapView;

@property (nonatomic, strong) AMapLocationManager *locationManager;//当前定位对象

@property (nonatomic, strong) AMapSearchAPI *search;//高德地图搜索对象

@property (nonatomic, strong) AMapPOIKeywordsSearchRequest *request;//高德地图关键字搜索请求对象

@property (nonatomic, strong) NSString * keywords;//搜索关键字

@property (nonatomic, strong) NSMutableArray <AMapPOI *>*locations;//搜索结果数组

@property (nonatomic, strong) UIImageView *locationImageView;

@end

@implementation LxmDetailAddressVC

- (UIImageView *)locationImageView {
    if (!_locationImageView) {
        _locationImageView = [[UIImageView alloc] init];
        _locationImageView.image = [UIImage imageNamed:@"currentlocal"];
    }
    return _locationImageView;
}

- (LxmSearchPageView *)serachView {
    if (!_serachView) {
        _serachView = [[LxmSearchPageView alloc] initWithFrame:CGRectMake(15, 15, ScreenW - 115, 30)];
        _serachView.searchTF.delegate = self;
    }
    return _serachView;
}

- (UIButton *)searchButton {
    if (!_searchButton) {
        _searchButton = [[UIButton alloc] initWithFrame:CGRectMake(ScreenW - 85, 15, 70, 30)];
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

- (MAMapView *)mapView {
    if (!_mapView) {
        _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 60, ScreenW, 260)];
        _mapView.showsCompass = NO;
        _mapView.mapType = MAMapTypeStandard;
        _mapView.showsScale = NO;
        _mapView.delegate = self;
        _mapView.zoomLevel = 14.1;
        _mapView.showsUserLocation = YES;
        _mapView.userTrackingMode = MAUserTrackingModeFollow;
    }
    return _mapView;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.serachView endEditing:YES];
    if (!textField.text.isValid) {
        [SVProgressHUD showErrorWithStatus:@"请输入搜索内容!"];
        return NO;
    }
    self.request.keywords            = textField.text;
    [self.search AMapPOIKeywordsSearch:self.request];
    return YES;
}

- (void)searchClick {
    [self.serachView endEditing:YES];
    if (!self.serachView.searchTF.text.isValid) {
        [SVProgressHUD showErrorWithStatus:@"请输入搜索内容!"];
        return;
    }
    self.request.keywords            = self.serachView.searchTF.text;
    [self.search AMapPOIKeywordsSearch:self.request];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"详情地址";
    self.locations = [NSMutableArray array];
    
    self.view.backgroundColor = UIColor.whiteColor;
    [AMapServices sharedServices].enableHTTPS = YES;
    [self.view addSubview:self.serachView];
    [self.view addSubview:self.searchButton];
    [self.view addSubview:self.mapView];
    [self.view addSubview:self.locationImageView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mapView.mas_bottom);
        make.leading.trailing.bottom.equalTo(self.view);
    }];
    [self.locationImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mapView);
        make.centerY.equalTo(self.mapView).offset(-18);
        make.width.height.equalTo(@36);
    }];
    //设置定位按钮
    UIButton *locationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    locationBtn.backgroundColor = [UIColor redColor];
    [locationBtn setImage:[UIImage imageNamed:@"icon_dw"] forState:UIControlStateNormal];
    locationBtn.backgroundColor = [UIColor whiteColor];
    [locationBtn addTarget:self action:@selector(locationClick) forControlEvents:UIControlEventTouchUpInside];
    locationBtn.layer.cornerRadius = 3;
    locationBtn.layer.masksToBounds = YES;
    [self.mapView addSubview:locationBtn];
    [locationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.mapView).offset(-15);
        make.bottom.equalTo(self.mapView).offset(-15);
        make.width.height.equalTo(@30);
    }];
    
    self.search = [[AMapSearchAPI alloc] init];
    self.search.delegate = self;
    self.request = [[AMapPOIKeywordsSearchRequest alloc] init];
    self.request.city                = self.city;
    self.request.requireExtension    = YES;
    /*  搜索SDK 3.2.0 中新增加的功能，只搜索本城市的POI。*/
    self.request.cityLimit           = YES;
    self.request.requireSubPOIs      = YES;
    
    
    if (self.poi) {
         _mapView.centerCoordinate = CLLocationCoordinate2DMake(self.poi.location.latitude,self.poi.location.longitude);
        AMapGeoPoint *point = [AMapGeoPoint new];
        point.latitude = self.poi.location.latitude;
        point.longitude = self.poi.location.longitude;
        self.request.location = point;
        [self.search AMapPOIKeywordsSearch:self.request];
    } else {
        [self initAMapLocation];
    }
}

- (void)locationClick {
    [self initAMapLocation];
}


//自定义大头针我这里只是把大头针变成一张自定义的图片
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation {
    if ([annotation isKindOfClass:[MAPointAnnotation class]]) {
        static NSString *reuseIndetifier = @"annotationReuseIndetifier";
        MAAnnotationView *annotationView = (MAAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifier];
        if (annotationView == nil) {
            annotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseIndetifier];
        }
        annotationView.image = [UIImage imageNamed:@"currentlocal"];
        //设置中心点偏移，使得标注底部中间点成为经纬度对应点
        annotationView.centerOffset = CGPointMake(0, -18);
        return annotationView;
    }
    return nil;
}

/**
 * @brief 地图移动结束后调用此接口
 * @param mapView 地图view
 * @param wasUserAction 标识是否是用户动作
 */
- (void)mapView:(MAMapView *)mapView mapDidMoveByUser:(BOOL)wasUserAction {
    if (wasUserAction) {
        AMapGeoPoint *point = [AMapGeoPoint new];
        point.latitude = mapView.centerCoordinate.latitude;
        point.longitude = mapView.centerCoordinate.longitude;
        self.request.location = point;
        [SVProgressHUD show];
        [self.search AMapPOIKeywordsSearch:self.request];
    }
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

- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location {
    //定位结果
    NSLog(@"location:{lat:%f; lon:%f; accuracy:%f}", location.coordinate.latitude, location.coordinate.longitude, location.horizontalAccuracy);
    self.mapView.centerCoordinate = location.coordinate;
    self.mapView.showsUserLocation = YES;
    self.mapView.userTrackingMode = MAUserTrackingModeFollow;
    
    AMapGeoPoint *point = [AMapGeoPoint new];
    point.latitude = location.coordinate.latitude;
    point.longitude = location.coordinate.longitude;
    self.request.location = point;
    [self.search AMapPOIKeywordsSearch:self.request];
    [manager stopUpdatingLocation];
}

/* POI 搜索回调. */
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response {
    [SVProgressHUD dismiss];
    if (response.pois.count == 0) {
        if (self.serachView.searchTF.text.length > 0 && ![self.serachView.searchTF.text isEqualToString:@""] && ![[self.serachView.searchTF.text stringByReplacingOccurrencesOfString:@"  " withString:@""] isEqualToString:@""]) {
            [SVProgressHUD showErrorWithStatus:@"没有搜索结果!"];
        }
        [self.locations removeAllObjects];
        [self.tableView reloadData];
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
    LxmMapCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LxmMapCell"];
    if (!cell) {
        cell = [[LxmMapCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmMapCell"];
    }
    cell.index = indexPath.row;
    AMapPOI *poi = [self.locations objectAtIndex:indexPath.row];
    cell.poi = poi;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    AMapPOI *poi = [self.locations objectAtIndex:indexPath.row];
    NSString *title = poi.name;
    NSString *address = [NSString stringWithFormat:@"%@%@%@%@",poi.province,poi.city,poi.district,poi.address];
    CGFloat titleH = [title getSizeWithMaxSize:CGSizeMake(ScreenW - 65, 40) withFontSize:16].height;
    CGFloat addressH = [address getSizeWithMaxSize:CGSizeMake(ScreenW - 65, 40) withFontSize:13].height;
    return 15 + (titleH > 40 ? 40 : titleH) + 10 + (addressH > 40 ? 40 : addressH) + 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    AMapPOI *poi = [self.locations objectAtIndex:indexPath.row];
    if (self.didselectPoi) {
        self.didselectPoi(poi);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

@end

/**
 cell
 */
@interface LxmMapCell()

@property (nonatomic, strong) UIImageView *iconImgView;//定位图标

@property (nonatomic, strong) UILabel *titleLabel;//标题

@property (nonatomic, strong) UILabel *addressLabel;//详细地址

@end

@implementation LxmMapCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews {
    [self addSubview:self.iconImgView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.addressLabel];
    UIView * line = [[UIView alloc] init];
    line.backgroundColor = LineColor;
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.leading.trailing.equalTo(self);
        make.height.equalTo(@0.5);
    }];
    [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.equalTo(self).offset(15);
        make.width.height.equalTo(@20);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.iconImgView);
        make.leading.equalTo(self.iconImgView.mas_trailing).offset(15);
        make.trailing.equalTo(self).offset(-15);
    }];
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.titleLabel);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
    }];
}

- (UIImageView *)iconImgView {
    if (!_iconImgView) {
        _iconImgView = [[UIImageView alloc] init];
        _iconImgView.image = [UIImage imageNamed:@"local"];
    }
    return _iconImgView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.numberOfLines = 2;
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.textColor = CharacterDarkColor;
    }
    return _titleLabel;
}

- (UILabel *)addressLabel {
    if (!_addressLabel) {
        _addressLabel = [[UILabel alloc] init];
        _addressLabel.font = [UIFont systemFontOfSize:13];
        _addressLabel.textColor = CharacterLightGrayColor;
        _addressLabel.numberOfLines = 2;
    }
    return _addressLabel;
}

- (void)setIndex:(NSInteger)index {
    _index = index;
    if (_index == 0) {
        _titleLabel.textColor = MainColor;
    } else {
        _titleLabel.textColor = CharacterDarkColor;
    }
}

- (void)setPoi:(AMapPOI *)poi {
    _poi = poi;
    if (_index == 0) {
        self.titleLabel.text = [NSString stringWithFormat:@"[当前位置]%@",_poi.name];
    } else {
        self.titleLabel.text = _poi.name;
    }
    
    self.addressLabel.text = [NSString stringWithFormat:@"%@%@%@%@",_poi.province,_poi.city,poi.district,poi.address];
}

@end


/**
 自定义地图标注View
 */
@interface LxmMapAnnotionView()

@end

@implementation LxmMapAnnotionView

- (instancetype)initWithAnnotation:(id<MAAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubview:self.imgView];
        [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.centerY.equalTo(self).offset(-10);
            make.width.height.equalTo(@20);
        }];
    }
    return self;
}

- (UIImageView *)imgView {
    if (!_imgView) {
        _imgView = [[UIImageView alloc] init];
        _imgView.image = [UIImage imageNamed:@"icon_dingwei"];
    }
    return _imgView;
}

@end
