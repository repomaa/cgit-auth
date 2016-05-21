# cgit-auth

A very simple, yet safe and very fast authenticator and authorizer for cgit +
gitolite written in crystal.

## Dependencies

- cgit and gitolite (obviously)
- the htpasswd binary

## Installation

1. Copy `config.example` to `config` and edit to your liking
2. Run `make release`

## Usage

1. Place a htpasswd file in the location specified in config
2. Add some credentials to the file (check out gitolite htpasswd)
3. Use with cgit's auth-filter


## Contributing

1. Fork it ( https://github.com/[jreinert]/cgit-auth/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [[jreinert]](https://github.com/[jreinert]) Joakim Reinert - creator, maintainer
