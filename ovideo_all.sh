#!/bin/bash
# 一条龙：auto_pipeline（完整跑完）→ Downie_transfer.scpt

PY="/Library/Frameworks/Python.framework/Versions/Current/bin/python3"
PIPELINE="/Users/yanzhang/Coding/python_code/OVideo/auto_pipeline.py"
TRANSFER="/Users/yanzhang/Coding/ScriptEditor/Downie_transfer.scpt"

echo "========== [1/2] auto_pipeline 开始 =========="
"$PY" "$PIPELINE" --skip-sxkljc --skip-312f
RC=$?
echo "========== auto_pipeline 结束，退出码 $RC =========="

# 退出码含义：0=全部完成  1=致命错误  2=完成但有补全失败
# 0 和 2 都视为"流水线已跑完"，继续执行转存；1 则中止
if [ "$RC" -eq 0 ] || [ "$RC" -eq 2 ]; then
    echo "========== [2/2] Downie_transfer 开始 =========="
    osascript "$TRANSFER"
    echo "========== Downie_transfer 结束，退出码 $? =========="
else
    echo "❌ auto_pipeline 致命错误（退出码 $RC），跳过 Downie_transfer"
    osascript -e 'display notification "auto_pipeline 异常，已跳过转存" with title "一条龙"'
    exit 1
fi
