//
//  AdvertisementView.m
//  Advertisement
//
//  Created by Mervyn on 17/1/11.
//  Copyright © 2017年 mervyn_lbl@163.com. All rights reserved.
//

#import "AdvertisementView.h"

#define SingleDuration 1.5
#define SwitchTime 1.5

@interface AdvertisementView ()<UIScrollViewDelegate>
{
    AdvertisementDirection _direction;
    NSInteger _advertisementCount;
    CGFloat _playDuration;
    NSTimer *_timer;
    NSInteger _currentIndex;
    NSString *_firstString;
}

@property (nonatomic,weak) UIScrollView *advertisementScroll;

@property (nonatomic,strong) NSMutableArray *advertisementSubViews;

@end

@implementation AdvertisementView

- (instancetype)initWithFrame:(CGRect)frame direction:(AdvertisementDirection)direction{
    
    self = [super init];
    
    if (self) {
        
        self.frame = frame;
        
        _direction = direction;
        
        _currentIndex = 0;
        
        self.userInteractionEnabled = YES;
        
        self.backgroundColor = [UIColor colorWithRed:206/255.0 green:98/255.0 blue:42/255.0 alpha:0.7];
        
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview{
    
    [self setupTrumpetImage];
    
    [self reloadData];
}

- (void)reloadData{
    
    [self stopTimer];
    
    for (UIView *subview in self.advertisementScroll.subviews) {
        
        [subview removeFromSuperview];
    }
    
    [self.advertisementSubViews removeAllObjects];
    
    _advertisementCount = [self.delegate numberOfAdvertisementView:self];
    
    _playDuration = [self getDuration] * _advertisementCount;
    
    switch (_direction) {
            
        case AdvertisementDirectionVertical:
            
        {
            [self verticalMode];
            break;
        }
        case AdvertisementDirectionHorizontal:
        {
            [self horizontalMode];
            break;
        }
        
    }
    
}

- (void)verticalMode{
    
    for (NSInteger i = 0; i < _advertisementCount; i++) {
        
        UILabel *advertisment = [[UILabel alloc] init];
        advertisment.frame = CGRectMake(0, i*self.frame.size.height, self.advertisementScroll.frame.size.width, self.frame.size.height);
        advertisment.font = [self getFont];
        advertisment.textColor = [self getColor];
        advertisment.tag = 1000 + i;
        advertisment.text = [self.delegate advertisement:self messageOfRow:i];
        if (i == 0) {
            _firstString = advertisment.text;
        }
        [self.advertisementScroll addSubview:advertisment];
        
        [self.advertisementSubViews addObject:advertisment];
    }
    
    UILabel *advertisment = [[UILabel alloc] init];
    advertisment.frame = CGRectMake(0, _advertisementCount*self.frame.size.height, self.advertisementScroll.frame.size.width, self.frame.size.height);
    advertisment.font = [self getFont];
    advertisment.textColor = [self getColor];
    advertisment.tag = 1000;
    advertisment.text = _firstString;
    [self.advertisementScroll addSubview:advertisment];
    
    self.advertisementScroll.contentSize = CGSizeMake(0, (_advertisementCount+1)*self.frame.size.height);
    
    [self startTimer];
}

- (void)horizontalMode{
    
    CGFloat maxX = 0;
    
    for (NSInteger i = 0; i < _advertisementCount; i++) {
        
        NSString *messageStr = [self.delegate advertisement:self messageOfRow:i];
        if (i == 0) {
            _firstString = messageStr;
        }
        
        CGFloat msgWidth = [self calculateAdvrttisementStringWidth:messageStr];
        
        UILabel *advertisment = [[UILabel alloc] init];
        advertisment.frame = CGRectMake(maxX, 0, msgWidth, self.frame.size.height);
        advertisment.font = [self getFont];
        advertisment.textColor = [self getColor];
        advertisment.tag = 1000 + i;
        advertisment.text = messageStr;
        [self.advertisementScroll addSubview:advertisment];
        
        [self.advertisementSubViews addObject:advertisment];
        
        maxX = maxX + msgWidth + self.advertisementScroll.frame.size.width;
    }
    
    CGFloat subMsgWidth = [self calculateAdvrttisementStringWidth:_firstString];
    
    UILabel *subAdvertisment = [[UILabel alloc] init];
    subAdvertisment.frame = CGRectMake(maxX, 0, subMsgWidth, self.frame.size.height);
    subAdvertisment.font = [self getFont];
    subAdvertisment.textColor = [self getColor];
    subAdvertisment.tag = 1000;
    subAdvertisment.text = _firstString;
    [self.advertisementScroll addSubview:subAdvertisment];
    
    [self.advertisementSubViews addObject:subAdvertisment];
    
    self.advertisementScroll.contentSize = CGSizeMake(maxX + subMsgWidth, 0);
    
    _currentIndex++;
    
    [self startTimer];
    
}

- (CGFloat)calculateAdvrttisementStringWidth:(NSString *)adverStr{
    
    CGRect adverRect = [adverStr boundingRectWithSize:CGSizeMake(MAXFLOAT, self.frame.size.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil];
    
    return adverRect.size.width;
}

- (UIFont *)getFont{
    
    if (self.textFont) {
        
        return self.textFont;
        
    }else{
        
        return [UIFont systemFontOfSize:15];
    }
}
- (UIColor *)getColor{
    
    if (self.textColor) {
        
        return self.textColor;
        
    }else{
        
        return [UIColor colorWithDisplayP3Red:34/255.0 green:34/255.0 blue:34/255.0 alpha:1];
    }
}

- (CGFloat)getDuration{
    
    if ([self.delegate respondsToSelector:@selector(durationForAdvertisement:)]) {
        
        return [self.delegate durationForAdvertisement:self];
        
    }else{
        
        return SingleDuration;
    }
}

- (CGFloat)getSwitchDuration{
    
    if ([self.delegate respondsToSelector:@selector(durationForAdvertisementSwitchScroll:)]) {
        
        return [self.delegate durationForAdvertisementSwitchScroll:self];
        
    }else{
        
        return SwitchTime;
    }
}

- (void)startTimer{
        
    _timer = [NSTimer scheduledTimerWithTimeInterval:[self getDuration] target:self selector:@selector(modifyContentOffset) userInfo:nil repeats:YES];
}

- (void)stopTimer{
    
    if (_timer) {
        
        [_timer invalidate];
        
        _timer = nil;
    }
}

- (void)modifyContentOffset{
    
    __weak typeof(self)weakSelf = self;
    
    [self stopTimer];
    
    switch (_direction) {
            
        case AdvertisementDirectionVertical:
        {
            
            __block CGPoint newPoint = self.advertisementScroll.contentOffset;
            newPoint.y = self.advertisementScroll.contentOffset.y + self.frame.size.height;
            [UIView animateWithDuration:[self getSwitchDuration] animations:^{
                
                weakSelf.advertisementScroll.contentOffset = newPoint;
                
                [weakSelf startTimer];
                
            } completion:^(BOOL finished) {
                
                if (newPoint.y == _advertisementCount*weakSelf.frame.size.height) {
                    
                    newPoint = CGPointZero;
                    
                    weakSelf.advertisementScroll.contentOffset = newPoint;
                }
            }];
            break;
        }
        case AdvertisementDirectionHorizontal:
        {
            
            UILabel *msgLabel = self.advertisementSubViews[_currentIndex - 1];
            
            __block CGPoint point = self.advertisementScroll.contentOffset;
            
            point.x = point.x + msgLabel.frame.size.width + self.advertisementScroll.frame.size.width;
            
            [UIView animateWithDuration:[self getSwitchDuration] animations:^{
                
                weakSelf.advertisementScroll.contentOffset = point;
                
                [weakSelf startTimer];
                
            }completion:^(BOOL finished) {
                
                if (_currentIndex < _advertisementCount) {
                    
                    _currentIndex++;
                    
                }else{
                    
                    _currentIndex = 1;
                    
                    point = CGPointZero;
                    
                    self.advertisementScroll.contentOffset = point;
                }
                
            } ];
            
            break;
        }
    }
}

- (CGFloat)contentSizeWidth:(CGFloat)width{
    
    if (width >= self.self.advertisementScroll.frame.size.width) {
        
        return 0;
        
    }else{
        
        return width;
    }
}

- (void)tapBegan:(UITapGestureRecognizer *)tap{
    
    if (![self.delegate respondsToSelector:@selector(advertisement:didSelectedOfRow:)]) {
        
        return;
    }
    
    CGPoint point = [tap locationInView:tap.view];
    
    __block NSInteger index = 0;
    
    [self.advertisementSubViews enumerateObjectsUsingBlock:^(UILabel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (CGRectContainsPoint(obj.frame, point)) {
            
            index = obj.tag;
            
            *stop = YES;
        }
        
    }];
    
    if (index) {
        
        [self.delegate advertisement:self didSelectedOfRow:index-1000];
    }
}

- (void)removeAdvertisement{
    
    if (_removeAdvertisementBlock) {
        
        self.removeAdvertisementBlock();
    }
}

- (void)setupTrumpetImage{
    
    UIImageView *trumpetImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.height, self.frame.size.height)];
    trumpetImg.contentMode = UIViewContentModeCenter;
    trumpetImg.image = [[UIImage imageNamed:self.trumpetImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self addSubview:trumpetImg];
}

- (CGFloat)rightItem{
   
    if (self.removeImage) {
        
        UIButton *removeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        removeBtn.frame = CGRectMake(self.frame.size.width - self.frame.size.height, 0, self.frame.size.height, self.frame.size.height);
        [removeBtn setImage:[UIImage imageNamed:self.removeImage] forState:UIControlStateNormal];
        [removeBtn addTarget:self action:@selector(removeAdvertisement) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:removeBtn];
        
        return self.frame.size.height;
        
    }else{
        
        return 0;
    }
    
}

- (UIScrollView *)advertisementScroll{
    
    if (!_advertisementScroll) {
        
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(self.frame.size.height, 0, self.frame.size.width-self.frame.size.height-[self rightItem], self.frame.size.height)];
        scrollView.delegate = self;
        scrollView.contentOffset = CGPointZero;
        scrollView.contentSize = CGSizeZero;
        scrollView.userInteractionEnabled = YES;
        self.advertisementScroll = scrollView;
        [self addSubview:scrollView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBegan:)];
        [scrollView addGestureRecognizer:tap];
    }
    return _advertisementScroll;
}

- (NSMutableArray *)advertisementSubViews{
    
    if (!_advertisementSubViews) {
        
        _advertisementSubViews = [NSMutableArray array];
    }
    
    return _advertisementSubViews;
}


@end
