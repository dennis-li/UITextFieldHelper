//
//  QYGLChatTableViewCell.h
//  QiYiVideo
//
//  Created by lixu on 17/3/14.
//  Copyright © 2017年 QiYi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QYGLChatModel.h"

@interface QYGLChatTableViewCell : UITableViewCell

@property (nonatomic ,strong) NSString *hello;

//聊天内容
@property (nonatomic ,readonly,strong) QYGLChatModel *model;

//字体大小

+ (instancetype) chatCellWithModel:(id)model reuseIdentifier:(NSString *)reuseIdentifier;

@end
