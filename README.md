# EditorConfig-Tools

[![Build Status](http://img.shields.io/travis/slang800/editorconfig-tools.svg?style=flat)](https://travis-ci.org/slang800/editorconfig-tools)

EditorConfig-Tools is for validating or fixing code that doesn't adhere to settings defined in `.editorconfig`. It also is able to infer settings from existing code . See the [EditorConfig Project][http://editorconfig.org/] for details about the `.editorconfig` file.


## Features
- Infer `.editorconfig` settings from one or more files.
- Check (validate) that file(s) adhere to `.editorconfig` settings.
- Fix formatting errors that disobey `.editorconfig` settings.

## Examples
Here is an example of the command-line API we want to support:

```bash
$ cat .editorconfig
[*]
indent_style = space
indent_size = 4

$ eclint check test/lf_*.txt
tests/lf_invalid_crlf.txt: Incorrect line ending found: crlf
tests/lf_invalid_crlf.txt: No final newline found
tests/lf_invalid_cr.txt: Incorrect line ending found: cr

$ eclint infer *
[*]
indent_style = space
indent_size = 4
end_of_line = lf
charset = utf-8
insert_final_newline = true
trim_trailing_whitespace = true

[Makefile]
indent_style = tab
indent_size = tab

$ eclint fix *
Makefile: Converted tabs to spaces

$ eclint check *
```

## Project Status
This project is not finished, but the `check` command works pretty well, and the code is written for all editorconfig properties except `charset`. So, feel free to play with it, but don't expect it to work well yet.
