# Inidol
Pure Ruby atomic-small and super-simple library for transforming Hashes to INI code.
Use `gem install inidol` for install.

# API
Inidol has little method, that extends Hash class in Ruby.

### `Hash.to_ini`
Convert Hash to INI string. Example:
```ruby	
require 'inidol'
settings = {
	global: {
		name: 'Bounce',
		author: 'homonoid',
		version: '~1.0.0'
	},
	
	settings: {
		graphics: 'low',
		shadows: false
	}
}
puts settings.to_ini
```

outputs following INI:

```ini
[global]
name=Bounce
author=homonoid
version=~1.0.0

[settings]
graphics=low
shadows=false
```

### `String.from_ini`
Convert INI string to Hash. Example:

```ruby
require 'inidol'
require 'pp'

settings = <<-END
	[global]
	name=Bounce
	author=homonoid
	version=~1.0.0

	[settings]
	graphics=low
	shadows=false
END

pp settings.from_ini
```
outputs following Hash:

```ruby
	{
		:global => {
			:name => "Bounce", 
			:author => "homonoid", 
			:version => "~1.0.0"
		},
		:settings => {
			:graphics => "low", 
			:shadows => false
		}
	}
```



### Bugs
* Inserts newline at start of INI. May be fixed using `[1..-1]`.

 *Use at your own risk.* 
