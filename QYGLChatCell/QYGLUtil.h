//
//  QYGLUtil.h
//  QiYiVideo
//
//  Created by lixu on 2017/4/18.
//  Copyright © 2017年 QiYi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface QYGLUtil : NSObject

//用图片创建富文本
+ (NSAttributedString *) p_createAttributedStringWithImage:(UIImage *) image
                                                withBounds:(CGRect) bounds;
//创建富文本的快捷方式
+ (NSAttributedString *) createAttributedStringWithString:(NSString *) string
                                                textColor:(UIColor *) color
                                                     font:(UIFont *) font;

//检查字符串是否为正整数
+ (BOOL) isdigitWithString:(NSString *) string;

//后台返回的用户余额为分(1分钱为单位)，需要转换为奇点
+ (NSString *) qiDianBalanceConvertQiDian:(NSString *) qiDianBalance;

//整数以万为单位转换
+ (NSString *) intergerUnitConverterToTenThousand:(NSString *) numberString;

//加载网络图片,cache是否缓存，
+ (void) loadPicWithUrl:(NSString*)imageUrl
                isCache:(BOOL) cache
              completed:(void(^)(UIImage *image)) completed;

//检查https，如果是http则返回一个https
+ (NSString *) checkHTTPSWithUrl:(NSString *) urlString;

//toast
+ (void) defaultToast:(NSString *) message;

//数字格式化,最后一位如果不是有效数字则剔除
+ (NSString *) numberFormatterWithNumber:(CGFloat) number;

//文字写在图片上
+ (UIImage*) drawText:(NSString*) text
              inImage:(UIImage*)  image
              atPoint:(CGPoint)   point
            textColor:(UIColor *) color
                 font:(UIFont *) font;

//暂时的文字写在图片上,这种笨办法效果比较好
+ (UIImage *) textToImageWithText:(NSString*) text
                          onImage:(UIImage*) image
                         textRect:(CGRect) rect
                        textColor:(UIColor *) color
                             font:(UIFont *) font;

//秒数转化成MM:SS格式
+ (NSString *)stringFromTimeInterval:(NSTimeInterval)interval;
@end
