#!/bin/sh

PROJECT=$(basename `/bin/pwd`)

echo "****************************************"
echo " Create pbp2011 app in current project directory"
echo "****************************************"

d=$(dirname $(which $0))
APP_LOCATION=$(cd $d && pwd)

. pyenv/bin/activate
django-admin startapp pbp2011

cp ${APP_LOCATION}/pbp2011/models.py pbp2011
cp ${APP_LOCATION}/pbp2011/views.py pbp2011
cp ${APP_LOCATION}/pbp2011/serializers.py pbp2011
cp -r ${APP_LOCATION}/pbp2011/fixtures pbp2011/fixtures
cp -r ${APP_LOCATION}/pbp2011/management pbp2011/management

echo "****************************************"
echo " Update INSTALLED_APPS"
echo "****************************************"
sleep 2
cat >> $PROJECT/settings.py <<EOF

### Added by setup script for pbp2011 app
INSTALLED_APPS.append('pbp2011.apps.Pbp2011Config')
EOF

echo "****************************************"
echo " Process migrations & import data"
echo "****************************************"
sleep 2
set -x
./manage.py makemigrations
./manage.py migrate
./manage.py importdata pbp2011/fixtures/pbp2011_us_lf.json.gz
set +x

echo "****************************************"
echo " Install routes"
echo "****************************************"
sleep 2
cat >> $PROJECT/urlapps.py <<EOF

### Added by setup script for pbp2011 app

def addroutes_pbp2011(router):
    from pbp2011 import views

    router.register(r'biketype', views.BikeTypeViewSet)
    router.register(r'control', views.ControlViewSet)
    router.register(r'rider', views.RiderViewSet)

addroutehooks.append(addroutes_pbp2011)
EOF

echo "****************************************"
echo " Checkpoint our work"
echo "****************************************"
sleep 2
set -x
git add .
git commit -m "Add pbp2011 sample app"
set +x
