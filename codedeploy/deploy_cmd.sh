echo "make sure any changes you want are committed and pushed to github before deploying!"
aws deploy create-deployment \
 --application-name my_art_gallery \
 --deployment-config-name CodeDeployDefault.OneAtATime \
 --deployment-group-name art_gallery_deployment_group \
 --description "Demo Deployment" \
 --github-location repository=brandon-rich-aws-deployment-course/my_art_gallery,commitId=$(git rev-parse HEAD) \
