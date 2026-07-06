# Docker DevTools — Image optimisation (PowerShell)
# Not sourced automatically; source explicitly if needed:
#   . "$HOME/.docker-devtools/images/docker-image-devtools.ps1"

# jpegtran-docker — usage: jpegtran-docker -copy none -arithmetic Image.jpg > Image-opt.jpg
function jpegtran-docker { Invoke-DockerAlias /images datawraith/mozjpeg jpegtran @args }
