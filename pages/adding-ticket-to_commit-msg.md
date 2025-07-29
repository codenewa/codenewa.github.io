Adding ticket numbers to the commit gives us following benefits:
 - Commit, build, release, etc all get attached to the ticket.
 - Each commit can be seen on the ticket history.

## Code Snippet
1. Save the following with name: `prepare-commit-msg` in an an accessible location.


```
#!/bin/bash
FILE=$1
MESSAGE=$(cat $FILE)

TICKET=[#$(git rev-parse --abbrev-ref HEAD | grep -Eo ')]
```
