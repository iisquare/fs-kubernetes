APP_NAME=$1
APP_VERSION=$2
CI_PIPELINE_ID=$3

echo "deploy ${APP_NAME}:${APP_VERSION}.${CI_PIPELINE_ID}"

source /etc/bashrc

mvn package -Dmaven.test.skip=true -pl $APP_NAME -am -s settings.xml
sudo -E docker build \
  -t harbor.iisquare.com/app/${APP_NAME}:${APP_VERSION}.${CI_PIPELINE_ID} \
  --build-arg APP_NAME=${APP_NAME} --build-arg APP_VERSION=${APP_VERSION} --no-cache .
sudo -E docker push harbor.iisquare.com/app/${APP_NAME}:${APP_VERSION}.${CI_PIPELINE_ID}
cp bin/template.yaml bin/template-${APP_NAME}.yaml
sed -i "s/{APP_NAME}/${APP_NAME}/g" bin/template-${APP_NAME}.yaml
sed -i "s/{CI_PIPELINE_ID}/${CI_PIPELINE_ID}/g" bin/template-${APP_NAME}.yaml
sed -i "s/{APP_VERSION}/${APP_VERSION}/g" bin/template-${APP_NAME}.yaml
cat bin/template-${APP_NAME}.yaml
sudo -E kubectl replace --force -f bin/template-${APP_NAME}.yaml
