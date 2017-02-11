//
//  ViewController.m
//  Advertisement
//
//  Created by Mervyn on 17/1/11.
//  Copyright © 2017年 mervyn_lbl@163.com. All rights reserved.
//

#import "ViewController.h"
#import "AdvertisementView.h"

@interface ViewController ()<AdvertisementViewDelegate>

@property (nonatomic,strong) AdvertisementView *advertisement;

@property (nonatomic,strong) NSArray *messages;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _messages = @[@"特大好消息,为了回馈广大的顾客,北城天地特推出年货8折优惠",@"海澜之家，男人的衣柜，每次都有新发现",@"2块钱你买不了吃亏买不了上当"];
    
    self.advertisement = [[AdvertisementView alloc] initWithFrame:CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, 30) direction:AdvertisementDirectionVertical];
    
    self.advertisement.delegate = self;
    
    self.advertisement.trumpetImage = @"trumpet";
    
    self.advertisement.removeImage = @"remove";
    
    __weak typeof(self)weakSelf = self;
    
    self.advertisement.removeAdvertisementBlock = ^(){
        
        [UIView animateWithDuration:0.5 animations:^{
            
            weakSelf.advertisement.transform = CGAffineTransformMakeTranslation(0, -weakSelf.advertisement.frame.origin.y);
            
            weakSelf.advertisement.alpha = 0;
            
        } completion:^(BOOL finished) {
            
            [weakSelf.advertisement removeFromSuperview];
        }];
    };
    
    [self.view addSubview:self.advertisement];
    
}



- (NSInteger)numberOfAdvertisementView:(AdvertisementView *)advertisement{
    
    return self.messages.count;
}

- (NSString *)advertisement:(AdvertisementView *)advertisement messageOfRow:(NSInteger)row{
    
    return self.messages[row];
}

- (void)advertisement:(AdvertisementView *)advertisement didSelectedOfRow:(NSInteger)row{
    
    NSLog(@"....... %ld",row);
}

- (CGFloat)durationForAdvertisement:(AdvertisementView *)advertisement{
    
    return 3;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
