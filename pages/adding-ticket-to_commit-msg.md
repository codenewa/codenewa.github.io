

Adding VSTS Ticket# to the commits

When we add the vsts ticket# to the commit, it gives following benefits:
 - The commit, build, pr, release, etc all get attached to the ticket.
 - Each commit can be seen on the ticket history page itself.

However, if it's manual, it'll likely be forgotten. So, here's a code snippet to automate the process.

1. Save the following with name: `prepare-commit-msg` in an accessible something like crveit
```
#!/bin/bash
FILE=$1
MESSAGE= $(cat $FILE)
TICKET=[#$(git rev-parse abbrev-ref HEAD | grep -Eo '^(\w+/)?(\w+[-_])?[0-9]+' | grep -Eo '(\w+[-])?[0-9]+' | tr "[:lower:]" "[:upper:]")]
If [[ $TICKET=="[]" || "$MESSAGE"=="STICKET"* ]]; then
exit e;
echo "$TICKET $MESSAGE" > $FILE
```

2. Run:

`git config --global core.hooksPath/path/to/git_hooks`

3. Your branch should be named as follows: `feature/23451-description`