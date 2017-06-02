//
//  QYGLChatSystemNotificationTableViewCell.m
//  QYGLChatCell
//
//  Created by lixu on 2017/5/17.
//  Copyright © 2017年 lixu. All rights reserved.
//

#import "QYGLChatSystemNotificationTableViewCell.h"

@interface QYGLChatSystemNotificationTableViewCell ()

@property (nonatomic ,assign) CGFloat fontSize;

@end

@implementation QYGLChatSystemNotificationTableViewCell

#pragma  mark - Life Cycle
- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        _fontSize = 14;
        [self setNeedsUpdateConstraints];
    }
    
    return self;
}

- (void) updateConstraints
{
    [super updateConstraints];
    [self.chatContentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_left).offset(15);
        make.right.equalTo(self.mas_right).offset(-15);
        make.bottom.equalTo(self.mas_bottom);
    }];
}

#pragma  mark - Event Response

#pragma  mark - Delegate

#pragma  mark - Notification

#pragma  mark - Public Method

@end
