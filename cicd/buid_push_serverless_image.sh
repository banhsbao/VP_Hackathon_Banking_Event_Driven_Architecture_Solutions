aws ecr get-login-password --region ${AWS_REGION}| docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com

aws ecr create-repository  --region ${AWS_REGION} --repository-name vp-ecr-10-cicd-serverless|| echo "ignore create repository"
docker build -f Dockerfile -t ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/vp-ecr-10-cicd-serverless:latest .
docker push ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/vp-ecr-10-cicd-serverless:latest
docker rmi $(docker images | grep ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/vp-ecr-10-cicd-serverless | grep -v latest| awk '{print $3}' | uniq) -f | echo "ignore remove docker images"
