//
//  LxmTool.m
//  emptyCityNote
//
//  Created by 李晓满 on 2017/11/22.
//  Copyright © 2017年 李晓满. All rights reserved.
//

#import "LxmTool.h"

static LxmTool * __tool = nil;
@implementation LxmTool
@synthesize isLogin = _isLogin;
@synthesize userModel = _userModel;
@synthesize goodsList = _goodsList;

+(LxmTool *)ShareTool {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __tool=[[LxmTool alloc] init];
    });
    return __tool;
}
- (instancetype)init {
    if (self = [super init])
    {
        _isLogin = [self isLogin];
    }
    return self;
}
-(void)setIsLogin:(BOOL)isLogin {
    _isLogin = isLogin;
    [[NSUserDefaults standardUserDefaults] setBool:isLogin forKey:@"isLogin"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(BOOL)isLogin {
     _isLogin = [[NSUserDefaults standardUserDefaults] boolForKey:@"isLogin"];
    return _isLogin;
}

-(void)setSession_token:(NSString *)session_token {
    [[NSUserDefaults standardUserDefaults] setObject:session_token forKey:@"session_token"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(NSString *)session_token {
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"session_token"];
    return token ? token : @"";
}

- (void)setSession_uid:(NSString *)session_uid {
    [[NSUserDefaults standardUserDefaults] setObject:session_uid forKey:@"session_uid"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (NSString *)session_uid {
     return [[NSUserDefaults standardUserDefaults] objectForKey:@"session_uid"];
}

- (void)setDeviceToken:(NSString *)deviceToken {
    [[NSUserDefaults standardUserDefaults] setObject:deviceToken forKey:@"deviceToken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (NSString *)deviceToken {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"];
}

- (void)setUserModel:(LxmUserInfoModel *)userModel{
    _userModel = userModel;
    if (userModel) {
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:userModel];
        if (data) {
            [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"userModel"];
        }
    } else {
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"userModel"];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (LxmUserInfoModel *)userModel{
    if (!_userModel) {
        //取出
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"userModel"];
        if (data) {
            _userModel = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        }
    }
    return _userModel;
}

- (NSArray<LxmHomeGoodsModel *> *)shengjiGoodsList {
    NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/shengjigoods.plist"];
    NSArray *arr = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    return arr;
}

- (NSArray<LxmHomeGoodsModel *> *)goodsList {
    NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/goods.plist"];
    NSArray *arr = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    return arr;
}

/**
 保存到本地
 */
- (void)saveSubGoods:(LxmHomeGoodsModel *)goods {
    if (goods) {
        NSMutableArray *mutableArr = [NSMutableArray array];
        //完整的文件路径
        NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/goods.plist"];
        //获取文件夹路径
        NSString *directory = [filePath stringByDeletingLastPathComponent];
        //判断文件夹是否存在
        BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:directory isDirectory:nil];
        //如果不存在则创建文件夹
        if (!fileExists) {
            
            NSLog(@"文件夹不存在");
            //创建文件夹
            NSError *error = nil;
            [[NSFileManager defaultManager] createDirectoryAtPath:directory withIntermediateDirectories:YES attributes:nil error:&error];
            if (error) {
                NSLog(@"error=%@",error.description);
            } else {
                NSLog(@"文件夹创建成功");
            }
        }
        NSArray *arr = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
        if (arr) {
            [mutableArr addObjectsFromArray:arr];
        }
        LxmHomeGoodsModel *model = [self getGoodsAtArr:mutableArr withGoodsID:goods.id];
        if (!model) {
            [mutableArr addObject:goods];
            [NSKeyedArchiver archiveRootObject:mutableArr toFile:filePath];
            _goodsList = mutableArr;
        } else {
            for (int i = 0; i < _goodsList.count; i++) {
                LxmHomeGoodsModel *model = mutableArr[i];
                if (model.id == goods.id) {
                    [mutableArr replaceObjectAtIndex:i withObject:goods];
                    break;
                }
            }
            [NSKeyedArchiver archiveRootObject:mutableArr toFile:filePath];
            _goodsList = mutableArr;
        }
    }
}

- (LxmHomeGoodsModel *)getGoodsAtArr:(NSArray *)arr withGoodsID:(NSString *)ID {
    for (LxmHomeGoodsModel *model in arr) {
        if ([model.id isEqualToString:ID]) {
            return model;
        }
    }
    return nil;
}

/**
 删除本地
 */
- (void)delSubGoods:(LxmHomeGoodsModel *)goods {
    if (goods) {
        NSMutableArray *mutableArr = [NSMutableArray array];
        NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/goods.plist"];
        NSArray *arr = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
        if (arr) {
            [mutableArr addObjectsFromArray:arr];
        }
        LxmHomeGoodsModel *model = [self getGoodsAtArr:mutableArr withGoodsID:goods.id];
        if (model) {
            [mutableArr removeObject:model];
            [NSKeyedArchiver archiveRootObject:mutableArr toFile:filePath];
           _goodsList = mutableArr;
        }
    }
}

/**
 本地商品数据全部删除
 */
- (void)delAllGoods {
    NSMutableArray *mutableArr = [NSMutableArray array];
    NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/goods.plist"];
    NSArray *arr = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    if (arr) {
        [mutableArr addObjectsFromArray:arr];
    }
    [mutableArr removeAllObjects];
    [NSKeyedArchiver archiveRootObject:mutableArr toFile:filePath];
}

/**
 保存升级货物到本地
 */
- (void)saveShengJiSubGoods:(LxmHomeGoodsModel *)goods {
    if (goods) {
        NSMutableArray *mutableArr = [NSMutableArray array];
        //完整的文件路径
        NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/shengjigoods.plist"];
        //获取文件夹路径
        NSString *directory = [filePath stringByDeletingLastPathComponent];
        //判断文件夹是否存在
        BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:directory isDirectory:nil];
        //如果不存在则创建文件夹
        if (!fileExists) {
            
            NSLog(@"文件夹不存在");
            //创建文件夹
            NSError *error = nil;
            [[NSFileManager defaultManager] createDirectoryAtPath:directory withIntermediateDirectories:YES attributes:nil error:&error];
            if (error) {
                NSLog(@"error=%@",error.description);
            } else {
                NSLog(@"文件夹创建成功");
            }
        }
        NSArray *arr = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
        if (arr) {
            [mutableArr addObjectsFromArray:arr];
        }
        LxmHomeGoodsModel *model = [self getGoodsAtArr:mutableArr withGoodsID:goods.id];
        if (!model) {
            [mutableArr addObject:goods];
            [NSKeyedArchiver archiveRootObject:mutableArr toFile:filePath];
            _shengjiGoodsList = mutableArr;
        } else {
            for (int i = 0; i < _shengjiGoodsList.count; i++) {
                LxmHomeGoodsModel *model = mutableArr[i];
                if (model.id == goods.id) {
                    [mutableArr replaceObjectAtIndex:i withObject:goods];
                    break;
                }
            }
            [NSKeyedArchiver archiveRootObject:mutableArr toFile:filePath];
            _shengjiGoodsList = mutableArr;
        }
    }
}

/**
 删除本地升级货物
 */
- (void)delShengJiSubGoods:(LxmHomeGoodsModel *)goods {
    if (goods) {
        NSMutableArray *mutableArr = [NSMutableArray array];
        NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/shengjigoods.plist"];
        NSArray *arr = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
        if (arr) {
            [mutableArr addObjectsFromArray:arr];
        }
        LxmHomeGoodsModel *model = [self getGoodsAtArr:mutableArr withGoodsID:goods.id];
        if (model) {
            [mutableArr removeObject:model];
            [NSKeyedArchiver archiveRootObject:mutableArr toFile:filePath];
            _shengjiGoodsList = mutableArr;
        }
    }
}

/**
 本地升级货物商品数据全部删除
 */
- (void)delShengJiAllGoods {
    NSMutableArray *mutableArr = [NSMutableArray array];
    NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/shengjigoods.plist"];
    NSArray *arr = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    if (arr) {
        [mutableArr addObjectsFromArray:arr];
    }
    [mutableArr removeAllObjects];
    [NSKeyedArchiver archiveRootObject:mutableArr toFile:filePath];
}




-(void)uploadDeviceToken {
    if (self.isLogin&&self.session_token&&[LxmTool ShareTool].deviceToken.isValid)
    {
        NSInteger state = [LxmTool ShareTool].userModel.sendStatus.intValue;
        NSDictionary * dic = @{
                               @"token":self.session_token,
                               @"umeng_id":[LxmTool ShareTool].deviceToken,
                               @"device_type":@1,
                               @"send_status":@(state==2?2:1)
                               };
        [LxmNetworking networkingPOST:umeng_id_up parameters:dic returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            NSLog(@"推送token上传成功:%@",responseObject);
        } failure:^(NSURLSessionDataTask *task, NSError *error) {

        }];
    }
}

@end
