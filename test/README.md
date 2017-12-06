## How to execute tests

It requires [vim-themis](https://github.com/thinca/vim-themis).

```console
$ cd /path/to/clever-f.vim/test
$ git clone https://github.com/thinca/vim-themis
$ ./vim-themis/bin/themis .
```

## How to measure code coverage

It requires [covimerage](https://github.com/Vimjas/covimerage).

```console
$ cd /path/to/clever-f.vim/test
$ pip install covimerage
$ PROFILE_LOG=profile.txt ./vim-themis/bin/themis .
$ covimerage write_coverage profile.txt
$ coverage html
```
