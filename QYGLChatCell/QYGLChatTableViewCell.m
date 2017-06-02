//
//  QYGLChatTableViewCell.m
//  QiYiVideo
//
//  Created by lixu on 17/3/14.
//  Copyright © 2017年 QiYi. All rights reserved.
//

#import "QYGLChatTableViewCell.h"
#import "QYGamelive.pch"
#import "QYGLUnzipEmoj.h"


@interface QYGLChatTableViewCell ()

//聊天内容
@property (nonatomic ,readwrite,strong) QYGLChatModel *model;

/**
 聊天内容
 */
@property (nonatomic ,strong) UILabel *chatContentLabel;

@end

@implementation QYGLChatTableViewCell

#pragma  mark - Life Cycle
+ (instancetype) chatCellWithModel:(id)model reuseIdentifier:(NSString *)reuseIdentifier
{
    QYGLChatTableViewCell *cell = [[self class] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier withModel:model];
    
    return cell;
}

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withModel:(id)model
{
    self = [self initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        _model = model;

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
/**
 显示聊天的内容
 
 @prama name 发送聊天的用户的昵称
 @prama content 聊天的内容
 @prama type 聊天内容的类型，普通，房主，主播。
 */
- (void) updateChatContentWithName:(NSString *) name
                       chatContent:(NSString *) content
                              mutableAttr:(NSMutableAttributedString *) mutableAttr
{
//    NSString *contentString = [name stringByAppendingString:content];
//    
//    
//    
//    //创建NSMutableAttributedString
//    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:contentString attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]}];
//    
//    //添加文字颜色
//    [attrStr addAttribute:NSForegroundColorAttributeName value:ColorWithHexValue(@"3395fc") range:NSMakeRange(0, [name length])];
//    [attrStr addAttribute:NSForegroundColorAttributeName value:ColorWithHexValue(@"333333") range:NSMakeRange([name length], [content length])];
    
    name = name ?:@"";
    content = content ?:@"";
    
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:name attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:self.fontSize]}];
    //添加文字颜色
    [attrStr addAttribute:NSForegroundColorAttributeName value:ColorWithHexValue(@"3395fc") range:NSMakeRange(0, [name length])];
    
    [mutableAttr appendAttributedString:attrStr];
    [mutableAttr appendAttributedString:[self p_matchEmojWithString:self.model.content]];
    
    self.chatContentLabel.attributedText = [mutableAttr copy];
}

/**
 显示“欢迎进入直播间的用户”
 
 @prama name 进入直播间的用户昵称
 */
- (void) updateWelcomeSignWithName:(NSString *) name
{
    name = name ?:@"";
    NSString *welcomeSign = [NSString stringWithFormat:@"欢迎 %@ 来到主播直播间",name];
    //创建NSMutableAttributedString
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:welcomeSign attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:self.fontSize]}];
    
    //添加文字颜色
    [attrStr addAttribute:NSForegroundColorAttributeName value:ColorWithHexValue(@"ff9800") range:NSMakeRange(0, [welcomeSign length])];
    
    self.chatContentLabel.attributedText = attrStr;
    
}


#pragma  mark - Private Method
- (UIImage *) p_fetchEmojiWithName:(NSString *) emojiName
{
    if (![self p_existsEmoji]) {
        return nil;
    }
    
    NSString *path = [NSString stringWithFormat:@"%@/Documents/qygl_emoj",NSHomeDirectory()];
    NSString *name = [NSString stringWithFormat:@"/%@.png",emojiName];
    NSString *imageFilePath = [path stringByAppendingPathComponent:name];
    NSData *imageData = [NSData dataWithContentsOfFile:imageFilePath options:0 error:nil];
    return [UIImage imageWithData:imageData];
}

- (BOOL) p_existsEmoji
{
    NSString *filePath = [NSString stringWithFormat:@"%@/Documents/qygl_emoj",NSHomeDirectory()];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:filePath]) {
//        [QYGLUnzipEmoj downloadZIPEmoj:^(NSString *error){
//            if (error) {
//                NSLog(@"加载表情错误%@",error);
//            }
//        }];
        return NO;
    }
    
    return YES;
}

/*
 这里的代码写的这么辣鸡
 不知道什么时候能回来改掉
 **/
- (NSAttributedString *) p_matchEmojWithString:(NSString *) content
{
    
    content = [content description] ?:@"";
    if (![self p_existsEmoji]) {
        return [[NSAttributedString alloc] initWithString:content];
    }
    
    
    NSInteger decreaseLength = 0;
    NSMutableString *mutableString = [content mutableCopy];
    
    NSMutableAttributedString *mutableAttr = [self p_createAttributedStringWithString:content fontColor:ColorWithHexValue(@"333333")];
    
    //匹配表情
    NSError *error;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\[+[a-z]+\\]" options:0 error:&error];
    
    if (regex != nil) {
//        NSTextCheckingResult *firstMatch=[regex firstMatchInString:content options:0 range:NSMakeRange(0, [content length])];
        NSArray *matchs = [regex matchesInString:content options:0 range:NSMakeRange(0, [content length])];
        for (NSTextCheckingResult *resultMatch in matchs) {
            NSRange resultRange = [resultMatch rangeAtIndex:0];
            
            
            //从urlString当中截取数据
            NSString *result=[content substringWithRange:resultRange];
            
            NSString *imageString = [result substringWithRange:NSMakeRange(1, result.length-2)];
            
            UIImage *image = [self p_fetchEmojiWithName:imageString];
            
            NSAttributedString *attrEmoj = nil;
            
            if (image) {
                attrEmoj = [self p_createAttrStringWithEmoj:image];
            } else {
                attrEmoj = [[NSAttributedString alloc] initWithString:result];
            }
            
            NSRange replaceRange = NSMakeRange(resultRange.location-(decreaseLength), resultRange.length);
            NSInteger length = mutableAttr.length;
            [mutableAttr replaceCharactersInRange:replaceRange withAttributedString:attrEmoj];
            decreaseLength += length - mutableAttr.length;
        }
        
    }
    
    return mutableAttr;
}

- (void) p_updateUIWithBaseType
{
    NSString *message = self.model.content;
    
    //创建NSMutableAttributedString
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:message attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:self.fontSize]}];
    
    //添加文字颜色
    [attrStr addAttribute:NSForegroundColorAttributeName value:ColorWithHexValue(@"ff9800") range:NSMakeRange(0, [message length])];
    
    self.chatContentLabel.attributedText = attrStr;
}

/**
 弹幕状态信息
 */
- (void) p_updateBarrageChatMessgae
{
    [self p_updateUIWithBaseType];
}

//用户等级图片
- (UIImage *) p_userLevelImage
{
    NSString *userLevel = [self.model.userLevel description];
    userLevel = userLevel ? : @"";
    
    NSInteger level = self.model.userLevel.integerValue;
    level /= 10;
    CGSize textSize = [self.model.userLevel sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:8]}];
    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"gamelive_halfscreen_chat_tab_level%d",++level]];
    return [QYGLUtil textToImageWithText:self.model.userLevel onImage:image textRect:CGRectMake(image.size.width/2, (image.size.height-textSize.height)/2, textSize.width, textSize.height) textColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:8]];
}

- (void) p_updateDefaultChatMessage
{
    //用户等级
    NSMutableAttributedString *mutableAttr = [[NSMutableAttributedString alloc] init];
    
    UIImage *levelImage = [self p_userLevelImage];
    [mutableAttr appendAttributedString:[self p_creatAttrStringWithImage:levelImage withImageBounds:CGRectMake(0, -1, 26, 13)]];
    
    //创建NSMutableAttributedString
    NSString *nickName = [self.model.nickName description];
    nickName = nickName ? :@"";
    NSString *name = [nickName stringByAppendingString:@": "];
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:name attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:self.fontSize]}];
    //添加文字颜色
    [attrStr addAttribute:NSForegroundColorAttributeName value:ColorWithHexValue(@"3395fc") range:NSMakeRange(0, [name length])];
    
    [attrStr appendAttributedString:[self p_matchEmojWithString:self.model.content]];
    [mutableAttr appendAttributedString:attrStr];
    self.chatContentLabel.attributedText = [mutableAttr copy];
}

- (void) p_updateGiftChatMessage
{
//    NSString *contentString = [NSString stringWithFormat:@"%@赠送给主播%d个%@",self.model.nickName,self.model.giftCount,self.model.giftName];
    
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] init];
    
    UIImage *levelImage = [self p_userLevelImage];
    [attrStr appendAttributedString:[self p_creatAttrStringWithImage:levelImage withImageBounds:CGRectMake(0, -1, 26, 13)]];
    [attrStr appendAttributedString:[self p_createAttributedStringWithString:self.model.nickName fontColor:ColorWithHexValue(@"ff9800")]];
    
    [attrStr appendAttributedString:[self p_createAttributedStringWithString:@"赠送给主播" fontColor:ColorWithHexValue(@"333333")]];
    
    if (self.model.giftCount > 1) {
        [attrStr appendAttributedString:[self p_createAttributedStringWithString:[NSString stringWithFormat:@"%d",self.model.giftCount] fontColor:ColorWithHexValue(@"ff9800")]];
        [attrStr appendAttributedString:[self p_createAttributedStringWithString:@"个" fontColor:ColorWithHexValue(@"ff9800")]];
    }
    
    [attrStr appendAttributedString:[self p_createAttributedStringWithString:self.model.giftName fontColor:ColorWithHexValue(@"ff9800")]];
    
    [QYGLUtil loadPicWithUrl:self.model.giftImage isCache:YES  completed:^(UIImage *image) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [attrStr appendAttributedString:[self p_creatAttrStringWithGiftImage:image]];
            self.chatContentLabel.attributedText = attrStr;
        });
        
    }];
//    [self p_loadPicWithUrl:self.model.giftImage completed:^(UIImage *image) {
//       dispatch_async(dispatch_get_main_queue(), ^{
//           
//       });
//    }];
    
    //创建NSMutableAttributedString
//    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:contentString attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]}];
    
    //添加文字颜色
//    [attrStr addAttribute:NSForegroundColorAttributeName value:ColorWithHexValue(@"3395fc") range:NSMakeRange(0, [self.model.nickName length])];
//    [attrStr addAttribute:NSForegroundColorAttributeName value:ColorWithHexValue(@"333333") range:NSMakeRange(0, contentString.length-1)];
    
//    self.chatContentLabel.attributedText = attrStr;
    
}

//加载网络图片
- (void)p_loadPicWithUrl:(NSString*)imageUrl completed:(void(^)(UIImage *image)) completed
{
    if (![[SDWebImageManager sharedManager].imageCache imageFromKey:imageUrl]) {
        [[SDWebImageManager sharedManager].imageDownloader downloadImageWithURL:[NSURL URLWithString:imageUrl] options:SDWebImageAllowInvalidSSLCertificates | SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            
        } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
            if (image && imageUrl) {
                completed(image);
            }
        }];
    }
}

//指定颜色富文本
- (NSMutableAttributedString *) p_createAttributedStringWithString:(NSString *) string fontColor:(UIColor *) color
{
    string = string ?:@"";
    //创建NSMutableAttributedString
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:string attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:self.fontSize]}];
    [attrStr addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, string.length)];
    
    return attrStr;
}

- (NSAttributedString *) p_createAttrStringWithEmoj:(UIImage *) image
{
    // NSTextAttachment可以将图片转换为富文本内容
    NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
    attachment.image = image;
    attachment.bounds = CGRectMake(0, -5, 20, 20);
    // 通过NSTextAttachment创建富文本
    // 图片的富文本
    NSAttributedString *imageAttr = [NSAttributedString attributedStringWithAttachment:attachment];
    
    return imageAttr;
}

// 礼物图文混排的方法
- (NSAttributedString *) p_creatAttrStringWithGiftImage:(UIImage *) image
{
    // NSTextAttachment可以将图片转换为富文本内容
    NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
    attachment.image = image;
    attachment.bounds = CGRectMake(0, -5, 20, 20);
    // 通过NSTextAttachment创建富文本
    // 图片的富文本
    NSAttributedString *imageAttr = [NSAttributedString attributedStringWithAttachment:attachment];
    
    return imageAttr;
}

- (void) p_updateBannedChatMessage
{
    [self p_updateUIWithBaseType];
}

- (void) p_updateNewAdministrator
{
    [self p_updateUIWithBaseType];
}

- (void) p_updateHomeChatMessage
{
    NSMutableAttributedString *mutableAttr = [[NSMutableAttributedString alloc] init];
    
    [mutableAttr appendAttributedString:[self p_creatAttrStringWithImage:[UIImage imageNamed:@"gamelive_halfscreen_tab_administrator"] withImageBounds:CGRectMake(0, -1, 13, 13)]];
    [mutableAttr appendAttributedString:[[NSAttributedString alloc] initWithString:@" "] ];
    //等级
    [mutableAttr appendAttributedString:[self p_creatAttrStringWithImage:[self p_userLevelImage] withImageBounds:CGRectMake(0, -1, 26, 13)]];
    
    [self updateChatContentWithName:[self.model.nickName stringByAppendingString:@":"] chatContent:self.model.content mutableAttr:mutableAttr];
}

- (void) p_updateAnchorChatMessage
{
    NSMutableAttributedString *mutableAttr = [[NSMutableAttributedString alloc] init];
    
    [mutableAttr appendAttributedString:[self p_creatAttrStringWithImage:[UIImage imageNamed:@"gamelive_halfscreen_tab_anchor"] withImageBounds:CGRectMake(0, -1, 13, 13)]];
    [mutableAttr appendAttributedString:[[NSAttributedString alloc] initWithString:@" "]];
    //等级
    [mutableAttr appendAttributedString:[self p_creatAttrStringWithImage:[self p_userLevelImage] withImageBounds:CGRectMake(0, -1, 26, 13)]];
    [self updateChatContentWithName:[self.model.nickName stringByAppendingString:@":"] chatContent:self.model.content mutableAttr:mutableAttr];
}

- (void) p_updateUIWithModel
{
    switch (self.model.cellType) {
        case QYGLChatCellTextTypeBarrage:
            [self p_updateBarrageChatMessgae];
            break;
            
        case QYGLChatCellTextTypeDefault:
            [self p_updateDefaultChatMessage];
            break;
            
        case QYGLChatCellTextTypeGift:
            [self p_updateGiftChatMessage];
            break;
        case QYGLChatCellTextTypeBanned:
            [self p_updateBannedChatMessage];
            break;
            
        case QYGLChatCellTextTypeHome:
            [self p_updateHomeChatMessage];
            break;
            
        case QYGLChatCellTextTypeAnchor:
            [self p_updateAnchorChatMessage];
            break;
        case QYGLChatCellTextTypeNewAdministrator:
            [self p_updateNewAdministrator];
            break;
            
        default:
            break;
    }
    
}

// 实现图文混排的方法
- (NSAttributedString *) p_creatAttrStringWithImage:(UIImage *) image withImageBounds:(CGRect) bounds
{
    // NSTextAttachment可以将图片转换为富文本内容
    NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
    attachment.image = image;
    attachment.bounds = bounds;
    
    // 通过NSTextAttachment创建富文本
    // 图片的富文本
    NSAttributedString *imageAttr = [NSAttributedString attributedStringWithAttachment:attachment];
    
    return imageAttr;
}

#pragma  mark - getter / setter
- (UILabel *) chatContentLabel
{
    if (!_chatContentLabel) {
        _chatContentLabel = [UILabel new];
        _chatContentLabel.font = [UIFont systemFontOfSize:14];
    }
    return _chatContentLabel;
}

- (void) setModel:(QYGLChatModel *)model
{
    _model = model;
    
    [self p_updateUIWithModel];
}

@end
