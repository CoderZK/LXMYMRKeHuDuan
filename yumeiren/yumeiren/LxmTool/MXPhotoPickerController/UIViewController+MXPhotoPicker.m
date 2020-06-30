//
//  UIViewController+MXPhotoPicker.m
//  MXPhotoPickerController
//
//  Created by 韦纯航 on 15/12/8.
//  Copyright © 2015年 韦纯航. All rights reserved.
//

#import "UIViewController+MXPhotoPicker.h"

#import <objc/runtime.h>
#import "MXPhotoPickerController.h"
#import "MXImageEditController.h"

#pragma mark - MXImagePickerController

static NSString *const kPhotoLibraryTitle = @"从手机相册选择";
static NSString *const kCameraTitle = @"拍照";

@interface LxmHandler : NSObject<UIImagePickerControllerDelegate, UINavigationControllerDelegate, MXPhotoPickerControllerDelegate>
@property (nonatomic, weak) id context;

@end

@implementation LxmHandler
- (void)lxmimagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {}
- (void)lxmimagePickerController:(MXPhotoPickerController *)picker didFinishPickingWithAssets:(NSArray *)assets {}
#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self.context lxmimagePickerController:picker didFinishPickingMediaWithInfo:info];
}

#pragma mark - MXPhotoPickerControllerDelegate

- (void)imagePickerController:(MXPhotoPickerController *)picker didFinishPickingWithAssets:(NSArray *)assets
{
    [self.context lxmimagePickerController:picker didFinishPickingWithAssets:assets];
}


@end


@interface MXImagePickerController : UIImagePickerController

@end

@implementation MXImagePickerController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationBar.tintColor = [UIColor whiteColor];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)dealloc
{
    NSLog(@"%@ dealloc.", [[self class] description]);
}

@end

#pragma mark - UIActionSheet

#define NSArrayObjectMaybeNil(__ARRAY__, __INDEX__) ((__INDEX__ >= [__ARRAY__ count]) ? nil : [__ARRAY__ objectAtIndex:__INDEX__])
// This is a hack to turn an array into a variable argument list. There is no good way to expand arrays into variable argument lists in Objective-C. This works by nil-terminating the list as soon as we overstep the bounds of the array. The obvious glitch is that we only support a finite number of buttons.
#define NSArrayToVariableArgumentsList(__ARRAYNAME__) NSArrayObjectMaybeNil(__ARRAYNAME__, 0), NSArrayObjectMaybeNil(__ARRAYNAME__, 1), NSArrayObjectMaybeNil(__ARRAYNAME__, 2), NSArrayObjectMaybeNil(__ARRAYNAME__, 3), NSArrayObjectMaybeNil(__ARRAYNAME__, 4), NSArrayObjectMaybeNil(__ARRAYNAME__, 5), NSArrayObjectMaybeNil(__ARRAYNAME__, 6), NSArrayObjectMaybeNil(__ARRAYNAME__, 7), NSArrayObjectMaybeNil(__ARRAYNAME__, 8), NSArrayObjectMaybeNil(__ARRAYNAME__, 9), nil

typedef void (^UIActionSheetClickBlock)(UIActionSheet *actionSheet, NSInteger buttonIndex);

@interface MXActionSheet : UIActionSheet

@property (copy, nonatomic) UIActionSheetClickBlock clickBlock;

+ (id)actionSheetWithTitle:(NSString *)title
         cancelButtonTitle:(NSString *)cancelButtonTitle
    destructiveButtonTitle:(NSString *)destructiveButtonTitle
         otherButtonTitles:(NSArray *)otherButtonTitles;

- (void)addClickBlock:(UIActionSheetClickBlock)clickBlock;

@end

@implementation MXActionSheet

+ (id)actionSheetWithTitle:(NSString *)title
         cancelButtonTitle:(NSString *)cancelButtonTitle
    destructiveButtonTitle:(NSString *)destructiveButtonTitle
         otherButtonTitles:(NSArray *)otherButtonTitles
{
    MXActionSheet *actionSheet = [[self alloc] initWithTitle:title
                                                    delegate:nil
                                           cancelButtonTitle:cancelButtonTitle
                                      destructiveButtonTitle:destructiveButtonTitle
                                           otherButtonTitles:NSArrayToVariableArgumentsList(otherButtonTitles)];
    return actionSheet;
}

- (void)addClickBlock:(UIActionSheetClickBlock)clickBlock
{
    [self _checkActionSheetOriginalDelegate];
    _clickBlock = [clickBlock copy];
}

- (void)_checkActionSheetOriginalDelegate {
    if (self.delegate != (id<UIActionSheetDelegate>)self) {
        self.delegate = (id<UIActionSheetDelegate>)self;
    }
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([actionSheet isKindOfClass:[self class]]) {
        MXActionSheet *mxActionSheet = (MXActionSheet *)actionSheet;
        UIActionSheetClickBlock completion = mxActionSheet.clickBlock;
        if (completion) {
            completion(actionSheet, buttonIndex);
        }
    }
}

@end

#pragma mark - MXPhotoPicker

@interface UIViewController ()

@property (copy, nonatomic) MXPhotoPickerSingleBlock pickerSingleBlock;
@property (copy, nonatomic) MXPhotoPickerMultipleBlock pickerMultipleBlock;
@property (assign, nonatomic) BOOL needToEdit;

@end

@implementation UIViewController (MXPhotoPicker)

static const void *MXPhotoPickerSingleBlockKey = &MXPhotoPickerSingleBlockKey;
static const void *MXPhotoPickerMultipleBlockKey = &MXPhotoPickerMultipleBlockKey;
static const void *MXPhotoPickerNeedToEditKey = &MXPhotoPickerNeedToEditKey;

#pragma mark - Setter & Getter

- (void)setPickerSingleBlock:(MXPhotoPickerSingleBlock)pickerSingleBlock
{
    [self willChangeValueForKey:@"pickerSingleBlock"];
    objc_setAssociatedObject(self, MXPhotoPickerSingleBlockKey, pickerSingleBlock, OBJC_ASSOCIATION_COPY);
    [self didChangeValueForKey:@"pickerSingleBlock"];
}

- (MXPhotoPickerSingleBlock)pickerSingleBlock
{
    return objc_getAssociatedObject(self, MXPhotoPickerSingleBlockKey);
}

- (void)setLxmHandler:(LxmHandler *)handler
{
    objc_setAssociatedObject(self, @selector(lxmHandler), handler, OBJC_ASSOCIATION_RETAIN);
}

- (LxmHandler *)lxmHandler
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setPickerMultipleBlock:(MXPhotoPickerMultipleBlock)pickerMultipleBlock
{
    [self willChangeValueForKey:@"pickerMultipleBlock"];
    objc_setAssociatedObject(self, MXPhotoPickerMultipleBlockKey, pickerMultipleBlock, OBJC_ASSOCIATION_COPY);
    [self didChangeValueForKey:@"pickerMultipleBlock"];
}

- (MXPhotoPickerMultipleBlock)pickerMultipleBlock
{
    return objc_getAssociatedObject(self, MXPhotoPickerMultipleBlockKey);
}

- (void)setNeedToEdit:(BOOL)needToEdit
{
    [self willChangeValueForKey:@"needToEdit"];
    objc_setAssociatedObject(self, MXPhotoPickerNeedToEditKey, @(needToEdit), OBJC_ASSOCIATION_ASSIGN);
    [self didChangeValueForKey:@"needToEdit"];
}

- (BOOL)needToEdit
{
    return [objc_getAssociatedObject(self, MXPhotoPickerNeedToEditKey) boolValue];
}

#pragma mark - Public

/**
 *  照相 + 相册（均单选）
 *
 *  @param title      选择器标题
 *  @param needToEdit 选择图片后是否需要编辑
 *  @param completion 回调
 */
- (void)showMXPhotoPickerWithTitle:(NSString *)title
                        needToEdit:(BOOL)needToEdit
                        completion:(MXPhotoPickerSingleBlock)completion
{
    NSMutableArray *otherButtonTitles = [NSMutableArray array];
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [otherButtonTitles addObject:kCameraTitle];
    }
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        [otherButtonTitles addObject:kPhotoLibraryTitle];
    }
    
    if (otherButtonTitles.count == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"当前设备不支持拍照和图库" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
        [alertView performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
        return;
    }
    
    self.pickerSingleBlock = completion;
    self.needToEdit = needToEdit;
    
    typeof(self) __weak weakSelf = self;
    MXActionSheet *actionSheet = [MXActionSheet actionSheetWithTitle:title cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:otherButtonTitles];
    [actionSheet addClickBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
        [weakSelf actionSheet:actionSheet didClickButtonAtIndex:buttonIndex];
    }];
    [actionSheet performSelectorOnMainThread:@selector(showInView:) withObject:self.view waitUntilDone:YES];
}

/**
 *  照相（单选）
 *
 *  @param needToEdit 选择图片后是否需要编辑
 *  @param completion 回调
 */
- (void)showMXPhotoCameraAndNeedToEdit:(BOOL)needToEdit
                            completion:(MXPhotoPickerSingleBlock)completion
{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [[[UIAlertView alloc] initWithTitle:nil message:@"当前设备不支持拍照" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil] show];
        return;
    }
    
    [self showMXPhotoCamera];
    self.pickerSingleBlock = completion;
    self.needToEdit = needToEdit;
}

/**
 *  相册（单选）
 *
 *  @param needToEdit 选择图片后是否需要编辑
 *  @param completion 回调
 */
- (void)showMXPhotoPickerControllerAndNeedToEdit:(BOOL)needToEdit
                                      completion:(MXPhotoPickerSingleBlock)completion
{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        [[[UIAlertView alloc] initWithTitle:nil message:@"当前设备不支持图库" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil] show];
        return;
    }
    
    [self showMXPhotoPickerController];
    self.pickerSingleBlock = completion;
    self.needToEdit = needToEdit;
}

/**
 *  相册（多选）
 *
 *  @param maximumNumberOfSelectionalPhotos 最多允许选择的图片张数
 *  @param completion                       回调
 */
- (void)showMXPickerWithMaximumPhotosAllow:(NSInteger)maximumNumberOfSelectionalPhotos
                                completion:(MXPhotoPickerMultipleBlock)completion
{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        [[[UIAlertView alloc] initWithTitle:nil message:@"当前设备不支持图库" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil] show];
        return;
    }
    
    [self showMXPhotosPickerController:maximumNumberOfSelectionalPhotos];
    self.pickerMultipleBlock = completion;
}

#pragma mark - Private

- (void)actionSheet:(UIActionSheet *)actionSheet didClickButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == [actionSheet cancelButtonIndex]) {
        return;
    }
    
    NSString *title = [actionSheet buttonTitleAtIndex:buttonIndex];
    
    if ([title isEqualToString:kCameraTitle]) {
        [self showMXPhotoCamera];
    }
    else if ([title isEqualToString:kPhotoLibraryTitle]) {
        [self showMXPhotoPickerController];
    }
}

- (void)showMXPhotoCamera
{
    MXImagePickerController *imagePicker = [[MXImagePickerController alloc] init];
    [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
    LxmHandler *handler = [LxmHandler new];
    handler.context = self;
    self.lxmHandler = handler;
    [imagePicker setDelegate:handler];
    
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (void)showMXPhotoPickerController
{
    MXImagePickerController *imagePicker = [[MXImagePickerController alloc] init];
    [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    LxmHandler *handler = [LxmHandler new];
    handler.context = self;
    self.lxmHandler = handler;
    [imagePicker setDelegate:handler];

    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (void)showMXPhotosPickerController:(NSInteger)maximumNumberOfSelectionalPhotos
{
    MXPhotoPickerController *imagePicker = [[MXPhotoPickerController alloc] init];
    [imagePicker setMaximumNumberOfSelectionalPhotos:maximumNumberOfSelectionalPhotos];
    
    LxmHandler *handler = [LxmHandler new];
    handler.context = self;
    self.lxmHandler = handler;
    [imagePicker setDelegate:handler];
    imagePicker.finishedDelegate = handler;
    
    [self presentViewController:imagePicker animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)lxmimagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *imageOriginal = [info valueForKey:UIImagePickerControllerOriginalImage];
    if (!imageOriginal) {
        if (self.pickerSingleBlock) self.pickerSingleBlock(nil, nil, CGRectZero);
        [picker dismissViewControllerAnimated:YES completion:nil];
    } else {
        if (self.needToEdit) { //需要编辑图片
            MXImageEditController *imageEditController = [[MXImageEditController alloc] initWithImage:imageOriginal doneBlock:^(UIImage *image, UIImage *originImage, CGRect cutRect) {
                if (self.pickerSingleBlock) self.pickerSingleBlock(image, originImage, cutRect);
                [picker dismissViewControllerAnimated:YES completion:nil];
            }];
            [picker pushViewController:imageEditController animated:YES];
        }
        else {
            imageOriginal = [imageOriginal mx_fixOrientation];
            CGRect cutRect = (CGRect){CGPointZero, imageOriginal.size};
            if (self.pickerSingleBlock) self.pickerSingleBlock(imageOriginal, imageOriginal, cutRect);
            [picker dismissViewControllerAnimated:YES completion:nil];
        }
    }
    
}

#pragma mark - MXPhotoPickerControllerDelegate

- (void)lxmimagePickerController:(MXPhotoPickerController *)picker didFinishPickingWithAssets:(NSArray *)assets
{
    if (self.pickerMultipleBlock) self.pickerMultipleBlock(assets);
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
