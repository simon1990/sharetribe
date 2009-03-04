#!/bin/sh
# The last part of the Kassi build script. This is in a separate file so that the newest version from the repository
# is always run. 


rm -rf log
ln -s /var/datat/kassi/shared/log log
rm -rf tmp/pids/
cd tmp
ln -s /var/datat/kassi/shared/pids pids
cd ..
rm -rf public/images/listing_images/
cd public/images/
ln -s /var/datat/kassi/shared/listing_images/ listing_images
cd ..
cd ..

 REV=$((`svn info file:///svn/kassi | \
 grep "^Last Changed Rev" | \
 perl -pi -e "s/Last Changed Rev: //"`-`svn info file:///svn/kassi/tags | \
 grep "^Last Changed Rev" | \
 perl -pi -e "s/Last Changed Rev: //"`))
echo "BETA_VERSION = \"0.7.$REV\"" >> config/environments/production.rb
BUILD_DATE=`svn info file:///svn/kassi | \
 grep "^Last Changed Date" | \
 perl -pi -e "s/Last Changed Date: //" | perl -pi -e "s/\+.+$//"`
echo "BUILT_AT = \"$BUILD_DATE\"" >> config/environments/production.rb




#rake db:migrate
#rake test
rake db:migrate RAILS_ENV=production
#script/server -d -e production -p 8000
mongrel_rails cluster::start
cd ..
cd ..
sudo /etc/init.d/apache2 restart





