#import <UIKit/UIKit.h>

//表情列表
//新版表情前缀
#define kNewFacePreCode 0xd83d
#define kNewFacePreCode2 0xd83c
#define FACE_NUM    60//133
#define FACE_NUM_O  85 

typedef struct face
{
    const char *facename;
    const char *newfaceCode;     // 3.8.2 最新表情编码
    const char *readyfaceCode;   // 3.8.5 自定义表情编码
}Tface,*Ptface;

extern const Tface g_faceTable[];

@interface NSString (NSStringUtils)
- (NSString*)encodeAsURIComponent;
- (NSString*)escapeHTML;
- (NSString*)unescapeHTML;
+ (NSString*)localizedString:(NSString*)key;
+ (NSString*)base64encode:(NSString*)str;

// 发送之前将表情转化为字符串
//+ (void) FilterFaceCodeSend:(NSMutableString*)strMsgContent;
// 通过表情编码找到表情文件名(只支持自定义表情)
+ (NSString *)fileNameWithFaceCode:(NSString *)strCode;
@end


