//
//  QYGLUtil.m
//  QiYiVideo
//
//  Created by lixu on 2017/4/18.
//  Copyright © 2017年 QiYi. All rights reserved.
//

#import "QYGLUtil.h"
#import <QYToastView.h>
#import <CoreText/CoreText.h>


@implementation QYGLUtil

//创建图片的富文本
+ (NSAttributedString *) p_createAttributedStringWithImage:(UIImage *) image
                                                withBounds:(CGRect) bounds
{
    if (image && [image isKindOfClass:[UIImage class]]) {
        // NSTextAttachment可以将图片转换为富文本内容
        NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
        attachment.image = image;
        attachment.bounds = bounds;
        // 通过NSTextAttachment创建富文本
        // 图片的富文本
        NSAttributedString *imageAttr = [NSAttributedString attributedStringWithAttachment:attachment];
        
        return imageAttr;
    } else {
        return [[NSAttributedString alloc] init];
    }
    
}

//创建富文本
+ (NSAttributedString *) createAttributedStringWithString:(NSString *) string
                                                textColor:(UIColor *) color
                                                     font:(UIFont *) font
{
    string = string ?:@"";
    //创建NSMutableAttributedString
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:string attributes:@{NSFontAttributeName:font}];
    [attrStr addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, string.length)];
    
    return attrStr;
}

//整数以万为单位转换
+ (NSString *) intergerUnitConverterToTenThousand:(NSString *) numberString
{
    if (![self isdigitWithString:numberString]) {
        return @"0";
    }
    
    NSInteger number = numberString.integerValue;
    
    numberString = @"0";
    if (number < 10000 && number > 0) {
        numberString = [NSString stringWithFormat:@"%d",number];
    } else if (number >= 10000) {
        CGFloat num = (CGFloat)number / 10000;
        numberString = [NSString stringWithFormat:@"%.1f%@",num,@"万"];
    }
    
    return numberString;
}

+ (NSString *) qiDianBalanceConvertQiDian:(NSString *) qiDianBalance
{
    qiDianBalance = [qiDianBalance description];
    CGFloat qiDian = [qiDianBalance doubleValue] / 100;
    return [NSString stringWithFormat:@"%f",qiDian];
}

+ (BOOL) isdigitWithString:(NSString *) string
{
    NSString *result = [string stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
    if(result.length) {
        return NO;
    }
    
    return YES;
}

//加载网络图片
+ (void) loadPicWithUrl:(NSString*)imageUrl
                isCache:(BOOL) cache
              completed:(void(^)(UIImage *image)) completed
{
    imageUrl = [self checkHTTPSWithUrl:imageUrl];
    if (![[SDWebImageManager sharedManager].imageCache imageFromMemoryCacheForKey:imageUrl]) {
        [[SDWebImageManager sharedManager].imageDownloader downloadImageWithURL:[NSURL URLWithString:imageUrl] options:SDWebImageAllowInvalidSSLCertificates | SDWebImageRetryFailed | SDWebImageCacheMemoryOnly progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            
        } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
            if (image && imageUrl) {
                if (cache) {
                    [SDWebImageManager sharedManager].imageCache.shouldCacheImagesInMemory = YES;
                }
                
                [[SDWebImageManager sharedManager].imageCache storeImage:image forKey:imageUrl toDisk:NO];
                if (cache) {
                    [SDWebImageManager sharedManager].imageCache.shouldCacheImagesInMemory = NO;
                }
                completed(image);
            }
        }];
    } else {
        UIImage *image = [[SDWebImageManager sharedManager].imageCache imageFromMemoryCacheForKey:imageUrl];
        completed(image);
    }
}

+ (NSString *) checkHTTPSWithUrl:(NSString *) urlString
{
    urlString = [urlString description];
    
    if ([urlString hasPrefix:@"http://"]) {
        NSMutableString *url = urlString.mutableCopy;
        NSRange range = [url rangeOfString:@"http"];
        [url replaceCharactersInRange:range withString:@"https"];
        return url;
    }
    
    return urlString;
}

+ (void) defaultToast:(NSString *) message
{
    [QYToastView showToastWithMessage:message superView:[UIApplication sharedApplication].keyWindow bottom:[UIApplication sharedApplication].keyWindow.bounds.size.height/2 textAlignment:NSTextAlignmentCenter autoHide:YES];
}

//数字格式化,最后一位如果不是有效数字则剔除
+ (NSString *) numberFormatterWithNumber:(CGFloat) number
{
    NSString *numberString = [NSString stringWithFormat:@"%.2f",number];
    if ([numberString hasSuffix:@"0"]) {
        numberString = [numberString stringByReplacingCharactersInRange:NSMakeRange(numberString.length-1, 1) withString:@""];
    }
    
    if ([numberString hasSuffix:@"0"]) {
        numberString  = [NSString stringWithFormat:@"%d",(NSInteger)number];
    }
    
    return numberString;
}

+ (NSString *)stringFromTimeInterval:(NSTimeInterval)interval {
    NSInteger ti = (NSInteger)interval;
    NSInteger seconds = ti % 60;
    NSInteger minutes = (ti / 60) % 60;
    return [NSString stringWithFormat:@"%02ld:%02ld",(long)minutes, (long)seconds];
}

//用户等级
+ (UIImage*) drawText:(NSString*) text
             inImage:(UIImage*)  image
             atPoint:(CGPoint)   point
           textColor:(UIColor *) color
                font:(UIFont *) font
{
    
    UIGraphicsBeginImageContext(image.size);
    [image drawInRect:CGRectMake(0,0,image.size.width,image.size.height)];
    CGRect rect = CGRectMake(point.x, point.y, image.size.width, image.size.height);
    [[UIColor whiteColor] set];
    NSDictionary *att = @{NSFontAttributeName:font,NSForegroundColorAttributeName:color};
    [text drawInRect:CGRectIntegral(rect) withAttributes:att];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

//coretext的效果好但是不能在等级的图片上写文字(我也不知道为什么),暂时没有找到效果好一些的办法
+ (UIImage *) textToImageWithText:(NSString*) text
                          onImage:(UIImage*) image
                         textRect:(CGRect) rect
                        textColor:(UIColor *) color
                             font:(UIFont *) font
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    imageView.image = image;
    UILabel *label = [[UILabel alloc] initWithFrame:rect];
    label.textColor = color;
    label.text = text;
    label.font = font;
    [imageView addSubview:label];
    UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, imageView.opaque, 0.0);
    [imageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
}

@end
