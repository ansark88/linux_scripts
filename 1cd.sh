#!/bin/bash
#knoppix edu7 1CDイメージ編集用スクリプト

#ディレクトリ作成
makedir(){
echo "編集先ディレクトリを作成します。"
mount /dev/$hd /mnt/$hd
mkdir -p /mnt/$hd/edu7/source/KNOPPIX
mkdir -p /mnt/$hd/edu7/master/KNOPPIX/KNOPPIX
menu
}

#コピー
copyimage(){
cp -Rpv /KNOPPIX/* $source/KNOPPIX
cp -Rpv /cdrom/KNOPPIX/* $master/KNOPPIX/KNOPPIX
cp -Rpv /cdrom/*.* $master/KNOPPIX
cp -Rpv /cdrom/boot $master/KNOPPIX
menu
}

#cloop圧縮
cloopiso() {
	echo "CDのイメージ名を入力してください"
	read cdimage
#isoイメージ作成
	echo "出力するisoイメージのファイル名(拡張子不要)を入力してください"
	read isoimage
	echo isoイメージは　"/mnt/$hd/$isoimage.isoとして出力されます。"
	cd $master/KNOPPIX
	mkisofs -R -L -V "$cdimage" -hide-rr-moved -v $source/KNOPPIX | create_compressed_fs - 65536 > $master/KNOPPIX/KNOPPIX/KNOPPIX
	mkisofs -pad -l -r -J -V "$cdimage" -b boot/isolinux/isolinux.bin -c boot/isolinux/boot.cat -hide-rr-moved -no-emul-boot -boot-load-size 4 -boot-info-table -o /mnt/$hd/$isoimage.iso $master/KNOPPIX
  menu
}

menu(){
echo ">>行いたい操作の番号を入力してください"
echo "[1] 編集先ディレクトリの作成"
echo "[2] CDイメージのコピー"
echo "[3] cloop圧縮→isoイメージ作成"
echo "[9] スクリプトの終了"
read actionnum

#case
# *)でそれ以外にマッチ、exitでスクリプト終了
case $actionnum in 
	1)
	makedir
	;;
	2)
	copyimage
	;;
	3)
	cloopiso
	;;
	9)
	exit
	;;
	*)
	menu
	;;
esac
}

echo "これはedu7ディスクイメージ編集スクリプトです。(ctrl+cで強制終了)"
test "root" = `whoami`  || echo "rootではありません。rootでやり直して下さい。"
test "root" = `whoami`  || exit
echo "edu7の編集スペースとなるパーティションを指定してください(例:hda3)"
read hd
source=/mnt/$hd/edu7/source
master=/mnt/$hd/edu7/master
menu
