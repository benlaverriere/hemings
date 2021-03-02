# hemings

Named for [James and Peter Hemings][namesakes], this project is a way to tidy up my binder of favorite
recipes by typesetting them nicely. It's also an excuse to play around with the [Ninja][ninja] build system, after
reading [Julia Evans' article about it][jvns].

Initially, I'm going to try the [markdown recipe format created for the Grocery app][grocery-format]. I don't intend to
perform structured parsing, just rendering (probably with [Pandoc][pandoc]), but this format is the one I find most
readable in its raw form after a quick search.

[namesakes]: https://www.nbcnews.com/news/nbcblk/meet-james-peter-hemings-america-s-first-black-celebrity-chefs-n1134141
[ninja]:https://ninja-build.org
[jvns]: https://jvns.ca/blog/2020/10/26/ninja--a-simple-way-to-do-builds/
[grocery-format]: https://github.com/cnstoll/Grocery-Recipe-Format
[pandoc]: https://pandoc.org/

## usage

0. `brew bundle install` to ensure system-level software is installed
  - This doesn't install Ruby, so ensure you have a recent Ruby available
0. `generate_build.rb` to create the build script based on contents of `./plain/*.md`
0. `ninja` to render the individual recipes to PDF
  - For continuous editing, `cat <(g ls-files) <(fd plain) | entr ninja`

## ideas, questions, TODOs

- Smartypants-style parsing of fractions, degrees, etc?
- Lightweight reformatting of ingredient specifications?
