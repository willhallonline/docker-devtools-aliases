# docker-devtools-aliases
Aliases for loading different docker containers for aliases.

## Quick Start

So, lets keep things simple. Assumptions are that you know how to use command line. So if that is not the case then you are going to struggle, but you knew that already right?

### Get Docker

Get Docker. This is called Docker DevTools so, if you don't have Docker installed, you are going to not be able to do anything. Docker has excellent documentation, so I am not going to repeat it here.

### Download ```.docker-devtools.sh```

Using either curl or wget, get the file. I would recommend you save it to your home directory as ```.docker-devtools.sh```. Whatever you save it as, remember where it is.

### Add to your ```.bashrc``` or ```.zshrc```

If you are using bash or the awesome zsh or some other command line tool then you will need to add these aliases so that you can run them easily.

```
...
source ~/.docker-devtools.sh
```

### Run a command

Lets try with a simple command. Here is some *bad* css.

```
#id {color: brown}
```

1. Save this to a file... I'll call it ```bad.css```.
2. Run stylelint-docker on it:

```
➜  ~ stylelint-docker bad.css
```

3. Get stylelint output.

```
➜  ~ stylelint-docker bad.css

bad.css
 1:6   ✖  Expected single space after "{"  block-opening-brace-space-after
          of a single-line block
 1:12  ✖  Expected single space after ":"  declaration-colon-space-after
          with a single-line declaration
 1:16  ✖  Expected single space before     block-closing-brace-space-before
          "}" of a single-line block
 1:16  ✖  Expected a trailing semicolon    declaration-block-trailing-semicolon

--- Stylelint Complete ---
```

4. Win o'clock!

### Doing more

There is more you can do, you are just starting... So, lets keep going!

