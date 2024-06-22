#! /bin/bash
set -e

# module_name=$1

aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com

build_and_push() {
    module_name=$1
    aws ecr create-repository  --region ${AWS_REGION} --repository-name vp-ecr-10-${module_name}|| echo "ignore create repository"
    docker build -f Dockerfile --platform linux/arm64 -t ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/vp-ecr-10-${module_name}:${APP_VERSION} .
    docker push ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/vp-ecr-10-${module_name}:${APP_VERSION}
    docker rmi $(docker images | grep ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/vp-ecr-10-${module_name} | grep -v latest| awk '{print $3}' | uniq) -f | echo "ignore remove docker images"
}

# echo "BUILD AND PUSH $(echo ${module_name//-/ } | tr '[:lower:]' '[:upper:]')"
# echo lambda-functions/${module_name//-/_}
docker run --privileged --rm tonistiigi/binfmt --install all

echo "BUILD AND PUSH PAYMENT NOTIFICATION SERVICE IMAGE"
pushd lambda-functions/payment-notification-service
build_and_push payment-notification-service
popd

echo "BUILD AND PUSH PAYMENT VALIDATION SERVICE IMAGE"
pushd lambda-functions/payment-validation-service
build_and_push payment-validation-service
popd

echo "BUILD AND PUSH PROCESS PAYMENT SERVICE IMAGE"
pushd lambda-functions/process-payment-service
build_and_push process-payment-service
popd

echo "BUILD AND PUSH PUBLISH NEW PAYMENT SERVICE IMAGE"
pushd lambda-functions/publish-new-payment-service
build_and_push publish-new-payment-service
popd

echo "BUILD AND PUSH PUBLISH NEW PAYMENT SERVICE IMAGE"
pushd lambda-functions/start-payment-processing-service
build_and_push start-payment-processing-service
popd