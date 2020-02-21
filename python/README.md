# dotfiles
Some useful for my local setup and some usefull commands

Python virtual env
```
virtualenv -p python3 envname
```

python execute command for reference

```
def executeCommand(self,cmd_to_execute):
    '''
    Execute the bash command
    '''
    try:
        check_state = subprocess.Popen(cmd_to_execute, shell=True,
                                        stdout=subprocess.PIPE,
                                        stderr=subprocess.PIPE,
                                        executable = "/bin/bash")
        output, error = check_state.communicate()
        return check_state.returncode, output.decode("utf-8"), error.decode("utf-8")
    except Exception as e:
        self.DoError(str(e))
```

python delete and add text in file

```
def add_delete_text_file(self,filename,delete_text,add_text):
    '''
    search and repalce the text in file
    delete_text = ['','']
    add_text = ['','']
    '''
    try:
        for line in fileinput.input(filename, inplace=1):
            if [True for temp_delete_details in delete_text if temp_delete_details in line]:
                continue
            print(line.strip())
        with open(filename, 'a+') as file_cache:
            for temp_add_text in add_text:
                file_cache.write("\n"+temp_add_text)
    except Exception as e:
        self.DoError(str(e))
```
