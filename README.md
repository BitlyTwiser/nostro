# zipgrep
Zipgrep recursively searches directories for a given string and selected inputs.

## Inputs
All flags are optional, if no flags (other than the mandatory `term` flag) are passed, then zipgrep just does a dumb string eql/contains search and nothing else. i.e. Will just hunt for any exact mathces or strings containing the given pattern. Otherwise, the flags will be incorporated.

Note: *ALL* flags are treated as *OR* statements when entered. If you enter `-e` and `-p` zipgrep assumes you desire *either* of the given elements to be present, so it will match if the prefix or regex match.

Zipgrep uses the following flags to denote search string:

Mandatory flags:
```
-term="word to search"
````

Optional flags to refine search:

```
-path="path" // If path is not set, zipgrep will start from the root of your OS. THis can take a while, so generally its recommended to set a directory.

-type="f or d" // Denotes if you are searching for a file or a directory. Default is to search for files unless specified otherwise

-e=Optional (optional: true)

-i=Optional (optional: true)


```

## Usage
### Regular expression:
Utilizing the `-e=true` flag will expect a regular expression in the term field for matching/parsing of files/directories.

Utilizing `-i` will lowercase cast the input strings to avoid any case sensitive matching.

## Outputs:
The output is similiar to egrep. The values, if found, are printed on individual lines to be viewed by the user

## Benchmarks
Note: I did not make this application in any attempt to beat any existing tools out there (since plenty do this *exact* thing), but just a quick item to curate over an hour or two to try out different Zig regex engines. I did toss benchmarks in here simply for fun and to satiate my inner data nerd. 


## Limitations
Ziggrep is just a tool to find files/directories on the file system quickly, if you need to parse files, search file contents in a fast fashion for specific strings etc.. please use [Ripgrep](https://github.com/BurntSushi/ripgrep) which is a great Rust tool. :)
