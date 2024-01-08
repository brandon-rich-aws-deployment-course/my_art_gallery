aws deploy create-deployment \
 --application-name art_gallery \
 --deployment-config-name CodeDeployDefault.OneAtATime \
 --deployment-group-name art_gallery_deployment_group \
 --description "Demo Deployment" \
 --github-location repository=brandon-rich-aws-deployment-course/my_art_gallery,commitId=$(git rev-parse HEAD) \
