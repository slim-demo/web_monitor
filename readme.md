# Web Monitor Script

This script is to monitor the number of httpd process that are running. This script has the following logic

  * If the number is less than 10 processes, then print out “[LOW] Web Server OK!”
  * If greater than 20 processes, then print out “[HIGH] Web Server Working hard!”
  * If greater than 100 processes, then print out “[CRITICAL] Web Server under heavy load, restart required”

Additionally it will restart the httpd service if the server is Critical.  The script was tested for RHEL 7.1 but
can be used on other linuxes with small modifications.

---

### Runtime version - web_monitor_with_timer.sh

The first version of the script called **web_monitor_with_timer.sh** it is meant to be run bye a user to monitor the httpd process from a console. It has a timer that executes it every 30 seconds.

```
./web_monitor_with_timer.sh
```

### Crontab version - web_monitor.sh

The second version of this script called **web_monitor.sh** is meant to be run from the crontab. It is a better way to have this sript run unattended. To install you need to add the following code to /etc/crontab

```
*  *  *  *  * root /root/web_monitor/web_monitor.sh >> /var/log/web_monitor.log 2>&1
*  *  *  *  * root ( sleep 30 ; /root/web_monitor/web_monitor.sh ) >> /var/log/web_monitor.log 2>&1 
```

Then restart the service using `systemctl restart crond.service` 

This will run the script every 30 seconds and pipe the result to the log file located at **/var/log/web_monitor.log**

---
