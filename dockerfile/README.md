Difference between ADD and COPY said as below

Assume if a tar file is present inside the folder where you write a Dockerfile as below
```
>ls
test.tar.gz
```
Inside Dockerfile
```
...
ADD test* /mnt/.
...
```

And
```
...
COPY test* /mnt/.
...
```

Try those both and check inside /mnt/ folder you will know the answer :)
