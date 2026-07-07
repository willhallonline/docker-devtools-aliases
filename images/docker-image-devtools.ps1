# Docker DevTools — Image optimisation (PowerShell)
# Not sourced automatically; source explicitly if needed:
#   . "$HOME/.docker-devtools/images/docker-image-devtools.ps1"

# jpegtran-docker — usage: jpegtran-docker -copy none -arithmetic Image.jpg > Image-opt.jpg
function jpegtran-docker { Invoke-DockerAlias /images datawraith/mozjpeg jpegtran @args }

# ImageMagick — conversion, resizing, and general image manipulation
# magick-docker  — usage: magick-docker input.jpg -resize 50% output.jpg
# convert-docker — usage: convert-docker input.png -resize 200x200 output.png (deprecated alias for magick)
# mogrify-docker — usage: mogrify-docker -resize 800x600 -format png *.jpg (in-place batch conversion)
# identify-docker — usage: identify-docker input.jpg
function magick-docker { Invoke-DockerAlias /imgs dpokidov/imagemagick:latest @args }
function convert-docker { Invoke-DockerAlias /imgs dpokidov/imagemagick:latest @args }
function mogrify-docker { Invoke-DockerAlias /imgs dpokidov/imagemagick:latest --entrypoint mogrify @args }
function identify-docker { Invoke-DockerAlias /imgs dpokidov/imagemagick:latest --entrypoint identify @args }

# libvips — fast, low-memory thumbnailing and resizing
# vipsthumbnail-docker — usage: vipsthumbnail-docker input.jpg --size 200x200 -o output.jpg
function vipsthumbnail-docker { Invoke-DockerAlias /images marcbachmann/libvips:latest --entrypoint vipsthumbnail @args }

# WebP — conversion to/from the WebP format
# cwebp-docker — usage: cwebp-docker input.png -o output.webp
# dwebp-docker — usage: dwebp-docker input.webp -o output.png
function cwebp-docker { Invoke-DockerAlias /images takecy/webp:latest --entrypoint cwebp @args }
function dwebp-docker { Invoke-DockerAlias /images takecy/webp:latest --entrypoint dwebp @args }
