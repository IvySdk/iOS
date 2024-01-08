#!/bin/bash
mkdir -p conf
for filename in `ls conf_decrypt`
do
  if [[ $filename =~ "sdk_cg" ]]
  then
    echo "跳过 $filename"
  else
    basefilename=$(echo $filename | sed 's/\..*$//')
    echo "加密：$filename 到conf/$basefilename.json"
    jsonlint conf_decrypt/$filename>tmp
    mv tmp conf_decrypt/$filename
    python2 tool.py e conf_decrypt/$filename conf/$basefilename.json
  fi
done
