# A Puppet Bash script to set up web servers for the deployment of web_static

sudo apt-get install puppet

class nginx {
 package { 'nginx':
    ensure => installed,
 }
 service { 'nginx':
    ensure     => running,
    enable     => true,
    require    => Package['nginx'],
 }
}

class web_static {
 $web_static_root = '/data/web_static'
 $releases_path = "${web_static_root}/releases"
 $shared_path = "${web_static_root}/shared"

 file { $web_static_root:
    ensure => directory,
    owner => 'ubuntu',
    group => 'ubuntu',
    mode   => '0755',
    require => Package['nginx'],
 }

 file { $releases_path:
    ensure => directory,
    owner => 'ubuntu',
    group => 'ubuntu',
    mode   => '0755',
    require => File[$web_static_root],
 }

 file { $shared_path:
    ensure => directory,
    owner => 'ubuntu',
    group => 'ubuntu',
    mode   => '0755',
    require => File[$web_static_root],
 }

 file { "${releases_path}/test":
    ensure => directory,
    owner => 'ubuntu',
    group => 'ubuntu',
    mode   => '0755',
    require => File[$releases_path],
 }

 file { "${releases_path}/test/index.html":
    ensure => file,
    owner   => 'ubuntu',
    group   => 'ubuntu',
    mode    => '0644',
    content => 'Holberton School',
    require => File["${releases_path}/test"],
 }

 file { "${web_static_root}/current":
    ensure => link,
    target => "${releases_path}/test",
    owner => 'ubuntu',
    group => 'ubuntu',
    mode   => '0755',
    require => File["${releases_path}/test"],
 }

 # Add Nginx configuration to serve /data/web_static/current/
 file { '/etc/nginx/sites-available/default':
    ensure => file,
    owner => 'root',
    group => 'root',
    mode   => '0644',
    content => template('web_static/nginx.conf.erb'),
    notify => Service['nginx'],
 }
}


<!DOCTYPE html>
<html>
<head>
 <title>Welcome to nginx!</title>
 <style>
    body {
      width: 35em;
      margin: 0 auto;
      font-family: Tahoma, Verdana, Arial, sans-serif;
    }
 </style>
</head>
<body>
 <h1>Welcome to nginx!</h1>
 <p>If you see this page, the nginx web server is successfully installed and
 working. Further configuration is required.</p>

 <p>For online documentation and support please refer to
 <a href="http://nginx.org/">nginx.org</a>.<br/>
 Commercial support is available at
 <a href="http://nginx.com/">nginx.com</a>.</p>

 <p><em>Thank you for using nginx.</em></p>
</body>
</html>

location /hbnb_static/ {
 alias /data/web_static/current/;
}


sudo puppet agent -t
    
