#/bin/bash

locust -f locustfile.py -u 50 -r 10 --run-time 5m

# options
#--headless
#-u
#-r
#--run-time 5m