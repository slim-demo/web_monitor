# Web Monitor Script

This script is to monitor the number of httpd process that are running. This script has the following logic

  * If the number is less than 10 processes, then it will print out “[LOW] Web Server OK!”
  * If greater than 20 processes, then it will print out “[HIGH] Web Server Working hard!”
  * If greater than 100 processes, then it will print out “[CRITICAL] Web Server under heavy load, restart required”

Additionally it will restart the httpd service if the server is **Critical**.  The script was tested for RHEL 7.1 but
can be used on other linuxes with small modifications.

---

### Runtime version - web_monitor_with_timer.sh

The first version of the script called **web_monitor_with_timer.sh** it is meant to be run bye a user to monitor the httpd process from a console. It has a timer that executes it every 30 seconds.

```
./web_monitor_with_timer.sh
```

### Crontab version - web_monitor.sh

The second version of this script called **web_monitor.sh** is meant to be run from the crontab. It is a better way to have this script run unattended. To install you need to add the following code to /etc/crontab

```
*  *  *  *  * root /root/web_monitor/web_monitor.sh >> /var/log/web_monitor.log 2>&1
*  *  *  *  * root ( sleep 30 ; /root/web_monitor/web_monitor.sh ) >> /var/log/web_monitor.log 2>&1 
```

Then restart the service using `systemctl restart crond.service` 

This will run the script every 30 seconds and pipe the result to the log file located at **/var/log/web_monitor.log**

## Logrotate /var/log/web_monitor.log

One of the advantages of using the crontab way of installing this software is that it has the facility to output a logfile. In the example above it is configured to write the log file at /var/log/web_monitor.log

In order to logrotate this file so it doesn't grow that big. We need to configure a file in `/etc/logrotate.d`. The file should containg something like this.

```
# Logrotate file for web_monitor

/var/log/web_monitor.log {
       	missingok
	       compress
	       daily
	       rotate 15
       	create 0644 root root
}
```

This will configure the logrotate to rotate the file daily, and keep 15 days of logs. It will also compress the older files. 

## Pushing the log information into logstash

In order to push this information into logstash, you first need a correctly configured Logstash and an ElasticSearch server. There is a [guide](http://logstash.net/docs/1.4.2/tutorials/getting-started-with-logstash) that can help you get started to do this.

Then you would need to configure an input, filter and output conf file to process the web_monitor.log and execute this conf file by using `/logstash -f web_monitor.conf` 

That would start pushing the logs into logstash, and elasticsearch. Other analysis could be made from the elasticsearch repository.

---
