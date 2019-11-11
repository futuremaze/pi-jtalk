#!/bin/bash

# bashのスイッチ
set -euC

# カレントディレクトリの移動
cd $(dirname $0)

# 外部スクリプトのsource
# source ./setting.inc

# グローバル定数
readonly INSTALL_DIR="/usr/share/pi-jtalk"
readonly TEMP_DIR="$(mktemp -d pi-jtalk.XXXXXXXX)"

#
# 関数定義
#

function cleanup() {
  if [[ -n "$TEMPFILE" && -e "$TEMPFILE" ]]; then
    mv -n "$TEMPFILE" ~/.trash/  # 消さずにゴミ箱フォルダに移動
  fi
}

function main() {
  # 必要パッケージのダウンロード
  sudo apt-get install -y \
    open-jtalk \
    open-jtalk-mecab-naist-jdic \
    hts-voice-nitech-jp-atr503-m001

  # 音響モデル(mei)のダウンロード
  wget https://sourceforge.net/projects/mmdagent/files/MMDAgent_Example/MMDAgent_Example-1.7/MMDAgent_Example-1.7.zip \
    --no-check-certificate \
    -o ${TEMP_DIR}/MMDAgent_Example-1.7.zip
  cd ${TEMP_DIR}
  unzip MMDAgent_Example-1.7.zip
  sudo cp -R ./MMDAgent_Example-1.7/Voice/mei /usr/share/hts-voice/

  # 発話スクリプトのインストール
  sudo mkdir -p ${INSTALL_DIR}
  sudo cp -R ./bin ${INSTALL_DIR}/
  sudo chmod 755 ${INSTALL_DIR}/bin/*.sh
}

# エントリー処理
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  main
fi
