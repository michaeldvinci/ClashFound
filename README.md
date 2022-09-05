
# ClashFound

Swift iOS application with companion watchOS app used to store offline schedules generated from your favorite Clashfinder!



[![ClashFound demo](res/clashFound.gif)](https://www.youtube.com/c/MadeByMiro)

Demo explanation: The initial session happens on button press and for some reason all presses require 2 presses to be taken, so that's what's up with the delays when I press the button.

So this basically parses most Clashfinders via HTML tags and [currently implementing] stores to NSUserData, for restoring should you not have your phone.


Roadmap:
* Implement Config
* Implement NSUserData [need to look into if this is best option still]
* Implement reading saved Clashfinders... It can parse the link, but the html will be from the link not including any params after /?
