//
//  DownloaderCell.m
//  DownloaderDemo
//
//  Created by Cuikeyi on 2016/12/19.
//  Copyright © 2016年 xiaohongchun. All rights reserved.
//

#import "DownloaderCell.h"
#import "DownloaderModel.h"

@interface DownloaderCell ()

@property (nonatomic, strong) UIImageView *picView;
@property (nonatomic, strong) UILabel *progressLabel;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation DownloaderCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initView];
    }
    return self;
}

- (void)initView
{
    _picView = [UIImageView newAutoLayoutView];
    [self.contentView addSubview:_picView];
    [_picView autoSetDimensionsToSize:CGSizeMake(44, 44)];
    [_picView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:5];
    [_picView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:20];
    
    _progressLabel = [UILabel newAutoLayoutView];
    _progressLabel.textColor = [UIColor redColor];
    _progressLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:_progressLabel];
    [_progressLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:20];
    [_progressLabel autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:5];
    
    _titleLabel = [UILabel newAutoLayoutView];
    _titleLabel.textColor = [UIColor blackColor];
    _titleLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:_titleLabel];
    [_titleLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:5];
    [_titleLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:20];
}

- (void)setModel:(DownloaderModel *)model
{
    _model = model;
    [_picView sd_setImageWithURL:[NSURL URLWithString:_model.imageUrl]];
    RAC(_progressLabel, text) = [[RACObserve(self, model.progress) map:^id(NSNumber *value) {
        return [NSString stringWithFormat:@"%.2f", value.floatValue];
    }] takeUntil:self.rac_prepareForReuseSignal];
    RAC(_titleLabel, text) = [RACObserve(self, model.title) takeUntil:self.rac_prepareForReuseSignal];
}

@end
