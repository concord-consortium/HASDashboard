_ = require 'lodash'

words = _.words """
Still, despite the anatomical points that mark them as a different species, dire wolves probably lived much
like the gray wolves that still trod parts of North America. The sheer number of remains found at the La Brea asphalt
seeps, outnumbering any other large vertebrate by far, only make sense if dire wolves were pack hunters, which falls
into accord with evidence that these carnivores were chasing mid-sized herbivores such as horses. Wolves lack the
grappling abilities of cats, relying instead on their running endurance and jaws, and so the dire wolf has almost
always been envisioned as roving through prehistoric habitats in packs. More than that, some dire wolf remains at
La Brea show painful injuries that would have crippled the animals and yet show signs of healing. This hints that
these dogs had some sort of social support structure that allowed them to survive.
"""

module.exports = (prefix="", max=300, min=4) ->
  length = _.random(min,max)
  "#{prefix} #{_.sampleSize(words, length).join ' ' }"
