#!/bin/bash

# bashのスイッチ
set -euC

# カレントディレクトリの移動
cd $(dirname $0)

# 外部スクリプトのsource
# source ./setting.inc

# グローバル定数
readonly INSTALL_DIR="/usr/share/pi-jtalk"
readonly MMDAGENT_URL="https://sourceforge.net/projects/mmdagent/files/MMDAgent_Example/MMDAgent_Example-1.7"
readonly MMDAGENT_FILENAME="MMDAgent_Example-1.7.zip "

#
# 関数定義
#

function cleanup() {
  rm -rf ./MMDAgent*
}

function main() {
  # 必要パッケージのダウンロード
  sudo apt-get install -y \
    open-jtalk \
    open-jtalk-mecab-naist-jdic \
    hts-voice-nitech-jp-atr503-m001

  # 音響モデル(mei)のダウンロード
  wget ${MMDAGENT_URL}/${MMDAGENT_FILENAME} \
    --no-check-certificate
  unzip MMDAgent_Example-1.7.zip
  sudo cp -R ./MMDAgent_Example-1.7/Voice/mei /usr/share/hts-voice/

  # 発話スクリプトのインストール
  sudo mkdir -p ${INSTALL_DIR}
  sudo cp -R ./bin ${INSTALL_DIR}/
  sudo chmod 755 ${INSTALL_DIR}/bin/*.sh
}

# EXIT時にcleanup実行
trap cleanup EXIT

# エントリー処理
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  main
fi
