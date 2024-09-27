variable "OWNER" {
  default = "opslabhq"
}

variable "FILE" {
  default = "alpine-ci"
}

variable "TAG" {
  default = "latest"
}

group "default" {
  targets = ["build-docker"]
}

target "settings" {
  context = "."
  cache-from = [
    "type=gha"
  ]
  cache-to = [
    "type=gha,mode=max"
  ]
}

target "test" {
  inherits = ["settings"]
  platforms = [
    "linux/amd64",
    "linux/arm64",
  ]
  tags = []
}

target "build" {
  inherits = ["settings"]
  output   = ["type=docker"]
  tags = [
    "ghcr.io/${OWNER}x/${FILE}",
    "ghcr.io/${OWNER}x/${FILE}:${TAG}",
    "${OWNER}/${FILE}:${TAG}",
    "${OWNER}/${FILE}",
  ]
}

target "push" {
  inherits = ["settings"]
  output   = ["type=registry"]
  platforms = [
    "linux/amd64",
    "linux/arm64",
  ]
  tags = [
    "ghcr.io/${OWNER}x/${FILE}",
    "ghcr.io/${OWNER}x/${FILE}:${TAG}",
    "${OWNER}/${FILE}:${TAG}",
    "${OWNER}/${FILE}",
  ]
}

target "push-rootless" {
  inherits = ["settings"]
  output   = ["type=registry"]
  platforms = [
    "linux/amd64",
    "linux/arm64",
  ]
  tags = [
    "ghcr.io/${OWNER}x/${FILE}:rootless",
    "ghcr.io/${OWNER}x/${FILE}:${TAG}-rootless",
    "${OWNER}/${FILE}:${TAG}-rootless",
    "${OWNER}/${FILE}:rootless",
  ]
  dockerfile = "./Dockerfile.rootless"
}
