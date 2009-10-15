require 'rubygems'
require 'bacon'

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'imgur'

Bacon.summary_on_exit

# Globally accessible Imgur API interface
$imgur = Imgur::API.new("bf880aa11869154f1772cea2d3bdcc31")
