//
//  AdvertisementView.h
//  Advertisement
//
//  Created by Mervyn on 17/1/11.
//  Copyright © 2017年 mervyn_lbl@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AdvertisementView;

typedef enum {
    
    AdvertisementDirectionHorizontal = 0,
    AdvertisementDirectionVertical
    
}AdvertisementDirection;

@protocol AdvertisementViewDelegate <NSObject>

@required
/**
 *  广告数量
 */
- (NSInteger)numberOfAdvertisementView:(AdvertisementView *)advertisement;
/**
 *  广告内容
 */
- (NSString *)advertisement:(AdvertisementView *)advertisement messageOfRow:(NSInteger)row;

@optional
/**
 *  点击了某一个广告
 */
- (void)advertisement:(AdvertisementView *)advertisement didSelectedOfRow:(NSInteger)row;
/**
 *  一个广告的播放时间(停留的时间)
 */
- (CGFloat)durationForAdvertisement:(AdvertisementView *)advertisement;
/**
 *  广告切换的滚动时间
 */
- (CGFloat)durationForAdvertisementSwitchScroll:(AdvertisementView *)advertisememt;

@end

@interface AdvertisementView : UIView

- (instancetype)initWithFrame:(CGRect)frame direction:(AdvertisementDirection)direction;

@property (nonatomic,weak) id <AdvertisementViewDelegate> delegate;
/**
 *  左边图片（这里我称为小喇叭）,必有,不设置显示空
 */
@property (nonatomic,copy) NSString *trumpetImage;
/**
 *  右边图片（这里我称为移除广告）,可有可无
 */
@property (nonatomic,copy) NSString *removeImage;
/**
 *  内容文字大小
 */
@property (nonatomic,strong) UIFont *textFont;
/**
 *  内容文字颜色
 */
@property (nonatomic,strong) UIColor *textColor;

- (void)reloadData;

@property (nonatomic,copy) void (^removeAdvertisementBlock)();

@end
