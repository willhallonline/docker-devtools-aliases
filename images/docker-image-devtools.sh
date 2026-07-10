# Image Optimisation
# jpegtran-docker — usage: jpegtran-docker -copy none -arithmetic Image.jpg > Image-opt.jpg
alias jpegtran-docker="docker_alias /images datawraith/mozjpeg jpegtran"

# ImageMagick — conversion, resizing, and general image manipulation
# magick-docker  — usage: magick-docker input.jpg -resize 50% output.jpg
# convert-docker — usage: convert-docker input.png -resize 200x200 output.png (deprecated alias for magick)
# mogrify-docker — usage: mogrify-docker -resize 800x600 -format png *.jpg (in-place batch conversion)
# identify-docker — usage: identify-docker input.jpg
alias magick-docker="docker_alias /imgs dpokidov/imagemagick:latest"
alias convert-docker="docker_alias /imgs dpokidov/imagemagick:latest"
alias mogrify-docker="docker_alias /imgs dpokidov/imagemagick:latest --entrypoint mogrify"
alias identify-docker="docker_alias /imgs dpokidov/imagemagick:latest --entrypoint identify"

# libvips — fast, low-memory thumbnailing and resizing
# vipsthumbnail-docker — usage: vipsthumbnail-docker input.jpg --size 200x200 -o output.jpg
alias vipsthumbnail-docker="docker_alias /images marcbachmann/libvips:latest --entrypoint vipsthumbnail"

# WebP — conversion to/from the WebP format
# cwebp-docker — usage: cwebp-docker input.png -o output.webp
# dwebp-docker — usage: dwebp-docker input.webp -o output.png
alias cwebp-docker="docker_alias /images takecy/webp:latest --entrypoint cwebp"
alias dwebp-docker="docker_alias /images takecy/webp:latest --entrypoint dwebp"

# ExifTool — read/write image & file metadata (community image)
# usage: exiftool-docker -all= image.jpg
alias exiftool-docker="docker_alias /images kroniak/exiftool:latest"
