#!/bin/bash

# README
#
# 该脚本用于将指定的文件内容上传至 GitHub Gist。
#
# 使用方法：
#   path/to/upload-to-gist.sh <FILE_PATH> <TOKEN> [GIST_ID] [FILENAME]
#
# 参数说明：
#   - FILE_PATH：要上传文件的绝对路径。
#   - TOKEN：GitHub 个人访问令牌（Personal Access Token），用于进行身份验证。
#   - GIST_ID：Gist 的唯一标识符。如果留空，则创建一个新的 Gist。
#   - FILENAME：要上传的文件名。如果留空，则从 FILE_PATH 中提取。

# 禁用 proxy
unset http_proxy https_proxy all_proxy

# 安装依赖
curl -x "" -o apt-get-update.sh https://ghproxy.cianogame.top/https://raw.githubusercontent.com/CianoLiu/shell-cloud/main/apt-get-update.sh
chmod +x apt-get-update.sh
./apt-get-update.sh
apt-get install -y jq
# 删除脚本文件
rm apt-get-update.sh

# 文件绝对路径
FILE_PATH="$1"
# GitHub personal access token，替换为自己的
TOKEN="$2"
# Gist ID，替换为自己的，或者留空表示创建一个新的 Gist
GIST_ID="$3"
# 文件名
FILENAME="$4"

# 检查是否提供了文件路径参数
if [ -z "$FILE_PATH" ]; then
    echo "未提供文件路径参数 FILE_PATH"
    exit 1
fi

# 检查文件是否存在
if [ ! -f "$FILE_PATH" ]; then
    echo "文件 $FILE_PATH 不存在"
    exit 1
fi

# 如果未提供文件名参数，则从 FILE_PATH 中提取
if [ -z "$FILENAME" ]; then
    FILENAME=$(basename "$FILE_PATH")
fi

# 将文件内容转换为纯文本字符串
string_content=$(jq -Rs '.' < "$FILE_PATH")

# 构造请求体
gist_data="{\"files\": {\"$FILENAME\": {\"content\": $string_content}}}"

# 发送请求
response=$(curl -s -H "Authorization: token ${TOKEN}" -H "Accept: application/vnd.github+json" -X PATCH -d "$gist_data" "https://api.github.com/gists/${GIST_ID}")

# 检查是否成功上传至 Gist
if [ "$(echo "$response" | jq -r '.message')" != "null" ]; then
    echo "上传至 Gist 失败: $(echo "$response" | jq -r '.message')"
    exit 1
fi

# 解析响应获取 Gist 链接
GIST_URL=$(echo "$response" | jq -r '.html_url')

echo "已更新的 Gist: $GIST_URL"
