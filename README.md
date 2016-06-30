ansible-role-tor-nginx-debian
=========

Redirect [tor hidden service](https://www.torproject.org/docs/hidden-services.html.en) via [nginx](http://nginx.org) to a https website. Can be used as a workaround to use a content delivery network which works with dns round robin behind a tor onion service. Be sure not to redirect to a http website as this would compromise the end-to-end encryption promised by onion services.

Requirements
------------

Install [serverspec](http://serverspec.org/) to test the role: ```gem install serverspec```

Role Variables
--------------

* torrc: tor configuration file
  * Defaults to /etc/tor/torrc

* tor_hidden_service_dir: directory with private key and hostname
  * Defaults to /var/lib/tor/hidden_service/

* tor_hidden_service_port: tor hidden service port
  * Defaults to 80

* nginx_host: nginx host
  * Defaults to 127.0.0.1

* nginx_port: nginx port
  * Defaults to 8080

Dependencies
------------

This role should be used together with some nginx role like [geerlingguy/ansible-role-nginx](https://github.com/geerlingguy/ansible-role-nginx).

For this role you could use the following vars/nginx.yml file to redirect to https://www.debian.org/:
```
---
nginx_vhosts:
  - listen: "8080 default_server"
    server_name: "www.debian.org"
    extra_parameters: |
      location / {
          proxy_pass https://www.debian.org/;
      }
```

Example Playbook
----------------

```
---
- hosts: all

  become: yes
  become_method: sudo
  
  vars_files:
    - vars/nginx.yml
    
  roles:
    - ansible-role-tor-nginx-debian
    - ansible-role-nginx
    
  tasks:
    - name: copy private key of tor onion service
      copy: src=files/private_key
            dest="{{ tor_hidden_service_dir }}/private_key"
      notify: restart tor
```

Configuration
-------------

You should add *--require spec_helper* to *.rspec*.

License
-------

MIT
