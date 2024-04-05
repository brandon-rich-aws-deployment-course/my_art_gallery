sudo yum install nginx -y
sudo service nginx stop

# CodeDeploy doesn't support overwrite of pre-existing files.  
# it only replaces files it created.
sudo rm /etc/nginx/conf.d/ruby-codedeploy-demo-nginx.conf
sudo rm /etc/nginx/nginx.conf  

sudo ln -s -f /opt/codedeploy-agent/deployment-root/$DEPLOYMENT_GROUP_ID/$DEPLOYMENT_ID/deployment-archive /opt/current-deployment
