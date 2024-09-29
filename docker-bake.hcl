variable "OWNER" {
  default = "opslabhq"
}

variable "GROUP" {
  default = "ci"
}

variable "FILE" {
  default = "alpine"
}

variable "TAG" {
  default = "latest"
}

group "default" {
  targets = ["build"]
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
    "${OWNER}/${FILE}-${GROUP}",
    "${OWNER}/${FILE}-${GROUP}:${TAG}",
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
    "${OWNER}/${FILE}-${GROUP}",
    "${OWNER}/${FILE}-${GROUP}:${TAG}",
    "ghcr.io/${OWNER}x/${FILE}-${GROUP}",
    "ghcr.io/${OWNER}x/${FILE}-${GROUP}:${TAG}",
    "public.ecr.aws/${OWNER}/${GROUP}/${FILE}",
    "public.ecr.aws/${OWNER}/${GROUP}/${FILE}:${TAG}",
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
    "${OWNER}/${FILE}-${GROUP}:rootless",
    "${OWNER}/${FILE}-${GROUP}:${TAG}-rootless",
    "ghcr.io/${OWNER}x/${FILE}-${GROUP}:rootless",
    "ghcr.io/${OWNER}x/${FILE}-${GROUP}:${TAG}-rootless",
    "public.ecr.aws/${OWNER}/${GROUP}/${FILE}:rootless",
    "public.ecr.aws/${OWNER}/${GROUP}/${FILE}:${TAG}-rootless",
  ]
  dockerfile = "./Dockerfile.rootless"
}
