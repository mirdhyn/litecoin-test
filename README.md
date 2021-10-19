# Litecoin test build repo
This is a test repository, simply building litecoin docker image and deploying to K8s cluster
using TravisCI & Kustomize

## update_kustomize.go
Go code doing the same as in .travis.yml, simply get current commit using `git log` parsing, read kustomization file and replace image tag.

Usage: go run update_kustomization.go deploy/kustomization.yaml

