
# Setup

If using RVM, create ruby-version and ruby-gemset, then reenter the dir

```bash
$ echo "ruby-2.4.1" > .ruby-version && echo "data_api" > .ruby-gemset
$ cd .. && cd data_api
```

Install Bundler and then Install dependencies

```bash
$ gem install bundler --no-ri --no-rdoc
$ bundle install
```