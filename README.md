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
	[numbers]
	digits = 12 # will be transformed into number
	version = 1.0.0 # will be transformed into string
	float = 3.14 # will be transformed into float

	[strings]
	simple = "Hello, World!" # followed with quotes
	also = Hello, World! # or without quotes

	[arrays]
	constants[] = 3.14
	constants[] = 2.71
	constants[] = 1.45
END

pp settings.from_ini
```
outputs following Hash:

```ruby
{
	:numbers => {
		:digits => 12,
		:version => "1.0.0",
		:float => 3.14
	},
	:strings => {
		:simple => "Hello, World!",
		:also => "Hello, World!"
	},
	:arrays => {
		:constants => [3.14, 2.71, 1.45]
	}
}

```



### Bugs
* Inserts newline at start of INI. May be fixed using `[1..-1]`.
