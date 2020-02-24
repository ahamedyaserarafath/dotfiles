To check the localhost setup
```
ansible localhost -m setup
```

Install ansible
```
sudo yum install ansible
```
Sample ansible
```
---  # Bootstrap Webservers
- hosts: webservers
  become: yes
  tasks:
  - name: install httpd
    yum:
      name: httpd
      state: latest
  - name: create index.html file
    file:
      name: /var/www/html/index.html
      state: touch
  - name: add web content
    lineinfile:
      line: "here is some text"
      path: /var/www/html/index.html
  - name: start httpd
    service:
      name: httpd
      state: started
```
