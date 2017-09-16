require '../lib/inidol'

error_ini = '''
  [name]
  # unclosed string here
  data = "data
'''.from_ini

puts error_ini