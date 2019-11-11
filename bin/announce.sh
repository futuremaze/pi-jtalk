#!/bin/bash
#
# 音声発話スクリプト
# 
# 引数で指定された日本語の文字列を発話する.
# 発話の前に, ../wav/chime.wav を再生する.
# 発話は ./say.sh に引数を渡して実行する.

# bashのスイッチ
set -euC

# スクリプトがあるディレクトリに移動
cd $(dirname $0)

# グローバル定数
readonly CHIME_WAV="../wav/chime.wav"

function main() {
  aplay -q ${CHIME_WAV}
  ./say.sh "$@"
}

# エントリー処理
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  main "$@"
fi