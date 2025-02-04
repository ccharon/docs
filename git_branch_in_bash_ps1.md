# git branch name in git prompt

git needs to be installed.

edit .bashrc, add at bottom

```
source /usr/share/git/git-prompt.sh

export PS1='\[\e[01;32m\]\u@\h\[\e[01;34m\] \w\[\e[91m\]$(__git_ps1)\e[01;34m\] \$\[\e[00m\] '
```

the location of git-prompt.sh might be gentoo specific, also the ps1 prompt resembles the gentoo default bash ps1 prompt
