#ifndef VCTRLER_H
#define VCTRLER_H

#include <QQmlApplicationEngine>

enum dialogType
{
    // 提示对话框
    DIALOG_TIP = 0,
    // 消息对话框
    DIALOG_MESSAGE = 1,
    // 错误对话框
    DIALOG_ERROR = 2,
    // 自定义对话框
    DIALOG_CUSTOM = 3,
};

/// @brief 对话框按钮类型
enum dialogBtnType
{
    // 确定取消对话框
    DIALOG_OK_CANCEL = 0,
    // 是否对话框
    DIALOG_YES_NO = 1,
    // 单一确定对话框
    DIALOG_OK = 2,
};
/// @brief 对话框结果
enum dialogResult
{
    // 取消
    RESULT_CANCEL = 0,
    // 确定
    RESULT_OK = 1,
    // 是
    RESULT_YES = 2,
    // 否
    RESULT_NO = 3,
    // 异常
    RESULT_EXCEPTION = 4,
};

/// @brief 界面控制器
/// @details 用于控制界面的显示
class vctrler : public QObject
{
    Q_OBJECT;

public:
    /// @brief 设置QML引擎
    static void setEngine();

    /// @brief  显示对话框
    /// @param type 对话框类型
    /// @param title 标题
    /// @param content 内容
    /// @return 对话框结果
    static dialogResult showDialog(dialogType type, dialogBtnType btntype, QString title, QString content, QString customtype);

private:
    static QQmlApplicationEngine *m_engine;
};

#endif // VCTRLER_H
