
group "default" {
  targets = ["amd","arm"]
}

target "amd" {
  dockerfile = "dockerfiles/0.9.8/Dockerfile.amd64"
  tags = ["docker.io/hcp4715/hddm:0.9.8-amd64"]
  platforms = ["linux/amd64"] 
}

target "arm" {
  dockerfile = "dockerfiles/0.9.8/Dockerfile.arm64"
  tags = ["docker.io/hcp4715/hddm:0.9.8-arm64"]
  platforms = ["linux/arm64"]
}
