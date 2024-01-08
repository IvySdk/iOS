#!/bin/bash
mkdir -p conf_decrypt
for filename in `ls conf`
do
  if [[ $filename =~ "sdk_cg" ]]
  then
    echo "跳过 $filename"
  else
    basefilename=$(echo $filename | sed 's/\..*$//')
    echo "解密：$filename 到conf_decrypt/$basefilename.txt"
    python2 tool.py d conf/$filename conf_decrypt/$basefilename.txt
    jsonlint conf_decrypt/$basefilename.txt>tmp
    mv tmp conf_decrypt/$basefilename.txt
  fi
done
