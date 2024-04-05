#. /home/ec2-user/.bash_profile
#. /home/ec2-user/.bashrc
#export PATH=/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin:/opt/aws/bin:/home/ec2-user/.local/bin:/home/ec2-user/bin

# move to current deployment folder.  Note: this is a symlink to
# the latest deploy in /opt/codedeploy-agent/deployment-root/$DEPLOYMENT_GROUP_ID/$DEPLOYMENT_ID/deployment-archive
cd /opt/current-deployment


# NOTE: parameter store retrievals will work as long as the instance
# has attached an IAM role whose policies include get privileges on these
# keys (such as CodeDeployPostgresPassword)
echo "DEBUG: Adding ENV variables from Parameter Store"
export RACK_ENV=production
export RDS_PORT=5432
export RDS_DB_NAME="postgres"
export RDS_PASSWORD=$(aws secretsmanager get-secret-value --secret-id CodeDeploySecrets --query 'SecretString' --output text | jq -r '.password')
export RDS_USERNAME=$(aws secretsmanager get-secret-value --secret-id CodeDeploySecrets --query 'SecretString' --output text | jq -r '.username')
export RDS_HOSTNAME=$(aws secretsmanager get-secret-value --secret-id CodeDeploySecrets --query 'SecretString' --output text | jq -r '.host')

echo "DEBUG: Fetching RAILS_MASTER_KEY from Secrets Manager so SECRET_KEY_BASE will be defined" 
export RAILS_MASTER_KEY=$(aws secretsmanager get-secret-value --secret-id CodeDeploySecrets --query 'SecretString' --output text | jq -r '.rails_master_key')

echo "DEBUG: Installing gem dependencies"
bundle

# need node and yarn
echo "DEBUG: Precompiling assets"
bundle exec rails assets:precompile

echo "DEBUG: Performing database migration, if needed"
bundle exec rake db:migrate

echo "DEBUG: Starting the server (puma) in daemon mode.  Pid will appear in ./tmp/pids/server.pid"
bundle exec rails s -d


