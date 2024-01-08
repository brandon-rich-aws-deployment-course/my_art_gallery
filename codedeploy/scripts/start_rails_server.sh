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
export RDS_PORT=5432
export RDS_DB_NAME="postgres"
export RDS_PASSWORD=$(aws ssm get-parameters --region us-east-1 --names CodeDeployPostgresPassword --with-decryption --query Parameters[0].Value)
export RDS_USERNAME=$(aws ssm get-parameters --region us-east-1 --names CodeDeployPostgresUsername --with-decryption --query Parameters[0].Value)
export RDS_HOSTNAME=$(aws ssm get-parameters --region us-east-1 --names CodeDeployPostgresEndpoint --with-decryption --query Parameters[0].Value)

echo "DEBUG: Generating a secret key base value"
export SECRET_KEY_BASE=$(bundle exec rake secret)

echo "DEBUG: Installing gem dependencies"
bundle

# need node and yarn
echo "DEBUG: Precompiling assets"
bundle exec rails assets:precompile

echo "DEBUG: Performing database migration, if needed"
bundle exec rake db:migrate

echo "DEBUG: Starting the server (puma) in daemon mode.  Pid will appear in ./tmp/pids/server.pid"
bundle exec rails s -d


