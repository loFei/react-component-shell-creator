#!/bin/bash
if [ -z "$1" ]; then
  echo "参数错误. createReactComponent.sh 组件名"
  exit
fi

# 拿到当前路径
curr_path=$(pwd)
echo "当前路径:${curr_path}"

# 模板路径
template_path=$(dirname $0)
cd ${template_path}
template_path=$(pwd)
echo "模板路径:${template_path}"

# 组件名首字母转大写
component_name=$1
f=`echo ${component_name} | cut -c 1`
f=`echo ${f} | tr '[:lower:]' '[:upper:]'`
name=`echo ${component_name} | cut -c 2-`
component_name=${f}${name}

# 文件注释信息
# name
author=`echo $(whoami)`
# date
create_date=`date "+%Y-%m-%d %H:%M:%S"`
# description
description=''
if [ -n "$2" ]; then
  description=$2
fi

# 复制组件模板
function copyTemplate() {
  cp ${template_path}/template/Template/Template.jsx ${curr_path}/${component_name}/${component_name}.jsx \
  && cp ${template_path}/template/Template/Template.scss ${curr_path}/${component_name}/${component_name}.scss
}

# 修改文件内容
function updateTemplate() {
  file_path=${curr_path}/${component_name}/${component_name}.jsx
  # 组件名
  sed -i "" "s/Template/${component_name}/g" ${file_path}
  # 组件注释
  sed -i "" "s/NAME/${author}/g" ${file_path}
  sed -i "" "s/DATE/${create_date}/g" ${file_path}
  if [ -n "${description}" ]; then
    sed -i "" "s/DESCRIPTION/${description}/g" ${file_path}
  else
    sed -i "" "s/DESCRIPTION//g" ${file_path}
  fi
}

# 复制模板
if [ -d "${curr_path}/${component_name}" ]; then
  echo "组件创建失败,已存在${component_name}目录"
else
  mkdir ${curr_path}/${component_name} \
  && copyTemplate \
  && updateTemplate \
  && echo "组件: ${component_name} 创建完成"
fi
