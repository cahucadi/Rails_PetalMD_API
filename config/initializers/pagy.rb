require 'pagy/extras/headers'
require 'pagy/extras/overflow'

# default :empty_page (other options :last_page and :exception )
Pagy::VARS[:overflow] = :last_page