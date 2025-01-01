# nostro
Nostro recursively searches directories for a given string and selected inputs.

## Inputs
All flags are optional, if no flags (other than the mandatory `term` flag) are passed, then nostro just does a dumb string eql/contains search and nothing else. i.e. Will just hunt for any exact mathces or strings containing the given pattern. Otherwise, the flags will be incorporated.

Note: *ALL* flags are treated as *OR* statements when entered. If you enter `-e` and `-p` nostro assumes you desire *either* of the given elements to be present, so it will match if the prefix or regex match.

Nostro uses the following flags to denote search string:

Mandatory flags:
```bash
-term="word to search"
```

Optional flags to refine search:

```bash
-path="path" // If path is not set, nostro will start from the root of your OS. THis can take a while, so generally its recommended to set a directory.

-t="f or d" // Denotes if you are searching for a file or a directory. Default is to search for files unless specified otherwise

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

I did not parake in establishing a fancy benchmarking enviornment, I utilized the following command to run the code with FIFO priority 99 on an Ubuntu liunux system to ensure CPU context switching would not interfere with the code execution:

```bash
sudo chrt -f 99 /usr/bin/time --verbose <benchmark>
```

Examples:
```zig
./zig-out/bin/nostro -term="firm" -path="/home/butterz/Documents" -i=true -t=f
./zig-out/bin/nostro -term="(fi)" -path="/home/butterz/Documents" -e=true 
```
