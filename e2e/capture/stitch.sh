#!/bin/sh
# Puts each scene's desk and phone recordings side by side and makes a GIF
# for the README. Run from e2e/ after `npx playwright test -c capture.config.ts`.
set -e
cd "$(dirname "$0")/../videos"
mkdir -p ../../docs/media
for scene in desk-to-phone offline-sync; do
  [ -f "$scene-desk.webm" ] || continue
  ffmpeg -y -loglevel error -i "$scene-desk.webm" -i "$scene-phone.webm" -filter_complex \
    "[0:v]scale=-2:844,fps=30[d];[1:v]scale=-2:844,fps=30[p];[d][p]hstack=inputs=2[v]" \
    -map "[v]" -c:v libx264 -pix_fmt yuv420p -r 30 "$scene.mp4"
  ffmpeg -y -loglevel error -i "$scene.mp4" -vf "fps=12,scale=1200:-2:flags=lanczos,split[a][b];[a]palettegen=max_colors=96[p];[b][p]paletteuse=dither=bayer:bayer_scale=4" \
    "../../docs/media/$scene.gif"
  echo "made docs/media/$scene.gif"
done
