require_relative '../lib/inidol'
require 'pp'

example = '''
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
'''.from_ini # convert given example INI string to hash

pp example # and output it with pp formatting