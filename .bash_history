python manage.py makemigrations
python manage.py migrate
exit
python manage.py showmigrations food_order_api
(freshstartenv) 17:47 ~/fresh_start (master)$ 
rm -rf food_order_api/migrations
python manage.py makemigrations food_order_api
python manage.py migrate --fake-initial
