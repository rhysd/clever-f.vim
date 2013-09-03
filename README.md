## INTRODUCTION [![Build Status](https://travis-ci.org/rhysd/clever-f.vim.png?branch=master)](https://travis-ci.org/rhysd/clever-f.vim)

clever-f.vim extends `f` mapping for more convenience. You may be able to forget the existence of `;`. And you can use `;` for an other mapping.
clever-f.vim is distributed under MIT license. See `doc/clever_f.txt` to get more information.



## USAGE

I'll show some examples of usage. _ is the place of cursor, -> is a move of
cursor, alphabets above -> is input by keyboard.


    input:       fh         f         f      e         fo         f
    move :  _---------->_------>_---------->_->_---------------->_->_
    input:                            F                            F
    move :                        _<-----------------------------_<-_
    text :  hoge        huga    hoo         hugu                ponyo



    input:        f        Fh       b     f                         Fo
    move :  _<----------_<------_<-_<-----------------------------_<-_
    input:        F        F          F
    move :  _---------->_------>_----------->_
    text :  hoge        huga    huyo         hugu                ponyo



    input:       th         t         t      e         to         t
    move :  _--------->_------>_---------->_-->_--------------->_->_
    input:                            T                            T
    move :                         _<-----------------------------__
    text :  hoge        huga    hoo         hugu                ponyo


## Unstable version

If you want to use the latest version, use [dev branch](https://github.com/rhysd/clever-f.vim/tree/dev).


## LICENSE

Distributed under MIT License. See `doc/clever_f.txt`
