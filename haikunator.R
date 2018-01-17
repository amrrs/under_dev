#inspired by https://github.com/usmanbashir/haikunator 

default_adjectives = c(
  'aged', 'ancient', 'autumn', 'billowing', 'bitter', 'black', 'blue', 'bold',
  'broad', 'broken', 'calm', 'cold', 'cool', 'crimson', 'curly', 'damp',
  'dark', 'dawn', 'delicate', 'divine', 'dry', 'empty', 'falling', 'fancy',
  'flat', 'floral', 'fragrant', 'frosty', 'gentle', 'green', 'hidden', 'holy',
  'icy', 'jolly', 'late', 'lingering', 'little', 'lively', 'long', 'lucky',
  'misty', 'morning', 'muddy', 'mute', 'nameless', 'noisy', 'odd', 'old',
  'orange', 'patient', 'plain', 'polished', 'proud', 'purple', 'quiet', 'rapid',
  'raspy', 'red', 'restless', 'rough', 'round', 'royal', 'shiny', 'shrill',
  'shy', 'silent', 'small', 'snowy', 'soft', 'solitary', 'sparkling', 'spring',
  'square', 'steep', 'still', 'summer', 'super', 'sweet', 'throbbing', 'tight',
  'tiny', 'twilight', 'wandering', 'weathered', 'white', 'wild', 'winter', 'wispy',
  'withered', 'yellow', 'young'
)

default_nouns = c(
  'art', 'band', 'bar', 'base', 'bird', 'block', 'boat', 'bonus',
  'bread', 'breeze', 'brook', 'bush', 'butterfly', 'cake', 'cell', 'cherry',
  'cloud', 'credit', 'darkness', 'dawn', 'dew', 'disk', 'dream', 'dust',
  'feather', 'field', 'fire', 'firefly', 'flower', 'fog', 'forest', 'frog',
  'frost', 'glade', 'glitter', 'grass', 'hall', 'hat', 'haze', 'heart',
  'hill', 'king', 'lab', 'lake', 'leaf', 'limit', 'math', 'meadow',
  'mode', 'moon', 'morning', 'mountain', 'mouse', 'mud', 'night', 'paper',
  'pine', 'poetry', 'pond', 'queen', 'rain', 'recipe', 'resonance', 'rice',
  'river', 'salad', 'scene', 'sea', 'shadow', 'shape', 'silence', 'sky',
  'smoke', 'snow', 'snowflake', 'sound', 'star', 'sun', 'sun', 'sunset',
  'surf', 'term', 'thunder', 'tooth', 'tree', 'truth', 'union', 'unit',
  'violet', 'voice', 'water', 'waterfall', 'wave', 'wildflower', 'wind', 'wood'
)


generateToken = function(length = 4){
  paste(sample( 1:9, length, replace=TRUE ), collapse="" )
  
}


generateToken(6)

sample(default_adjectives,1)

haikunate = function(token_length = 4, delimiter = '-'){
  if (token_length > 0) {
  
    paste(sample(default_adjectives,1),
          sample(default_adjectives,1),
          generateToken(token_length),
          sep = delimiter)
  }
  
  else {
    paste(sample(default_adjectives,1),
          sample(default_adjectives,1),
          #generateToken(token_length),
          sep = delimiter)
  }
}

haikunate(5,'_')
