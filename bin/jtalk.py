#!/usr/bin/env python3
# coding: utf-8

"""音声発話スクリプト(jtalk使用)"""

import os
import sys
import subprocess
import tempfile
from aiy.voice.audio import play_wav

# グローバル定数
MODEL_PATH = "/usr/share/hts-voice/mei/mei_normal.htsvoice"
DIC_PATH = "/var/lib/mecab/dic/open-jtalk/naist-jdic"
SPEED = "0.8"
OUTPUT_FILENAME = "voice.wav"
CHIME_WAV = "../wav/chime.wav"


def announce(message):
    play_wav(CHIME_WAV)
    say(message)

def say(message):
    with tempfile.TemporaryDirectory() as tempdir:
        wav_file = os.path.join(tempdir, OUTPUT_FILENAME)
        cmd = [
            'open_jtalk',
            '-m', MODEL_PATH,
            '-x', DIC_PATH,
            '-r', SPEED,
            '-ow', wav_file
        ]

        # Create wav.
        c = subprocess.Popen(cmd, stdin=subprocess.PIPE)
        c.stdin.write(message.encode())
        c.stdin.close()
        c.wait()

        # Play wav.
        play_wav(wav_file)

if __name__ == '__main__':
    args = sys.argv
    announce(args[1])
