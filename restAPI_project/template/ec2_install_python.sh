#! /bin/bash
# shellcheck disable=SC2164
cd /home/ubuntu
yes | sudo apt update
yes | sudo apt install python3 python3-pip python3-venv
git clone https://github.com/felipes08/dev-proj-1-python-mysql-db-script
sleep 20
# shellcheck disable=SC2164
cd dev-proj-1-python-mysql-db-script

python3 -m venv venv
source venv/bin/activate

pip install -r requirements.txt
echo 'Waiting for 30 seconds before running the app.py'
setsid venv/bin/python -u app.py > flask.log 2>&1 &
sleep 30