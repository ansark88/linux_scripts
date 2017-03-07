#!/bin/bash
#qucsのフォントサイズ変更補助スクリプト

#/etc/skel以下のqucsrcをホームフォルダにコピー
cd $HOME
mkdir .qucs
cp /etc/skel/.qucs/qucsrc $HOME/.qucs/qucsrc
qrc=$HOME/.qucs/qucsrc

#echo qucsのフォントサイズを入力してください
fontsize=`kdialog --inputbox "qucsのフォントサイズを入力して下さい"　"デフォルトサイズ12"`
sed -i -e "s/Helvetica,12/Helvetica,$fontsize/" $qrc
#echo qucsを再起動してください。
kdialog --title "qucsの再起動" --msgbox "qucsを再起動して下さい(編集ファイルは保存して下さい)"
