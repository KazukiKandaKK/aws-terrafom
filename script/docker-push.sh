#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<USAGE
使い方: $0 -r <リージョン> -n <リポジトリ名> [-t <タグ>] [-f <Dockerfile>] [-c <コンテキスト>]

オプション:
  -r, --region       ECRリポジトリのAWSリージョン
  -n, --repository   ECRリポジトリ名
  -t, --tag          使用するイメージタグ (デフォルト: latest)
  -f, --dockerfile   使用するDockerfile (デフォルト: Dockerfile)
  -c, --context      ビルドコンテキストディレクトリ (デフォルト: カレントディレクトリ)
  -h, --help         このヘルプを表示
USAGE
}

TAG=latest
DOCKERFILE=Dockerfile
CONTEXT=.

while [[ $# -gt 0 ]]; do
  case "$1" in
    -r|--region)
      REGION="$2"
      shift 2
      ;;
    -n|--repository)
      REPOSITORY="$2"
      shift 2
      ;;
    -t|--tag)
      TAG="$2"
      shift 2
      ;;
    -f|--dockerfile)
      DOCKERFILE="$2"
      shift 2
      ;;
    -c|--context)
      CONTEXT="$2"
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "不明な引数: $1"
      usage
      exit 1
      ;;
  esac

done

if [[ -z "${REGION:-}" || -z "${REPOSITORY:-}" ]]; then
  echo "リージョンとリポジトリ名は必須です"
  usage
  exit 1
fi

ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
ECR_URI="${ACCOUNT_ID}.dkr.ecr.${REGION}.amazonaws.com/${REPOSITORY}"

aws ecr describe-repositories --repository-names "$REPOSITORY" --region "$REGION" >/dev/null 2>&1 || \
  aws ecr create-repository --repository-name "$REPOSITORY" --region "$REGION" >/dev/null

aws ecr get-login-password --region "$REGION" | docker login --username AWS --password-stdin "${ACCOUNT_ID}.dkr.ecr.${REGION}.amazonaws.com"

docker build -t "${ECR_URI}:${TAG}" -f "$DOCKERFILE" "$CONTEXT"
docker push "${ECR_URI}:${TAG}"

echo "${ECR_URI}:${TAG} をプッシュしました"

