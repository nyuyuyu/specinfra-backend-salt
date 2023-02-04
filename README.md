# Specinfra::Backend::Salt

This backend execute command on salt-minion from salt-master using `salt cmd.run` command.

So, this backend work on ***only salt-master*** .

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'specinfra-backend-salt'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install specinfra-backend-salt

## Usage

An example for using [Serverspec](https://serverspec.org/).

```ruby:spec_helper.rb
require 'serverspec'
require 'specinfra/backend/salt'

set :backend, :salt

if ENV['ASK_SALT_SUDO_PASSWORD']
  begin
    require 'highline/import'
  rescue LoadError
    fail "highline is not available. Try installing it."
  end
  set :salt_sudo_password, ask("Enter sudo password: ") { |q| q.echo = false }
else
  set :salt_sudo_password, ENV['SALT_SUDO_PASSWORD']
end

# :host should be a minion ID.
set :host, ENV['TARGET_HOST']
```

## Optional options

- `:salt_user` Specify the username to execute command on salt-minion. (default: `root`)
- `:salt_become_method` Specify the privilege escalation method to execute `salt run.cmd` on salt-master. (default: `:sudo`, `:su` or `:none`)
- `:salt_sudo_user` Specify the username to execute `salt run.cmd` with `sudo` on salt-master. (default: `root`)
- `:salt_sudo_password` Specify the password of `:salt_sudo_user` user.
- `:salt_sudo_path` Specify the path of the directory where the `sudo` is placed on salt-master.
- `:salt_su_user` Specify the username to execute `salt run.cmd` with `su` on salt-master. (default: `root`)
- `:salt_su_password` Specify the password of `:salt_su_user` user.
- `:salt_su_path` Specify the path of the directory where the `su` is placed on salt-master.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/nyuyuyu/specinfra-backend-salt. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Specinfra::Backend::Salt project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/nyuyuyu/specinfra-backend-salt/blob/main/CODE_OF_CONDUCT.md).
