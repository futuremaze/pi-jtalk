#!/bin/bash
#
# 音声発話スクリプト
# 
# 引数で指定された日本語の文字列を発話する.

# bashのスイッチ
set -euC

# グローバル変数
CONTENT=
TEMPFILE=

#
# 引数parse処理
#

function usage() {
  # パラメータの詳細を必ず明記すること
  cat <<EOS >&2
Usage: $0 発話文章
  発話文章      発話させる日本語文章
EOS
  exit 1
}

# 引数のパース
function parse_args() {
  CONTENT=${1:-}

  if [[ "${CONTENT}" == "" ]]; then
    usage
  fi
}

#
# 関数定義
#

function cleanup() {
  if [[ -n "$TEMPFILE" && -e "$TEMPFILE" ]]; then
    rm -f ${TEMPFILE}
  fi
}

function main() {
  local TEMPFILE=$(tempfile)
  local option="-m /usr/share/hts-voice/mei/mei_normal.htsvoice \
                -x /var/lib/mecab/dic/open-jtalk/naist-jdic \
                -ow $TEMPFILE"
 
  echo "${CONTENT}" | open_jtalk $option
  aplay -q $TEMPFILE
  rm $TEMPFILE
}

trap cleanup EXIT

# エントリー処理
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  parse_args "$@"
  main
fi
